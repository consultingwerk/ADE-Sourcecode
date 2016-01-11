&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
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
/*--------------------------------------------------------------------------
    Library     : panelsiz.i
    Purpose     : Adds a SET-SIZE method for standard ADM SmartPanels.

    Description : This include file defines the variable
                    adm-button-count - the number of buttons on a panel
                  This variable is automatically inititialized by
                  calling count-buttons.
                  
                  The variable is used by the SET-SIZE method, that is
                  called by the SmartContainer holding the SmartPanel

    Author(s)   : Wm.T.Wood
    Created     : July 1995
    Modified    : 
      wood 12/1/95 Make Panel SCROLLABLE (to allow resizing when GRID-SNAP 
                   is off.) 
      wood 12/1/95 Support new attribue 'Margin-Pixels', which is the gap,
                   in pixels, from the frame border to the panel buttons.
      wood 4/22/96 Exclude "Run count-buttons" if routine is not defined.
                   Add support for a  ~{&LABEL} preprocessor that points
                   to a text widget.
                   
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE adm-button-count AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* ----------------------- Set up for Panel Sizing -------------------- */
/* Automatically count the buttons. Note that sizing does not work except
   on SCROLLABLE frames (when dynamic resizing makes the panel smaller), 
   so set the frame to be scrollable.  */
&IF DEFINED(EXCLUDE-count-buttons) = 0 &THEN
  RUN count-buttons NO-ERROR.
&ENDIF
&IF DEFINED(EXCLUDE-set-size) = 0 &THEN
  ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE = yes.
&ENDIF

/* --------------------------- End of set up -------------------------- */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-count-buttons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE count-buttons Method-Library 
PROCEDURE count-buttons :
/*------------------------------------------------------------------------------
  Purpose:   Walk the widget tree of the frame and count all the buttons.  
  Parameters:  <none>
  Notes:     This sets the variable "adm-button-count".     
------------------------------------------------------------------------------*/
  DEFINE VAR h        AS WIDGET  NO-UNDO.
  
  /* Loop through all the button children and count them. */
  ASSIGN h  = FRAME {&FRAME-NAME}:CURRENT-ITERATION
         h  = h:FIRST-CHILD
         adm-button-count = 0
         .
  DO WHILE VALID-HANDLE (h):
    /* Get all the statically defined buttons in the frame. (We don't want
       the little UIB-generated button in the upper-left corner). */
    IF h:DYNAMIC eq no AND h:TYPE eq "BUTTON":U THEN DO:
       adm-button-count = adm-button-count + 1.
    END.
    /* Get the next child. */
    h = h:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-size) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-size Method-Library 
PROCEDURE set-size :
/*------------------------------------------------------------------------------
  Purpose: Changes the size and shape of the panel.  This routine
           spaces the buttons to fill the available space.  
  Parameters: 
           pd_height - the desired height (in rows)
           pd_width  - the desired width (in columns)
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
    
  DEFINE VAR btn-height-p  AS INTEGER NO-UNDO.
  DEFINE VAR btn-width-p   AS INTEGER NO-UNDO.  
  DEFINE VAR btn-X         AS INTEGER NO-UNDO.
  DEFINE VAR btn-Y         AS INTEGER NO-UNDO.
  DEFINE VAR h             AS WIDGET  NO-UNDO.
  DEFINE VAR i_margin      AS INTEGER NO-UNDO. /* Margin from frame to buttons */
  DEFINE VAR i_border-h    AS INTEGER NO-UNDO. /* Horizontal frame border      */
  DEFINE VAR i_border-v    AS INTEGER NO-UNDO. /* Vertical frame border        */
  DEFINE VAR i_box-y       AS INTEGER NO-UNDO. /* Start of BOX-RECTANGLE       */
  DEFINE VAR i_lbl-hgt-p   AS INTEGER NO-UNDO. /* Height of (label) Font       */
  DEFINE VAR i_test        AS INTEGER NO-UNDO.    
  DEFINE VAR i_height-p    AS INTEGER NO-UNDO. /* Desired frame height, pixels */
  DEFINE VAR i_width-p     AS INTEGER NO-UNDO. /* Desired frame width, pixels  */
  DEFINE VAR ic            AS INTEGER NO-UNDO.
  DEFINE VAR ir            AS INTEGER NO-UNDO.    
  DEFINE VAR l_hidden      AS LOGICAL NO-UNDO.
  DEFINE VAR l_box-hidden  AS LOGICAL NO-UNDO.
  DEFINE VAR l_selected    AS LOGICAL NO-UNDO.
  DEFINE VAR min-height    AS DECIMAL NO-UNDO. /* Minumum frame height, chars  */
  DEFINE VAR min-width     AS DECIMAL NO-UNDO. /* Minumum frame width, chars   */
  DEFINE VAR num-rows      AS INTEGER NO-UNDO.
  DEFINE VAR num-cols      AS INTEGER NO-UNDO.
  DEFINE VAR p-width-p     AS INTEGER NO-UNDO. /* Width of all panel buttons   */
  DEFINE VAR p-height-p    AS INTEGER NO-UNDO. /* Height of all panel buttons  */
  
  DO WITH FRAME {&FRAME-NAME}:
    /* The margin is based on the standard column width, unless specified
       as an attribute. The margin is 0 for character mode SmartObjects. */
    &IF "{&WINDOW-SYSTEM}" eq "TTY" &THEN
      i_margin = 0.
    &ELSE
      RUN get-attribute IN THIS-PROCEDURE ('Margin-Pixels':U).
      IF RETURN-VALUE eq ? 
      THEN i_margin = SESSION:PIXELS-PER-COLUMN.
      ELSE i_margin = INTEGER(RETURN-VALUE).
    &ENDIF
    /* If there is a label, then this will move the top margin. */      
    &IF "{&Label}" ne "" &THEN
      IF {&Label}:SCREEN-VALUE ne "":U THEN DO:
       i_lbl-hgt-p = FONT-TABLE:GET-TEXT-HEIGHT-P (FRAME {&FRAME-NAME}:FONT).
       &IF "{&Box-Rectangle}" ne ""
       &THEN i_box-Y = MAX(0, i_lbl-hgt-p - {&Box-Rectangle}:EDGE-PIXELS) / 2.
       &ELSE i_box-Y = i_lbl-hgt-p.
       &ENDIF
      END.
    &ELSE
    ASSIGN i_lbl-hgt-p = 0
           i_box-Y     = 0.
    &ENDIF    
    
    /* How many rows should there be? We assume rows should be about one ROW
       high, though this might be fudged later. */
    ASSIGN num-rows = TRUNCATE( pd_height - 2 * (i_margin / SESSION:PIXELS-PER-ROW),0)
           num-rows = MAX (1, MIN (adm-button-count, num-rows))
           num-cols = adm-button-count / num-rows
           .  
    /* Do we have enough rows and columns to hold all the buttons? If not add
       another row or column. (We add the smaller of the two so there will be a minimun
       of wasted spaces.)  */
    DO WHILE num-cols * num-rows < adm-button-count:
      IF num-cols > num-rows
      THEN num-cols = num-cols + 1.
      ELSE num-rows = num-rows + 1. 
    END. 
    
    /* Check that the last row is not empty. */
    DO WHILE num-cols * (num-rows - 1) >= adm-button-count:
      num-rows = num-rows - 1.
    END.
           
    /* Don't allow a size that won't hold the margins, the frame borders, the 
       label and the UIB "affordance" menu (about 16 pixels square, located at 
       (4,4)) [Add in an extra 2 pixels for a fudge factor].
       Note that if we need to increase the size based on a minumum, 
       then we will need to verify that the frame will still fit in its parent.  One final check
       is to guarantee that each row and column is at least one pixel (this is only
       a problem if you have more than about 16 buttons). This minimum only applies
       on MS-Windows, because that is where the object will be used inside the UIB */
     &IF "{&WINDOW-SYSTEM}" eq "TTY" &THEN
       &Scoped-define min-p 0
     &ELSE
       &Scoped-define min-p 22
     &ENDIF
     ASSIGN 
         min-height = (MAX ({&min-p}, num-rows + (2 * i_margin) + i_box-Y, i_lbl-hgt-p) / SESSION:PIXELS-PER-ROW) +
                       FRAME {&FRAME-NAME}:BORDER-TOP + 
                       FRAME {&FRAME-NAME}:BORDER-BOTTOM  
         min-width  = (MAX ({&min-p}, num-cols + 2 * i_margin) / SESSION:PIXELS-PER-COLUMN) + 
                       FRAME {&FRAME-NAME}:BORDER-LEFT + 
                       FRAME {&FRAME-NAME}:BORDER-RIGHT.   
    
    /* Hide the frame to reduce "flashing". Remember if it was already
       hidden, so we don't view it unnecessarily at the end of this
       procedure. (NOTE: Hiding a SELECTED frame turns off the Selection, 
       so we save the value to use when we make the Frame visible again.) */
    ASSIGN l_selected = FRAME {&FRAME-NAME}:SELECTED 
           l_hidden   = FRAME {&FRAME-NAME}:HIDDEN 
           FRAME {&FRAME-NAME}:HIDDEN = yes
           NO-ERROR.
           
    /* Do we need to adjust the size (and position). */
    IF min-height > pd_height OR min-width > pd_width THEN DO:
      /* Get the parent to insure that the frame will still fit inside it. */ 
      h = FRAME {&FRAME-NAME}:PARENT.
      IF h:TYPE ne "WINDOW":U THEN h = FRAME {&FRAME-NAME}:FRAME.
      /* Test width. */  
      IF min-width > pd_width THEN DO:
        ASSIGN pd_width  = min-width
               i_width-p = 1 + (pd_width * SESSION:PIXELS-PER-COLUMN)
               i_test    = IF h:TYPE eq "WINDOW":U OR h:SCROLLABLE
                           THEN h:VIRTUAL-WIDTH-P
                           ELSE h:WIDTH-P - h:BORDER-LEFT-P - h:BORDER-RIGHT-P.
        IF i_test < FRAME {&FRAME-NAME}:X + i_width-p 
        THEN ASSIGN FRAME {&FRAME-NAME}:X = MAX(0, i_test - i_width-p) NO-ERROR.
      END.
      /* Test height. */
      IF min-height > pd_height THEN DO:
        ASSIGN pd_height  = min-height 
               i_height-p = 1 + (pd_height * SESSION:PIXELS-PER-ROW)
               i_test     = IF h:TYPE eq "WINDOW":U OR h:SCROLLABLE
                            THEN h:VIRTUAL-HEIGHT-P
                            ELSE h:HEIGHT-P - h:BORDER-TOP-P - h:BORDER-BOTTOM-P.
        IF i_test < FRAME {&FRAME-NAME}:Y + i_height-p 
        THEN ASSIGN FRAME {&FRAME-NAME}:Y = MAX(0, i_test - i_height-p) NO-ERROR.
      END.
    END.
 
    /* Resize the frame and determine values based on the desired size. */
    ASSIGN 
        FRAME {&FRAME-NAME}:SCROLLABLE = yes
        FRAME {&FRAME-NAME}:WIDTH      = pd_width
        FRAME {&FRAME-NAME}:HEIGHT     = pd_height
        /* Convert from Decimal width and height be reading from the 
           FRAME itself. */
        i_width-p    = FRAME {&FRAME-NAME}:WIDTH-P
        i_height-p   = FRAME {&FRAME-NAME}:HEIGHT-P
        /* Save the calculation of frame borders. */
        i_border-v   = FRAME {&FRAME-NAME}:BORDER-TOP-P +
                       FRAME {&FRAME-NAME}:BORDER-BOTTOM-P
        i_border-h   = FRAME {&FRAME-NAME}:BORDER-LEFT-P +
                       FRAME {&FRAME-NAME}:BORDER-RIGHT-P
        /* Compute the total width/height of the buttons in the panel. 
           That is, subtract all the margins, decoration, and borders 
           from the frame size. */
        p-width-p    = i_width-p - i_border-h - (2 * i_margin)
        p-height-p   = i_height-p - i_border-v - i_box-Y - (2 * i_margin)
      NO-ERROR.
       
    /* Loop through all the button children and move them. */
    ASSIGN h     = FRAME {&FRAME-NAME}:CURRENT-ITERATION
           h     = h:FIRST-CHILD
           ic    = 0
           ir    = 1
           btn-X = i_margin 
           btn-Y = i_margin + i_box-Y
           btn-height-p = p-height-p / num-rows
           .
    DO WHILE VALID-HANDLE (h):
      /* Get all the statically defined buttons in the frame. (We don't want
         the little UIB-generated button in the upper-left corner). */
      IF h:DYNAMIC eq no AND h:TYPE eq "BUTTON":U THEN DO:
        /* We compute the button width and height for every row and column 
           independently. This is because we want the total size of the buttons
           to be the desired size. But each button must be an integer number of
           pixels. The round-off error can accumulate for a large panel.
           (e.g. 7 buttons in 40 pixels would mean either buttons 5 or 6 pixels
           wide. Unless we mix the sizing, then there will be only 35 pixels
           total (35 = 7 * 5). The algorithm below will have 5 buttons 6 pixels
           high and two buttons only 5 pixels high. */
        ASSIGN ic = ic + 1.
        IF ic > num-cols 
        THEN ASSIGN 
               ic    = 1
               ir    = ir + 1
               btn-X = i_margin
               btn-Y = (p-height-p * (ir - 1) / num-rows) + i_margin + i_box-Y
               btn-height-p = (p-height-p * ir / num-rows) + i_margin + i_box-Y -
                               btn-Y.
        /* Hide the button before resizing (in case we are setting the width
           and height to be larger than the frame will accomodate). */
        ASSIGN h:HIDDEN   = yes 
               h:WIDTH-P  = ((p-width-p * ic / num-cols) + i_margin) - btn-X
               h:HEIGHT-P = btn-height-p
               h:X        = btn-X
               h:Y        = btn-Y
               btn-X      = h:X + h:WIDTH-P
               h:HIDDEN   = NO
             NO-ERROR.
      END.
      /* Get the next child. */
      h = h:NEXT-SIBLING.
    END.
    
    /* If defined, set the Bounding Rectangle size. */
    &IF "{&Box-Rectangle}" ne "" &THEN
      ASSIGN l_box-hidden              = {&Box-Rectangle}:HIDDEN
             {&Box-Rectangle}:HIDDEN   = yes
             {&Box-Rectangle}:X        = 0
             {&Box-Rectangle}:Y        = i_box-Y
             {&Box-Rectangle}:WIDTH-P  = i_width-p - i_border-h
             {&Box-Rectangle}:HEIGHT-P = i_height-p - i_border-v - i_box-Y
             {&Box-Rectangle}:HIDDEN   = l_box-hidden             
            NO-ERROR.
    &ENDIF

    /* If defined, set the LABEL width. */
    &IF "{&Label}" ne "" &THEN
      ASSIGN {&Label}:HIDDEN   = yes
             {&Label}:X        = i_margin
             {&Label}:Y        = 0 
             {&Label}:WIDTH-P  = MIN(FONT-TABLE:GET-TEXT-WIDTH-P 
                                     ({&Label}:SCREEN-VALUE, FRAME {&FRAME-NAME}:FONT),
                                    i_width-p - {&Label}:X - i_border-h) 
             {&Label}:HEIGHT-P = MIN(i_lbl-hgt-p, i_height-p - i_border-v)
             {&Label}:HIDDEN   = ({&LABEL}:SCREEN-VALUE eq "":U)                                
            NO-ERROR.
    &ENDIF


    /* Show the frame. Turn off SCROLLABLE to force virtual size to match
       viewport size.  We will turn SCROLLABLE back on so that the SmartPanel
       can be resized smaller. */
    ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE       = NO
           FRAME {&FRAME-NAME}:WIDTH-P          = i_width-p
           FRAME {&FRAME-NAME}:HEIGHT-P         = i_height-p
           NO-ERROR .  
    /* Frame must be SCROLLABLE if it is to be resized smaller than its
       contained buttons and rectangles. */    
    ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE = YES.
            
    /* View, and select, the frame, if necessary. */
    IF NOT l_hidden THEN FRAME {&FRAME-NAME}:HIDDEN   = no NO-ERROR.
    IF l_selected   THEN FRAME {&FRAME-NAME}:SELECTED = yes.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

