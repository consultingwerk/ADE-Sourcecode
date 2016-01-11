/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _selcolr.p

Description:
    Ask the user for a new set of colors to use for all the selected widgets.

Input Parameters:
   <none>
Output Parameters:
   <none>
Return Value:
    empty    - normally
    "Cancel" - if user canceled out of the font dialog.

Author: Wm.T.Wood

Date Created: December 16, 1992

Modified:
    06/14/99    tsm     Added support for browse separator fgcolor - changed
                        parameters to _chscolr.p
----------------------------------------------------------------------------*/

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}  
{adeuib/property.i}  /* Contains definiton of Property Temp Table */
{adecomm/oeideservice.i}
/* ===================================================================== */
/*                       Local Variable Definitions                      */
/* ===================================================================== */
DEFINE VAR ans                  AS LOGICAL                           NO-UNDO.
DEFINE VAR can-do_bg            AS CHAR                              NO-UNDO.
DEFINE VAR can-do_fg            AS CHAR                              NO-UNDO.
DEFINE VAR cur_bg               AS INTEGER                           NO-UNDO.
DEFINE VAR cur_fg               AS INTEGER                           NO-UNDO.
DEFINE VAR dflt_bg              AS INTEGER                           NO-UNDO.
DEFINE VAR dflt_fg              AS INTEGER                           NO-UNDO.
DEFINE VAR h                    AS WIDGET                            NO-UNDO.
DEFINE VAR notice               AS CHAR                              NO-UNDO.
DEFINE VAR sep_fg               AS INTEGER                           NO-UNDO.
DEFINE VAR test_bg              AS INTEGER                           NO-UNDO.
DEFINE VAR test_fg              AS INTEGER                           NO-UNDO.
DEFINE VAR tmp_hdl              AS WIDGET-HANDLE                     NO-UNDO.
DEFINE VAR tty_selectedib       AS LOGICAL         INITIAL FALSE     NO-UNDO.
define variable cMsg as character no-undo.

DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER sync_L FOR _L.
   
DEFINE QUERY selected_U FOR _U SCROLLING.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF


/* If user was in the Section Editor, ensure the current design
   window is the same as the one being edited in the Section Editor.
   Fixes 98-10-20-031. - jep */
IF VALID-HANDLE(_h_uib) THEN
  RUN call_sew IN _h_uib ("SE_CHECK_CURRENT_WINDOW":U).


/* Find out where colors can be changed. */
FIND _prop WHERE _prop._name eq "BGCOLOR".
can-do_bg = _prop._widgets.
FIND _prop WHERE _prop._name eq "FGCOLOR".
can-do_fg = _prop._widgets.

/* Change the color of any selected widget.  Also select the Window or Dialog
   box, which are not selectable, but which can be the "current widget".
   The widgets must be able to accept both background and foreground 
   color information. */
OPEN QUERY selected_U 
  FOR EACH _U WHERE (_U._SELECTEDib
                     OR (_U._HANDLE = _h_cur_widg AND 
                         _U._STATUS NE "DELETED":U AND
                         CAN-DO ("DIALOG-BOX,GROUP,WINDOW",_U._TYPE)))
                AND CAN-DO (can-do_bg, _U._TYPE)
                AND CAN-DO (can-do_fg, _U._TYPE).
GET FIRST selected_U.

/* Degenerate case: nothing to change. */
IF NOT AVAILABLE _U THEN DO:
   cmsg =  "There are no selected objects where color can be changed." + "~n" 
        +  "Please select an object with the pointer and try again.".
        
  if OEIDE_CanShowMessage() then
       run ShowOKMessage in hOEIDEService(cmsg,"INFORMATION",?).
  else     
       MESSAGE cmsg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  RETURN.
END.

/* Determine the current colors used */    
ASSIGN cur_bg      = if _h_cur_widg <> ? THEN _h_cur_widg:BGCOLOR ELSE ?
       cur_fg      = if _h_cur_widg <> ? THEN _h_cur_widg:FGCOLOR ELSE ?.

/* --------------------------------------
    Determine the normal default color. 
   -------------------------------------- */

/* Get the colors of the first selected widget. Also get the default BGCOLOR
   and FGCOLOR for that widget [Default = ? for Frames/Windows; default = frame
   color for field level widgets.] */
FIND _L WHERE RECID(_L) = _U._lo-recid.
ASSIGN cur_bg  = _L._BGCOLOR
       cur_fg  = _L._FGCOLOR.
       
IF CAN-DO("DIALOG-BOX,FRAME,WINDOW",_U._TYPE) 
THEN ASSIGN dflt_bg = ?
            dflt_fg = ?.
ELSE ASSIGN h = _U._HANDLE:PARENT
            h = h:PARENT
            dflt_bg = h:BGCOLOR
            dflt_fg = h:FGCOLOR.
/* See if another selected widget has different default colors.  If so, then
   set the default to ? and stop checking. */
CHECK-LOOP:
REPEAT:
  GET NEXT selected_U.
  IF NOT AVAILABLE _U THEN LEAVE CHECK-LOOP.
  ELSE DO:
    IF CAN-DO("DIALOG-BOX,FRAME,WINDOW",_U._TYPE) 
    THEN ASSIGN test_bg = ?
                test_fg = ?.
    ELSE ASSIGN h = _U._HANDLE:PARENT
                h = h:PARENT
                test_bg = h:BGCOLOR
                test_fg = h:FGCOLOR.
    IF dflt_bg ne test_bg OR dflt_fg ne test_fg THEN DO:
      ASSIGN dflt_bg = ?
             dflt_fg = ?.
      LEAVE CHECK-LOOP.
    END.
  END. 
END.

/* Are there any selected buttons or images (under windows). */
notice = "".
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
IF CAN-FIND (FIRST x_U WHERE x_U._SELECTEDib AND x_U._TYPE eq "BUTTON") THEN 
  notice = "Button".
IF CAN-FIND (FIRST x_U WHERE x_U._SELECTEDib AND x_U._TYPE eq "IMAGE") THEN
  notice = (IF notice ne "" THEN notice + " and " ELSE "") + "Image".
/* Finish the notice. */
IF notice ne "" THEN 
 notice = notice + " color not supported under {&WINDOW-SYSTEM}.".
&ENDIF

/* Choose the color. */
IF OEIDEIsRunning THEN
RUN adeuib/ide/_dialog_chscolr.p 
    (INPUT "Choose Color",  
     INPUT notice,
     INPUT FALSE,          /* separators */
     INPUT dflt_bg,
     INPUT dflt_fg,
     INPUT ?,              /* separators */
     INPUT-OUTPUT cur_bg, 
     INPUT-OUTPUT cur_fg, 
     INPUT-OUTPUT sep_fg,  /* separators */
     OUTPUT ans).
ELSE
RUN adecomm/_chscolr.p 
    (INPUT "Choose Color",  
     INPUT notice,
     INPUT FALSE,          /* separators */
     INPUT dflt_bg,
     INPUT dflt_fg,
     INPUT ?,              /* separators */
     INPUT-OUTPUT cur_bg, 
     INPUT-OUTPUT cur_fg, 
     INPUT-OUTPUT sep_fg,  /* separators */
     OUTPUT ans).
IF ans = NO THEN RETURN "Cancel":U.  /* User cancelled change */
  
/* set the window-saved state to false */
RUN adeuib/_winsave.p(_h_win, FALSE).

/* Change selected, non-tty (_win-type = true) widgets. Note that a tty
   widget was selected. Also change color of _h_cur_widg when it is a 
   window or dialog box (which are not selecactable). */
GET FIRST selected_U.
DO WHILE AVAILABLE _U:
  FIND _L WHERE RECID(_L) = _U._lo-recid.
  IF NOT _L._WIN-TYPE THEN tty_selectedib = TRUE.
  ELSE DO:
    ASSIGN tmp_hdl = _U._HANDLE.
    /* If a frame and the title is same as frame, change the title too */
    IF CAN-DO("FRAME,BROWSE,DIALOG-BOX":U,_U._TYPE) THEN DO:
      FIND _C WHERE RECID(_C) = _U._x-recid.
      IF _L._TITLE-BGCOLOR = _L._BGCOLOR AND _L._TITLE-FGCOLOR = _L._FGCOLOR THEN DO:
         ASSIGN dflt_bg           = _L._TITLE-BGCOLOR
                dflt_fg           = _L._TITLE-FGCOLOR 
                _L._TITLE-BGCOLOR = cur_bg
                _L._TITLE-FGCOLOR = cur_fg.
         IF _L._LO-NAME = "Master Layout" THEN DO:
           FOR EACH sync_L WHERE sync_L._u-recid = _L._u-recid AND
                                 sync_L._LO-NAME NE _L._LO-NAME:
             if sync_l._TITLE-BGCOLOR = dflt_bg THEN
                  sync_L._TITLE-BGCOLOR = _L._TITLE-BGCOLOR.
             IF sync_L._TITLE-FGCOLOR = dflt_fg THEN
                 sync_L._TITLE-FGCOLOR = _L._TITLE-FGCOLOR.
           END.
         END.  /* If this was the master layout */
         /* Don't set color in simulated widgets that don't support it. */
        IF CAN-SET(_U._HANDLE, "TITLE-BGCOLOR":U)  
        THEN ASSIGN tmp_hdl:TITLE-BGCOLOR = cur_bg
                    tmp_hdl:TITLE-FGCOLOR = cur_fg.
      END.
    END. /* If a frame */ 
    ASSIGN dflt_bg                = _L._BGCOLOR
           dflt_fg                = _L._FGCOLOR
           _L._BGCOLOR            = cur_bg
           _L._FGCOLOR            = cur_fg
           tmp_hdl:BGCOLOR        = cur_bg
           tmp_hdl:FGCOLOR        = cur_fg.
           
    IF _L._LO-NAME = "Master Layout" THEN DO:
      FOR EACH sync_L WHERE sync_L._u-recid = _L._u-recid AND
                            sync_L._LO-NAME NE _L._LO-NAME:
        if sync_l._BGCOLOR = dflt_bg THEN sync_L._BGCOLOR = _L._BGCOLOR.
        IF sync_L._FGCOLOR = dflt_fg THEN sync_L._FGCOLOR = _L._FGCOLOR.
      END.
    END.  /* If this was the master layout */
    
  END.
  /* Move to next selected widget */
  GET NEXT selected_U.
END. /* FOR EACH ... */

/* If some of the selected widgets were TTY then ask if the user wants to
   change the color of all TTY widgets. */
IF tty_selectedib THEN DO:
  if OEIDE_CanShowMessage() then
     run ShowMessage in hOEIDEService("Some selected objects were in a Character Simulator window. ~n
                              Do you want to change the Character Simulator Colors everywhere?",
                              "Question",?,"YES-NO",input-output ans). 
  else      
  MESSAGE "Some selected objects were in a Character Simulator window." {&SKP}
          "Do you want to change the Character Simulator Colors everywhere?"
    VIEW-AS alert-box QUESTION BUTTONS YES-NO UPDATE ans.
    
  IF ans THEN RUN adeuib/_updtclr.p (cur_fg, cur_bg).
END.
