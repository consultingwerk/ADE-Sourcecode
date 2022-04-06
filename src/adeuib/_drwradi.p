/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _drwradi.p

Description:
    Draw a radio set in the current h_frame.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

----------------------------------------------------------------------------*/

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

/* ---------------------------- LOCAL CONSTANTS --------------------------- */

DEFINE VAR dflt-item    AS CHAR NO-UNDO.
DEFINE VAR scrn-value   AS CHAR NO-UNDO.
DEFINE VAR i            AS INTEGER NO-UNDO.
DEFINE VAR item-cnt     AS INTEGER NO-UNDO.
DEFINE VAR cur-lo       AS CHARACTER NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER x_U      FOR _U.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.


/* Standard End-of-line character */
&Scoped-define EOL  CHR(10)

&Scoped-define min-height-chars 0.2
&Scoped-define min-cols 0.4

/* Get the RECID of the parent frame */
FIND parent_U WHERE parent_U._HANDLE = _h_frame.
FIND parent_L WHERE RECID(parent_L)  = parent_U._lo-recid.

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _L.
CREATE _F.

ASSIGN /* Type-specific settings */
       _count[{&RADIO}]     = _count[{&RADIO}] + 1
       _U._NAME             = "RADIO-SET-" + STRING(_count[{&RADIO}])
       _U._TYPE             = "RADIO-SET":U

       _F._DATA-TYPE	    = "Integer":U
       _F._HORIZONTAL       = ?      /* Check this later                    */
       _L._NO-LABELS        = TRUE   /* No label on multi-line widgets      */
       _F._LIST-ITEMS       = ?      /* Custom Section might populated this */ 
       /* Standard Settings for Universal and Field records */
       { adeuib/std_uf.i &SECTION = "DRAW-SETUP" }
       .
/* Set the widget size based on what the user drew (or use a minimum size
   if the user just clicked).
   NOTE: This may be overridden in the Custom Section.  */
IF (_second_corner_x eq _frmx) AND (_second_corner_y eq _frmy) 
THEN ASSIGN _L._WIDTH  = 12    /* "( ) String 3" = 12 chars */
            _L._HEIGHT = &IF "{&WINDOW-SYSTEM}" eq "OSF/MOTIF" &THEN 3.36
                         &ELSE 3 &ENDIF .
ELSE ASSIGN _L._WIDTH  = (_second_corner_x - _frmx + 1) /
                          SESSION:PIXELS-PER-COLUMN / _cur_col_mult 
            _L._HEIGHT = (_second_corner_y - _frmy + 1) / 
                          SESSION:PIXELS-PER-ROW / _cur_row_mult.
 
/* Are there any custom widget overrides?  */
IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).
 
/* Set the Horizontal or Vertical, unless user-specified. Do we draw the
   radio-set vertically? YES, except when the user  has explicitly drawn 
   out a long narrow box. */
IF _F._HORIZONTAL eq ?        
THEN _F._HORIZONTAL = (_L._WIDTH > 5 and _L._HEIGHT < 1.9).

/* If there are no radio-buttons specified (in LIST-ITEMS) then make some */ 
IF _F._LIST-ITEMS eq ? THEN DO:
  /* Compute item-cnt based on size */
  IF _F._HORIZONTAL 
  THEN item-cnt = MAX(1, _L._WIDTH / 12).   /* about 12 chrs/item */
  ELSE item-cnt = MAX(1,
                 &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF"
                 &THEN TRUNCATE(_L._HEIGHT / 1.12 , 0)).
                 &ELSE _L._HEIGHT). &ENDIF
  
  /* Make a list of radio-buttons, of the form:
       "Item 1", value, "Item 2", value
     where value is.  Generally, we use "Item" as the default label on items, but
     in certain cases we look for special names (such as "Page", "Line", "Option") */ 
  IF NOT CAN-DO ("Character,Date,Logical":U, _F._DATA-TYPE) THEN DO:
    IF INDEX (_U._NAME, "Page":U) > 0 THEN dflt-item = "Page".
    ELSE IF INDEX (_U._NAME, "Line":U) > 0  THEN dflt-item = "Line".
    ELSE IF INDEX (_U._NAME, "Option":U) > 0  THEN dflt-item = "Option".
    ELSE dflt-item = "Item".
    /* Add a leading quote and a trailing space. */
    dflt-item = "~"" + dflt-item + " ".
  END.
  /* Now make the individual items. */
  DO i = 1 TO item-cnt:
    if i > 1 THEN scrn-value = scrn-value + "," + {&EOL}.
    /* The "value" of each button depends on TYPE */
    CASE _F._DATA-TYPE:
      WHEN "Character":U THEN  /* eg. "String 1" */
        scrn-value = scrn-value + 
                      "~"String " + STRING(i) + "~", "+ "~"" + STRING(i) + "~"".
      WHEN "Date":U THEN /* Make it unknown for DATES */
        scrn-value = scrn-value +
                     "~"Date " + STRING(i) + "~", " + "?":U.
      WHEN "Decimal":U THEN /* eg. "Item 1.0" */
        scrn-value = scrn-value + 
                     dflt-item + LEFT-TRIM(STRING(i,">>>9.9":U)) + "~", " +
                     LEFT-TRIM(REPLACE(STRING(i, ">>>9.9":U),",":U,".":U)).
      WHEN "Integer":U THEN   /* eg "Item 1" */
         scrn-value = scrn-value +
                      dflt-item + STRING(i) + "~", " + STRING(i).
      WHEN "Int64":U THEN   /* eg "Item 1" */
         scrn-value = scrn-value +
                      dflt-item + STRING(i) + "~", " + STRING(i).
      WHEN "Logical":U THEN  /* Do TRUE, FALSE, and UNKNOWN */
        scrn-value = scrn-value + (IF      i eq 1 THEN "~"True~", TRUE"
                                   ELSE IF i eq 2 THEN "~"False~", FALSE"
                                   ELSE                "~"Unknown~", ?").
      OTHERWISE /* Make it unknown for everything else */
        scrn-value = scrn-value + 
                     dflt-item + STRING(i) + "~", " + "?":U.
    END CASE.
  END.
  /* Populate the Widget */
  _F._LIST-ITEMS = scrn-value.
END.

IF _widgetid_assign THEN
  _U._WIDGET-ID = DYNAMIC-FUNCTION("nextWidgetID":U IN _h_func_lib,
                                   INPUT RECID(PARENT_U),
                                   INPUT RECID(_U)).

/* Make a final check on the name */
IF CAN-FIND(FIRST x_U WHERE x_U._NAME = _U._NAME AND x_U._STATUS = "NORMAL":U)
  THEN RUN adeshar/_bstname.p (_U._NAME, ?, ?, ?, _h_win, OUTPUT _U._NAME).
  
/* Create the widget based on the Universal widget record. */
RUN adeuib/_undradi.p (RECID(_U)).

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}

