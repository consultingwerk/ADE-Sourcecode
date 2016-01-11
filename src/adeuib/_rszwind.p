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
/*----------------------------------------------------------------------------

File: _rszwind.p

Description:
    Resize a window in the UIB.  
    
Input Parameters:
    <None>

Output Parameters:
   <None>

Author:  Wm.T.Wood

Date Created: July 1995

Modified: 
  
----------------------------------------------------------------------------*/

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

/* Don't set _P._FILE-SAVED if the window is a TreeView. (dma) */
DEFINE INPUT PARAMETER pSetSaved AS LOGICAL NO-UNDO.

DEFINE VAR dWth       AS DECIMAL NO-UNDO.
DEFINE VAR dHgt       AS DECIMAL NO-UNDO.
DEFINE VAR h_child    AS WIDGET  NO-UNDO.
DEFINE VAR h_resize   AS WIDGET  NO-UNDO.
DEFINE VAR h_AttrEd   AS HANDLE  NO-UNDO.
DEFINE VAR new-height AS DECIMAL NO-UNDO.
DEFINE VAR new-width  AS DECIMAL NO-UNDO.
DEFINE VAR old-height AS DECIMAL NO-UNDO.
DEFINE VAR old-width  AS DECIMAL NO-UNDO.
      
/* Buffers to hold related objects */
DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_L FOR _L.
         
/* Buffer used for other layouts to be synch'd */
DEFINE BUFFER sync_L FOR _L.
                                
/* This is a workaround for bug #94-07-28-043: VIRTUAL-HEIGHT not set
   on end resize of a window (so contained frames will not fit).
   A second bug (95-08-03-003) is that you can't set the height of a 
   window to some legal values, so use NO-ERROR on the assignment. */
ASSIGN SELF:HEIGHT = SELF:HEIGHT NO-ERROR. 
                                  
/* Get the widget records so we might update them. */
FIND _U WHERE _U._HANDLE = SELF.
FIND _L WHERE RECID(_L) EQ _U._lo-recid.
       
/* If this is a DESIGN-WINDOW, then loop through all the children that
   are SIZE-TO-PARENT and get their minimum sizes. */  
ASSIGN new-width  = SELF:WIDTH  / _L._COL-MULT
       new-height = SELF:HEIGHT  / _L._ROW-MULT
       old-width  = _L._WIDTH
       old-height = _L._HEIGHT.
FOR EACH x_U WHERE x_U._parent-recid eq RECID(_U)
               AND x_U._status ne "DELETED":U
               AND NOT x_U._TYPE MATCHES("*MENU*":U):
  /* Don't size menus, sub-menus, etc. Fix for 98-09-18-041. - jep */

  IF (_U._SUBTYPE = "Design-Window":U AND x_U._size-to-parent) OR
     (x_U._HANDLE:X = 0 AND x_U._HANDLE:Y = 0 AND
      x_U._HANDLE:WIDTH = old-width AND x_U._HANDLE:HEIGHT = old-height) THEN DO:
    /* NOTE that we don't need to worry about the size of SCROLLABLE frames */
    FIND _C WHERE RECID(_C) eq x_U._x-recid.
    IF NOT _C._SCROLLABLE THEN DO:
      RUN adeuib/_minsize.p (RECID(x_U), _L._LO-NAME,  
                             OUTPUT dHgt, OUTPUT dWth).
      IF dWth > new-width THEN new-width = dWth.
      IF dHgt > new-height THEN new-height = dHgt.
    END. /* If not scrollable */
  END. /* If a design window or the frame fits perfectly */
END.  /* For each frame of the window */                        

/* Did we change the minimum size? */
IF new-width * _L._COL-MULT ne _U._HANDLE:WIDTH THEN
  ASSIGN _U._HANDLE:WIDTH = new-width * _L._COL-MULT NO-ERROR.
IF new-height * _L._ROW-MULT ne _U._HANDLE:HEIGHT THEN
  ASSIGN _U._HANDLE:HEIGHT = new-height * _L._ROW-MULT NO-ERROR.


/* Update other layouts if this is the master layout */
IF _L._LO-NAME EQ "MASTER LAYOUT" THEN
  FOR EACH sync_L WHERE sync_L._u-recid EQ _L._u-recid AND
                        sync_L._LO-NAME NE _L._LO-NAME AND
                        /* If _L (the master) is GUI then update ONLY other GUI windows. *
                         * ==> if master ne TTY or synch is GUI then update              *
                         * That's what the next line does...                             */
                        (NOT _L._WIN-TYPE OR sync_L._WIN-TYPE):   
    /* Update the size if it is synched */
    IF NOT sync_L._CUSTOM-SIZE THEN
      ASSIGN sync_L._WIDTH          = _U._HANDLE:WIDTH  / sync_L._COL-MULT
             sync_L._HEIGHT         = _U._HANDLE:HEIGHT / sync_L._ROW-MULT
             sync_L._VIRTUAL-WIDTH  = MAX(sync_L._VIRTUAL-WIDTH , sync_L._WIDTH)
             sync_L._VIRTUAL-HEIGHT = MAX(sync_L._VIRTUAL-HEIGHT, sync_L._HEIGHT).
             
    /* Update the position if it is synched */
    IF NOT sync_L._CUSTOM-POSITION THEN
      ASSIGN sync_L._ROW            = _U._HANDLE:ROW
             sync_L._COL            = _U._HANDLE:COLUMN.
             
  END. /* FOR EACH */
ELSE DO: /* We're not dealing with the master layout */
  /* Check for synchronicity in position- Note that if this is true, then *
   *  the size will have changed also.                                    */
  IF (_L._ROW NE _U._HANDLE:ROW) OR (_L._COL NE _U._HANDLE:COLUMN) THEN
       _L._CUSTOM-POSITION = TRUE.
       
  /* Ascertain synchronicity of size */
  IF (_L._WIDTH  NE _U._HANDLE:WIDTH  / _L._COL-MULT) OR
     (_L._HEIGHT NE _U._HANDLE:HEIGHT / _L._ROW-MULT) 
  THEN _L._CUSTOM-SIZE = TRUE.
END. /* else */

/* Finally, update the current _L info.  We do this down here so that 
 * if this is a non master layout we can see what's changed before 
 * changing it (see the ELSE above) */
ASSIGN /* Row and column could be changed if upper left was moved */
       _L._ROW            = _U._HANDLE:ROW 
       _L._COL            = _U._HANDLE:COLUMN 
       /* Update the other dimensions */
       _L._WIDTH          = _U._HANDLE:WIDTH  / _L._COL-MULT
       _L._HEIGHT         = _U._HANDLE:HEIGHT / _L._ROW-MULT
       _L._VIRTUAL-WIDTH  = MAX(_L._VIRTUAL-WIDTH,_L._WIDTH)
       _L._VIRTUAL-HEIGHT = MAX(_L._VIRTUAL-HEIGHT, _L._HEIGHT).           

/* Set the size of contained "size-to-parent" frames. */
FOR EACH x_U WHERE x_U._parent-recid eq RECID(_U)
               AND x_U._status ne "DELETED":U,
    EACH x_L WHERE RECID(x_L) eq x_U._lo-recid:   
  IF x_U._size-to-parent OR (x_U._HANDLE:X = 0 AND x_U._HANDLE:Y = 0 AND
     x_U._HANDLE:WIDTH = old-width AND x_U._HANDLE:HEIGHT = old-height) THEN DO:
    ASSIGN x_U._HANDLE:WIDTH-P  = _U._HANDLE:WIDTH-P 
           x_U._HANDLE:HEIGHT-P = _U._HANDLE:HEIGHT-P
           x_L._WIDTH           = x_U._HANDLE:WIDTH  / x_L._COL-MULT
           x_L._HEIGHT          = x_U._HANDLE:HEIGHT / x_L._ROW-MULT 
           x_L._VIRTUAL-WIDTH   = x_U._HANDLE:VIRTUAL-WIDTH  / x_L._COL-MULT
           x_L._VIRTUAL-HEIGHT  = x_U._HANDLE:VIRTUAL-HEIGHT / x_L._ROW-MULT 
           .      
    /* Save the handle of at least one child. */
    IF h_child eq ? THEN h_child = x_U._HANDLE.
  END.
END.

/* Make the resized widget the current widget, unless it is a design window, in which
   case use one of the children, if possible.  If the resized widget is the current
   widget, then just ask the Group Property Window to redisplay. */
IF _U._SUBTYPE eq "Design-Window":U AND VALID-HANDLE(h_child)
THEN h_resize = h_child.
ELSE h_resize = SELF.     
IF h_resize ne _h_cur_widg 
THEN RUN changewidg IN _h_UIB (h_resize, yes /* Deselect all */).
ELSE DO:
  /* Show the geometry in the attribute window. */
  RUN get-attribute IN _h_UIB ("Attribute-Window-Handle":U).
  h_AttrEd = WIDGET-HANDLE (RETURN-VALUE).
  IF VALID-HANDLE (h_AttrEd) AND h_AttrEd:FILE-NAME eq "adeuib/_attr-ed.w":U
  THEN RUN show-geometry IN h_AttrEd NO-ERROR.
END.

/* Note that the window needs to be saved. Don't do this if the window is a
   TreeView. (dma) */
IF pSetSaved THEN
  RUN adeuib/_winsave.p (_U._HANDLE, FALSE).

/* _rszwind.p - end of file */
