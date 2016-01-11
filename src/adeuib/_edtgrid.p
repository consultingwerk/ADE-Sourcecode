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

File: gridedit.p

Description:
    This lets the user edit the grid.  NOTE: grids are entered here as the
    minor size.  In progress, the user enters the major grid lines (i.e. 
    minor size * subdivisions).
Input Parameters:
   title_txt : a string to use as the title.  If this is blank then
   	       the value is set to "Grid"
Output Parameters:
   changed : logical that is set to TRUE if any changes occured.
      	
Author: William T. Wood

Date Created: September 11, 1992 

----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  title_txt 	       AS CHAR INITIAL "Grid"  NO-UNDO.
DEFINE OUTPUT PARAMETER changed 	       AS LOGICAL              NO-UNDO.
 
/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
&GLOBAL-DEFINE WIN95-BTN TRUE
{adecomm/adestds.i} /* Standard Definitions             */ 
{adeuib/uibhlp.i}   /* Help pre-processor directives    */
{adeuib/std_dlg.i}  /* Standard ADE dialog include file */
{adeuib/gridvars.i} /* Current values for grids         */

/* Standard Decimal format in this procedure. */
&Scoped-define dfmt >>9.99

/* ===================================================================== */
/*                    LOCAL VARIABLES Definitions                        */
/* ===================================================================== */

DEFINE VAR h-unit	AS DECIMAL  FORMAT "{&dfmt}"
	LABEL "Width":R6 {&STDPH_FILL} NO-UNDO.
DEFINE VAR v-unit	LIKE h-unit LABEL "Height":R7 {&STDPH_FILL} NO-UNDO.

DEFINE VAR min-col	AS DECIMAL   FORMAT "{&dfmt}" NO-UNDO.
DEFINE VAR min-row	LIKE min-col NO-UNDO.

DEFINE VAR init-h-trunc AS DECIMAL NO-UNDO.
DEFINE VAR init-v-trunc AS DECIMAL NO-UNDO.
DEFINE VAR init-h-mod   AS INTEGER NO-UNDO.
DEFINE VAR init-v-mod   AS INTEGER NO-UNDO.
DEFINE VAR init-layout  AS LOGICAL NO-UNDO.

DEFINE VAR h-factor	AS INTEGER  FORMAT ">>9   "
	LABEL "Horizontal":R11 {&STDPH_FILL} NO-UNDO.
DEFINE VAR v-factor	LIKE h-factor LABEL "Vertical":R10 	       NO-UNDO.

DEFINE VAR unit_txt     AS CHAR		FORMAT "X(10)" 	               NO-UNDO.
DEFINE VAR layout_unit	AS LOGICAL	INITIAL TRUE		       NO-UNDO 
       LABEL "Layout Units" VIEW-AS RADIO-SET HORIZONTAL
       RADIO-BUTTONS "Character", TRUE, "Pixel", FALSE.

/* Buttons for the bottom of the screen                                      */
DEFINE BUTTON btn_ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_cancel LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_help   LABEL "&Help":C12  {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
&ENDIF

DEFINE FRAME f-edit 
        SKIP({&TFM_WID})
	"Grid Unit Size:  (Graphical Windows Only)" AT 2 VIEW-AS TEXT
        SKIP({&VM_WID}) SKIP({&VM_WID})
	h-unit 			COLON 14  
	v-unit			COLON 35
        SKIP({&VM_WIDG})
	"Grid Units Between Major Lines:" AT 2 VIEW-AS TEXT
	SKIP({&VM_WID}) SKIP({&VM_WID})
	h-factor		COLON 14 
        v-factor  		COLON 35
        SKIP({&VM_WIDG})
        layout_unit             AT 2

   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &HELP   = btn_Help}

     WITH SIDE-LABELS DEFAULT-BUTTON btn_Ok TITLE title_txt
     	  VIEW-AS DIALOG-BOX.

ASSIGN layout_unit:HEIGHT = 1.125.

/* Use ade standards dialog includes -- this also makes WINDOW-CLOSE act
   like END-ERROR. */
{adeuib/std_dlg.i &FRAME_CLOSE = f-edit}

/* Make all sizes fill-ins have the correct format for the              */
/* current layout unit.   INPUTS: l_PPU = TRUE if character units       */
PROCEDURE set_dim_format.
  DEFINE INPUT PARAMETER l_PPU  AS LOGICAL              NO-UNDO.
  
  DEFINE VAR fmt    AS CHAR                 NO-UNDO.   
  ASSIGN fmt = (IF l_PPU THEN "{&dfmt}" ELSE ">,>>9") 
         h-unit:FORMAT IN FRAME f-edit = fmt
         v-unit:FORMAT IN FRAME f-edit = fmt
    NO-ERROR.
END.

/* Help triggers */
ON CHOOSE OF btn_help IN FRAME f-edit OR HELP OF FRAME f-edit
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Grid_Units_Dlg_Box}, ? ).

/* Change the units */
ON VALUE-CHANGED OF layout_unit IN FRAME f-edit DO:
  DEFINE VAR i AS INTEGER NO-UNDO.
  
  /* This code gets around a 4GL bug where value-changed is
     issued even if value did not change */
  IF SELF:SCREEN-VALUE <> STRING(layout_unit) 
  THEN DO WITH FRAME f-edit:
    ASSIGN layout_unit 
    	   v-unit
    	   h-unit
    	   .
    IF layout_unit AND init-layout THEN DO:
      /* Keep the rounding the same as it was initially.  We only do this
         if the initial layout was "Character" and we are converting from
         "Pixels" back to "Character". This lets us keep the initial values.  
         
         For example, suppose there are 7 Pixels/Column, and the initial 
         value of h-unit is 0.5 columns.
         
         If the user converts this to pixels, they will get 3.  Converting
         back would normally give 3/7.  We want it to give 0.5 again.  
         Therefore we have saved the initial remainder as 
                init-v-mod = 3   maps to  init-v-trunc = 0.5
         Whenever the user pixel measurement is 3 off an integer number
         of rows (i.e. v-unit MOD SESSION:PIXELS-PER-ROW eq init-v-mod)
         we use 0.5 as the row remainder.   */
         
      IF v-unit MOD SESSION:PIXELS-PER-ROW eq init-v-mod
      THEN ASSIGN i = TRUNCATE(v-unit / SESSION:PIXELS-PER-ROW, 0)
                  v-unit = i + init-v-trunc.
      ELSE ASSIGN v-unit = ROUND( v-unit / SESSION:PIXELS-PER-ROW, 2).
      /* Do the same for units of width. */
      IF h-unit MOD SESSION:PIXELS-PER-COLUMN eq init-h-mod
      THEN ASSIGN i = TRUNCATE(h-unit / SESSION:PIXELS-PER-COLUMN, 0) 
                  h-unit = i + init-h-trunc.
      ELSE ASSIGN h-unit = ROUND( h-unit / SESSION:PIXELS-PER-COLUMN, 2).
    END.        
    ELSE DO:
      ASSIGN
           v-unit  = IF layout_unit 
                     THEN ROUND( v-unit / SESSION:PIXELS-PER-ROW, 2)
                     ELSE ROUND( v-unit * SESSION:PIXELS-PER-ROW, 0)
           h-unit  = IF layout_unit 
                     THEN ROUND( h-unit / SESSION:PIXELS-PER-COLUMN, 2)
                     ELSE ROUND( h-unit * SESSION:PIXELS-PER-COLUMN, 0)
           changed = TRUE.
    END.
    
    /* Change the formats and redisplay */
    RUN set_dim_format (layout_unit).
    DISPLAY h-unit v-unit WITH FRAME f-edit.
  END.
END.

/* SETUP: Setup the  dialog box.   */
ASSIGN layout_unit = _cur_layout_unit
       unit_txt    = IF layout_unit THEN "characters" ELSE "pixels"
       h-unit      = _cur_grid_wdth
       v-unit      = _cur_grid_hgt
       h-factor    = _cur_grid_factor_h
       v-factor    = _cur_grid_factor_v 
       h-unit:AUTO-RESIZE IN FRAME f-edit = NO
       v-unit:AUTO-RESIZE IN FRAME f-edit = NO      
       min-col     = ROUND(1 / SESSION:PIXELS-PER-COLUMN, 2)
       min-row     = ROUND(1 / SESSION:PIXELS-PER-ROW, 2)      
       changed     = FALSE.   /* This may change later */
/* Save some initial values to handle some round off problems. 
   Suppose Pixels-per-row is 25 and pixels-per-column is 7.  
   The initial values are a grid 1.25 columns by 0.5 rows. */
init-layout = layout_unit.
IF init-layout /* Character */ THEN DO:
  ASSIGN init-h-trunc = h-unit - TRUNCATE(h-unit, 0)           /* 0.25 */
  	 init-v-trunc = v-unit - TRUNCATE(v-unit, 0)           /* 0.5 */
  	 init-h-mod = init-h-trunc * SESSION:PIXELS-PER-COLUMN /* .25 * 7 = 2 */ 
  	 init-v-mod = init-v-trunc * SESSION:PIXELS-PER-ROW    /* .5 * 25 = 13 */
  	 .
END.
  	 
/* Change the format if we need to */
IF NOT layout_unit THEN RUN set_dim_format (FALSE).

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "FRAME f-edit" 
   &BOX   = "rect_Btns"
   &OK    = "btn_OK" 
   &HELP  = "btn_Help"
}

/* This is the transaction that is done if OK is clicked, or not done if     */
/* CANCEL is clicked.  Note that CANCEL has the endkey property.             */
chng-grid:
DO TRANSACTION ON ENDKEY UNDO, LEAVE:
  IF NOT RETRY 
  THEN UPDATE 
  	h-unit VALIDATE (IF layout_unit THEN h-unit >= min-col ELSE h-unit > 0,
  	                 "Grid unit width must be greater than " +
  	                 (IF layout_unit THEN TRIM(STRING(min-col,"{&dfmt}":U))
  	                  ELSE "1") + 
  	                 ".")
        v-unit VALIDATE (IF layout_unit THEN v-unit >= min-row ELSE v-unit > 0,
  	                 "Grid unit height must be greater than " +
  	                 (IF layout_unit THEN TRIM(STRING(min-row,"{&dfmt}":U))
  	                  ELSE "1") + 
  	                 ".")
        h-factor VALIDATE (h-factor > 0,"There must be at least 1 division.")
        v-factor VALIDATE (v-factor > 0,"There must be at least 1 division.")
        layout_unit
      btn_ok btn_cancel btn_help WITH FRAME f-edit.
  
  /* Has anything changed -- if not we don't have to redraw all the grids
     on on the frames */
  changed = (layout_unit <> _cur_layout_unit) OR (h-unit <> _cur_grid_wdth) OR
  	    (v-unit <> _cur_grid_hgt) OR (h-factor <> _cur_grid_factor_h) OR
  	    (v-factor <> _cur_grid_factor_v).
  	     
  /* If we get here then everything is and we should update everything */
  IF changed 
  THEN ASSIGN _cur_layout_unit		= layout_unit
	      _cur_grid_hgt		= v-unit	
	      _cur_grid_wdth		= h-unit
	      _cur_grid_factor_h	= h-factor
	      _cur_grid_factor_v	= v-factor.
  
END.  /* TRANSACTION  - chng-grid  Concludes the grid change transaction */
       
HIDE FRAME f-edit.
