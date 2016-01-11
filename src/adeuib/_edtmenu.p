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

File: _edtmenu.p

Description:
    The UIB menu editor.  It lets you edit the values of an existing menu.

Input Parameters:
   parent_recid : The parent of the menu.
   menu_type    : "POPUP-MENU" or "MENUBAR"
   focus_recid  : The recid of the _U for the menu-element to focus on
                  (in case the user wants to start editting an individual
                   menu element).
Input-Output Parameters:
   menu_recid   : The RECID of the menu to edit (if blank then don't worry
   		  about it.)
Output Parameters:
   pressed_ok   : TRUE if user clicked OK to get out of here.
   delete_menu  : TRUE if user clicks OK and the menu is in its initialized state
                  (default widget name, no title and no elements).

Author: Wm.T.Wood

Date Created: September 30, 1992 

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER 		parent_recid 	AS RECID	NO-UNDO.
DEFINE INPUT PARAMETER 		menu_type 	AS CHAR 	NO-UNDO.
DEFINE INPUT PARAMETER 		focus_recid	AS RECID	NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER 	menu_recid	AS RECID	NO-UNDO.
DEFINE OUTPUT PARAMETER 	pressed_OK	AS LOGICAL     	NO-UNDO.
DEFINE OUTPUT PARAMETER 	delete_menu	AS LOGICAL     	NO-UNDO.

/* End-of-line character. */
&GLOBAL-DEFINE WIN95-BTN TRUE
&Scoped-define NL CHR(10)

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{ adecomm/adestds.i }  /* ADE Standards Include.           */

{ adeuib/uibhlp.i }    /* Help pre-processor directives    */
{ adeuib/uniwidg.i }
{ adeuib/triggers.i }
{ adeuib/std_dlg.i }   /* Standard ADE dialog include file */

/* --------------------------------------------------------------------------*/

/* Store the menu-items for this variable in a temp table                   */
/* Note that this needs to be NO-UNDO in 7.1A to work around temp-table bug */
/* (but there is no need for this NOT to be NO-UNDO ) .                     */
DEFINE TEMP-TABLE mi	NO-UNDO
        FIELD order	AS INTEGER
        FIELD level     AS INTEGER	INITIAL 1
        FIELD u-recid	AS RECID        INITIAL ?    /* Recid of related _U */
 	FIELD name 	AS CHAR 	LABEL "    &Object":R11 FORMAT "X(32)"
	FIELD lbl	AS CHAR 	LABEL "     &Label":R11 FORMAT "X(80)"
	FIELD lbl-attr	AS CHAR 	LABEL ""                FORMAT "X(6)"
	FIELD accel	AS CHAR 	LABEL "Accelerator":R11 FORMAT "X(40)"
	FIELD type	AS CHAR	 
	FIELD disabled	AS LOGICAL	INITIAL FALSE 
		        LABEL "Dis&abled" VIEW-AS TOGGLE-BOX
        FIELD is-extra  AS LOGICAL	INITIAL no /* True for only one record */
  INDEX order order
  INDEX name name.


DEFINE BUFFER xmi FOR mi.

DEFINE BUFFER xU  FOR _U.
 
/* Create a selection list to list variables in 			*/
DEFINE VAR error_on_leave       AS LOGICAL NO-UNDO.
DEFINE VAR tree                 AS CHAR    NO-UNDO
         VIEW-AS SELECTION-LIST SINGLE SIZE 75 BY 10 SCROLLBAR-VERTICAL.
DEFINE VAR toggle-box           AS LOGICAL NO-UNDO
         VIEW-AS TOGGLE-BOX  LABEL "Toggle-bo&x".
DEFINE VAR cur_mi               AS RECID   NO-UNDO.
DEFINE VAR deleting-1x1         AS LOGICAL NO-UNDO.
DEFINE VAR h     		AS WIDGET  NO-UNDO.
DEFINE VAR h_tree 		AS WIDGET  NO-UNDO.
DEFINE VAR h_cur_win		AS WIDGET  NO-UNDO.
DEFINE VAR selection 		AS INTEGER NO-UNDO.
DEFINE VAR valid-menus		AS LOGICAL NO-UNDO.
DEFINE VAR caption  		AS CHAR    NO-UNDO.
DEFINE VAR dflt-menu-name 	AS CHAR    NO-UNDO.  
DEFINE VAR menu-name 		AS CHAR    NO-UNDO.  
DEFINE VAR menu-title 		AS CHAR    NO-UNDO.
DEFINE VAR txt			AS CHAR    NO-UNDO
         FORMAT "X(15)":U INITIAL " Menu Elements":L15 VIEW-AS TEXT.
DEFINE VAR too_big              AS DECIMAL  NO-UNDO.
DEFINE VAR ldummy               AS LOGICAL  NO-UNDO.
DEFINE VAR win-type		AS LOGICAL NO-UNDO FORMAT "GUI/TTY".

/* Define the buttons for the window.					*/
DEF BUTTON b_help         LABEL "&Help"               {&STDPH_OKBTN} .
DEF BUTTON b_ok           LABEL "OK"     AUTO-GO      {&STDPH_OKBTN} .
DEF BUTTON b_cancel       LABEL "Cancel" AUTO-ENDKEY  {&STDPH_OKBTN} .
DEF BUTTON b_auto_insert  LABEL "&New Menu Element"         
                          SIZE 22 BY {&H_OKBTN} 
                          MARGIN-EXTRA DEFAULT.

DEFINE BUTTON b_delete    LABEL "D&elete Menu" SIZE 15 BY 1.125 {&STDPH_BTN} .

DEFINE BUTTON b_accel     LABEL "&Key...":C11   SIZE 15 BY 1.125  {&STDPH_BTN} .
DEFINE BUTTON b_clear     LABEL "&Clear":C11    SIZE 15 BY 1.125  {&STDPH_BTN} .

DEFINE BUTTON b_mi_insert  LABEL "&Insert":C7 SIZE 10 BY 1.125  {&STDPH_BTN} .
DEFINE BUTTON b_mi_rule    LABEL "&Rule":C7   SIZE 10 BY 1.125  {&STDPH_BTN} .
DEFINE BUTTON b_mi_skip    LABEL "&Skip":C7   SIZE 10 BY 1.125  {&STDPH_BTN} .
DEFINE BUTTON b_mi_delete  LABEL "&Delete":C7 SIZE 10 BY 1.125  {&STDPH_BTN} .
DEFINE BUTTON b_mi_up      LABEL " &Up ":C5   SIZE 8 BY 1.125  {&STDPH_BTN} .
DEFINE BUTTON b_mi_down    LABEL "D&own":C5   SIZE 8 BY 1.125  {&STDPH_BTN} .
DEFINE BUTTON b_mi_left    LABEL " &<< ":C5   SIZE 6 BY 1.125  {&STDPH_BTN} .
DEFINE BUTTON b_mi_right   LABEL " &>> ":C5   SIZE 6 BY 1.125  {&STDPH_BTN} .

&IF {&OKBOX} &THEN
DEF RECTANGLE bar2  {&STDPH_OKBOX}.
&ENDIF

DEFINE FRAME menu_edit
  	 SKIP ({&VM_WIDG}) SPACE({&HFM_WID})
  	 menu-name 	{&STDPH_FILL} COLON 13 FORMAT "X(32)" LABEL "&Menu" 
	                              VIEW-AS FILL-IN SIZE 46 BY 1 SPACE(1)
  	 b_delete      
  	 SKIP ({&VM_WID})
  	 menu-title	{&STDPH_FILL}  COLON 13 FORMAT "X(32)" LABEL "&Title"  
	                               VIEW-AS FILL-IN SIZE 46 BY 1
  	 SKIP ({&VM_WID}) SPACE({&HFM_WID})
  	 txt  {&STDPH_SDIV}            VIEW-AS TEXT NO-LABEL SKIP({&VM_WID})
  	 mi.lbl   	 {&STDPH_FILL} COLON 13
	                               VIEW-AS FILL-IN SIZE 46 BY 1
         SPACE(0) ":":U VIEW-AS TEXT SIZE 1 BY 1 SPACE(0)
	 mi.lbl-attr NO-LABEL {&STDPH_FILL} VIEW-AS FILL-IN SIZE 15 BY 1 
         SKIP ({&VM_WID})
  	 mi.name   	 {&STDPH_FILL} COLON 13 VIEW-AS FILL-IN SIZE 46 BY 1
                                                               SKIP ({&VM_WID})
  	 mi.accel	 {&STDPH_FILL} COLON 13 FORMAT "X(25)" 
	                               VIEW-AS FILL-IN SIZE 30 BY 1
  	 b_accel SPACE(1) b_clear
  	 SKIP ({&VM_WID})
  	 mi.disabled    COLON 13 toggle-box
  	 b_mi_insert    AT 2 space(0) b_mi_delete space(3.25)
  	 b_mi_rule 	space(0) b_mi_skip space(3.5)
  	 b_mi_up space(0) b_mi_down space(0) b_mi_left space(0)
         b_mi_right SKIP({&VM_WID})
  	 tree NO-LABEL  AT 2      FONT 0 
         {adecomm/okform.i
            &BOX    = bar2
            &OK     = b_OK
            &CANCEL = b_cancel
            &OTHER  = "SPACE({&HM_BTNG}) b_auto_insert"
            &HELP   = b_Help }
   WITH TITLE "Menu Editor" 
        VIEW-AS DIALOG-BOX SIDE-LABELS
        DEFAULT-BUTTON b_ok.

/* WTW - 7.1C workaround: Use Hidden */
FRAME menu_edit:HIDDEN = yes.

/* Shrink the size of everything if the window is too big */
too_big = FRAME menu_edit:HEIGHT-CHARS - SESSION:HEIGHT-CHARS
          &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN + 2 &ENDIF . 
if too_big > 0 THEN DO:
  ASSIGN b_ok:ROW               = b_ok:ROW - too_big
         b_cancel:ROW           = b_ok:ROW
         b_auto_insert:ROW      = b_ok:ROW
         b_help:ROW             = b_ok:ROW
         &IF {&OKBOX} &THEN
         bar2:ROW IN FRAME menu_edit = bar2:ROW IN FRAME menu_edit - too_big
         &ELSE
         FRAME menu_edit:RULE-ROW = FRAME menu_edit:RULE-ROW - too_big
         &ENDIF
         tree:HEIGHT            = tree:HEIGHT - too_big
         FRAME menu_edit:HEIGHT = FRAME menu_edit:HEIGHT - too_big.
END.        

/* Standard run-time layout - eff_frame_width is defined. */
{ adecomm/okrun.i 
       &FRAME  = "FRAME menu_edit"
       &BOX    = bar2
       &OK     = b_ok
       &HELP   = b_help }
              
ASSIGN txt:WIDTH = eff_frame_width - txt:COL - {&HFM_WID} + 1.


/* -------------------------------------------------------------*/
/*				Procedures			*/
/* -------------------------------------------------------------*/

/* make an extra mi so the user can insert a line at the end of the menu */
procedure make-extra-mi.
  DEFINE VAR next_order AS INTEGER NO-UNDO.
  DEFINE VAR l_ok       AS LOGICAL NO-UNDO.
  
  FIND LAST xmi USE-INDEX order NO-ERROR.
  IF AVAILABLE mi THEN next_order = xmi.order + 1.
  ELSE next_order = 1.
 
  CREATE xmi.
  ASSIGN xmi.is-extra = TRUE
  	 xmi.order    = next_order
  	 xmi.type     = "NORMAL".
  l_ok = h_tree:ADD-LAST(" ").
  RUN set-selection.
end.

/* The current mi was changed and we need to create an extra one, if the
   current mi was the extra one. */
procedure check-extra-mi.
  if mi.is-extra THEN DO:
    mi.is-extra = FALSE.
    RUN make-extra-mi.
  END.
end.

/* Menu-Report: Takes a _U recid and builds up a menu tree of mi's. */
procedure menu-report.
  def input parameter u-rec as recid		no-undo.
  def input parameter ordr as integer		no-undo.
  def input parameter levl as integer		no-undo.
  
  define buffer ipU for _U.
  define buffer ipM for _M.
  
  def var l-ok 		as logical	 		no-undo. 
  def var cur-item 	as char			 	no-undo.
   
  /* Figure out a text string to describe the menu-item */
  create mi.
  FIND ipU WHERE RECID(ipU) = u-rec.
  FIND ipM WHERE RECID(ipM) = ipU._x-recid.
  /* DEBUG message ipU._NAME ipU._TYPE ipU._SUBTYPE. */
  CASE ipU._TYPE:
    WHEN "SUB-MENU" THEN mi.type = "NORMAL".
    WHEN "MENU-ITEM" THEN mi.type = ipU._SUBTYPE.
  END CASE.
  ASSIGN mi.order	= ordr
  	 mi.level	= levl
  	 mi.u-recid     = u-rec
  	 mi.name	= ipU._NAME
  	 mi.lbl		= ipU._LABEL
  	 mi.lbl-attr	= ipU._LABEL-ATTR
  	 mi.accel	= ipM._ACCELERATOR
  	 mi.disabled    = NOT ipU._SENSITIVE
  	 cur_mi         = RECID(mi).

  /* Add the item to h_tree */
  CASE mi.type:
    WHEN "RULE" THEN RUN unique-name ("RULE", "", mi.level, OUTPUT cur-item).
    WHEN "SKIP" THEN RUN unique-name ("SKIP", "", mi.level, OUTPUT cur-item).
    OTHERWISE  RUN unique-name (mi.lbl, mi.accel, mi.level, OUTPUT cur-item).
  END CASE.
  l-OK = h_tree:ADD-LAST (cur-item).
  
   /* Now check for a child recursively, and then sibling, recursively */
  if ipM._child-recid <> ?   
  THEN run menu-report (ipM._child-recid, ordr + 1, levl + 1).
  if ipM._sibling-recid <> ? THEN DO:
    /* If many children were created then order will be different. */
    FIND LAST mi USE-INDEX order.
    run menu-report (ipM._sibling-recid, mi.order + 1, levl).
  END.
end procedure.

/* Check menu elements - for consistency */
procedure check-menu-elements.
  define var lvl       as integer no-undo.
  define var error-msg as char    no-undo.
  define var last-type as char    no-undo.
  ASSIGN lvl         = 0 
  	 valid-menus = FALSE
  	 error-msg   = ?
  	 last-type   = "".
  /* Do we have a valid menu label */
  IF TRIM (menu-name) = "" THEN DO:
    MESSAGE "The menu-item name cannot be empty." 
    		VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
  /* Now check the menu-items */
  FOR EACH mi USE-INDEX order:
    /* DEBUG: message mi.name mi.lbl mi.type mi.level mi.is-extra. */
    /* Make sure the non-deleted, non-empty menu-items are valid .*/
    IF (mi.is-extra EQ no) AND (mi.order <> ?) AND 
       NOT (mi.name EQ "" AND mi.lbl EQ "") THEN DO:
      IF NOT CAN-DO ("RULE,SKIP",mi.type) THEN DO:
        /* Any menu-item with a label must have a name.  */
        IF (TRIM(mi.name) = "") THEN
          error-msg = "Menu element name cannot be empty." .
        ELSE IF (mi.level = 1) AND (menu_type = "MENUBAR") THEN DO: 
          IF mi.type = "TOGGLE-BOX" THEN
            error-msg = 
                "A TOGGLE-BOX is not allowed on the top level of a MENU-BAR.".
          IF mi.accel <> "" THEN
            error-msg = 
               "An ACCELERATOR is not allowed on the top level of a MENU-BAR.".
        END.
      END.
      ELSE DO:
        IF (mi.level = 1) AND (menu_type = "MENUBAR") THEN 
          error-msg = mi.type + 
                      " is not allowed on the top level of a MENU-BAR.".
      END.
      IF mi.level > lvl + 1 THEN 
        error-msg = "Menu heirarchy cannot skip a level.".
      ELSE IF mi.level eq lvl + 1 AND CAN-DO ("RULE,SKIP,TOGGLE-BOX", last-type) THEN 
        error-msg = "A sub-menu cannot start after a " + last-type + ".".
      /* Did we get an error? If so report it. */
      IF error-msg <> ? THEN DO:
        MESSAGE error-msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RUN set-selection-number (mi.order).
        RETURN.
      END.
      /* Set up for next one */
      ASSIGN lvl = mi.level
             last-type = mi.type. 
    END.
  END.
  valid-menus = TRUE.
END.

/* Menu-rebuild: Takes the mi records and builds _U records. */
procedure rebuild-menus.

  /* Step 0: Go through all "empty" mi records and make them deleted
     (i.e. order = ?) */
  FOR EACH mi WHERE (mi.lbl EQ "" AND mi.name EQ ""):
    FOR EACH xmi WHERE xmi.order > mi.order USE-INDEX order:
      xmi.order = xmi.order - 1.
    END.
    mi.order = ?.
  END.

  /* Step 1: is to go though all the deleted mi records and delete
     the corresponding _U record. (and _M record). Also delete any triggers. */ 
  FOR EACH mi WHERE mi.order = ?:
    IF mi.u-recid <> ? THEN DO:
      FOR EACH _TRG WHERE _TRG._wRECID = mi.u-recid:
        DELETE _TRG.
      END.
      FIND _U WHERE RECID(_U) = mi.u-recid.
      FIND _M WHERE RECID(_M) = _U._x-recid.
      DELETE _U.
      DELETE _M.
    END.
    /* Get rid of the menu-item record */
    DELETE mi.
  END. 
  
  /* Step 2: Make a root-level menu - This should be in menu_recid,
     but if this is was empty then create a menu. */
  IF menu_recid = ? THEN DO:
    CREATE _U.
    CREATE _M.
    ASSIGN menu_recid = RECID(_U)
    	   _U._x-recid = RECID(_M).
  END.
  ELSE DO:
    FIND _U WHERE RECID(_U) = menu_recid.
    FIND _M WHERE RECID(_M) = _U._x-recid.
  END.
  ASSIGN _U._NAME = menu-name
  	 _U._LABEL = menu-title
  	 _U._TYPE = "MENU"
  	 _U._SUBTYPE = menu_type   /* MENUBAR or POPUP-MENU */
  	 _U._WIN-TYPE = win-type   /* GUI or TTY */
  	 _U._WINDOW-HANDLE = h_cur_win
  	 _U._SENSITIVE = TRUE
  	 _U._PARENT-RECID = parent_recid  /* The top-most parent (the MENU)  */
  	 _M._parent-recid = parent_recid  /* True parent (usually a submenu) */
  	 _M._sibling-recid = ?.  /* Top level menus have no siblings */

  /* Step 3: Build the menu tree */
  FIND FIRST mi USE-INDEX order NO-ERROR.
  IF NOT AVAILABLE mi OR mi.is-extra
  THEN _M._child-recid = ?.
  ELSE DO:
    RUN build-menu (RECID(mi) , parent_recid).
    _M._child-recid = mi.u-recid.
  END.
   
END PROCEDURE.

/* build-menu : recursively build a menu using
	m-rec - the recid of the mi record for which we are going to
		build a _U and _M record (if none exist).
	parent-rec  - the  recid of _U that is to be the parent of any
		_U created in this routine.		
*/
PROCEDURE build-menu.
  def input parameter m-rec as recid		no-undo.
  def input parameter parent-rec as recid	no-undo.
  
  define buffer ipU for _U.
  define buffer ipM for _M.
  define buffer this_mi for mi.
  define buffer next_mi for mi.
  
  /* Get the U and M records corresponding to u-rec and populate them */
  FIND this_mi WHERE RECID(this_mi) = m-rec.
  IF this_mi.u-recid = ? THEN DO:
    CREATE ipU.
    CREATE ipM.
    ASSIGN ipU._x-recid    = RECID(ipM)
           this_mi.u-recid = RECID(ipU).
  END.
  ELSE DO:
    FIND ipU WHERE RECID(ipU) = this_mi.u-recid.
    FIND ipM WHERE RECID(ipM) = ipU._x-recid.
  END.
  ASSIGN ipU._NAME          = this_mi.name
  	 ipU._LABEL         = this_mi.lbl
  	 ipU._LABEL-ATTR    = this_mi.lbl-attr
   	 ipU._WINDOW-HANDLE = h_cur_win
   	 ipU._WIN-TYPE      = win-type
   	 ipU._SENSITIVE     = NOT this_mi.disabled 
  	 ipU._PARENT-RECID  = parent-rec  
  	 ipM._parent-recid  = parent-rec  
  	 ipM._ACCELERATOR   = this_mi.accel.
  /* DEBUG *  message this_mi.order " - " this_mi.level  " - " 
  	  this_mi.name " - " this_mi.lbl " - " this_mi.type. */
  /* Now check for a child - next in order and with next level). */
  FIND next_mi
   WHERE (next_mi.order = this_mi.order + 1) AND 
   	 (next_mi.level = this_mi.level + 1) 
   NO-ERROR.
  IF NOT AVAILABLE next_mi OR next_mi.is-extra 
  /* If no children then it is a menu-item with 
     SUBTYPE = RULE,SKIP,NORMAL,TOGGLE-BOX */
  THEN ASSIGN ipM._child-recid = ?
  	      ipU._TYPE        = "MENU-ITEM"
  	      ipU._SUBTYPE     = this_mi.type.
  ELSE DO:
    /* Build the child _U and _M -- this sets next_mi.u-recid to RECID(_U). */
    run build-menu (RECID(next_mi), parent-rec).
    ASSIGN ipM._child    = next_mi.u-recid
    	   ipU._TYPE    = "SUB-MENU"
    	   ipU._SUBTYPE = ?.
  END.
  /* Now check for a sibling -- ie. Same level as the current menu item but
     at a lower order (with no lower level menu-items in between ). */
  FIND FIRST next_mi
      WHERE (next_mi.order > this_mi.order AND next_mi.level <= this_mi.level) 
      USE-INDEX order  NO-ERROR.
  IF (NOT AVAILABLE next_mi) OR (next_mi.level <> this_mi.level) OR
      next_mi.is-extra
  THEN ipM._sibling = ?.
  ELSE DO:
    /* Build the sibling _U and _M -- this sets next_mi.u-recid to RECID(_U). */
    run build-menu (RECID(next_mi), parent-rec).
    ipM._sibling = next_mi.u-recid.
  END.
end procedure.

/* -------------------------------------------------------------*/
/*	Procedures for Modifying the TREE of Menu Elements	*/
/* -------------------------------------------------------------*/

/* All these routines act on the selection list of menu elements (h_tree).
   and possibly change the current value */

/* set-selection: figure out which mi is selected and show it */
procedure set-selection.
  def var l_ok        as logical no-undo.
  def var num-rows    as integer no-undo.
  def var top-item    as char    no-undo.
  
  selection = h_tree:LOOKUP(h_tree:SCREEN-VALUE).
  IF (selection = 0) OR (selection = ?) THEN selection = h_tree:NUM-ITEMS.
  
  /* Scroll to either (1) the top of the list if the list is short; (2) so 
     selection is 2 from the top; OR (3) so that the bottom num-rows of the
     list are in view */
  IF ( selection < h_tree:INNER-LINES ) 
  THEN top-item = h_tree:ENTRY(1).
  ELSE top-item = h_tree:ENTRY(MIN (selection - 2, 
                                    h_tree:NUM-ITEMS - h_tree:INNER-LINES  + 1)).
  l_ok = h_tree:SCROLL-TO-ITEM(top-item).                                 
  FIND mi WHERE mi.order = selection.
  toggle-box = (mi.TYPE eq "TOGGLE-BOX":U).
  DISPLAY  mi.lbl mi.lbl-attr mi.name  mi.accel  mi.disabled  toggle-box
     WITH FRAME menu_edit. RUN reset_UI. /* Enable/Disable various items */
end procedure. /* set-selection */

/* set-selection-number: figure out which mi is selected and show it */
procedure set-selection-number.
  def input parameter n as integer no-undo.
  h_tree:SCREEN-VALUE = h_tree:ENTRY(n).
  RUN set-selection.
end procedure.  

/* ---------------------------------------------------------------------
ok_menu_name: Takes a string and sees if it is a valid menu name.  A name is
   valid iff:
    (1) We are not using it already [for the menu or in mi records.
    (2) There is not a _U with that name [unless the _U corresponds to
        the menu-name or to a mi record.  we could have changed its name
        internally.]
    (3) It is a valid progress identifier.
   NOTE: we should already have checked case (0), that the new_name is the
   same as the old name, which is ok. This stops us from calling the reporting
   an error if we try to change a menu-item to itself.]
  --------------------------------------------------------------------- */
procedure ok_menu_name:
  define input  parameter p_test     as char    no-undo.
  define input  parameter p_report   as logical no-undo.
  define output parameter p_ok       as logical no-undo. 
  
  define buffer ip_mi for mi. 
  
  /* Case 1a: Is there a menu-item with this name (that is not deleted) */
  /* Case 1b: Does the whole menu have this name  */
  FIND FIRST ip_mi WHERE ip_mi.name eq p_test AND ip_mi.order ne ? AND
                         RECID(ip_mi) NE cur_mi NO-ERROR.
  p_ok = (NOT AVAILABLE ip_mi) AND (p_test NE menu-name).
  
  /* Case 2: Is there a _U with this name that is not the current menu or
             an item in ip_mi. */
  IF p_ok THEN DO:
    FIND FIRST _U WHERE _U._NAME eq p_test 
                    AND _U._WINDOW-HANDLE eq h_cur_win 
                    AND _U._STATUS ne "DELETED" 
                    AND RECID(_U) ne menu_recid
                    AND NOT CAN-FIND(ip_mi WHERE ip_mi.u-recid eq RECID(_U))
                  USE-INDEX _NAME NO-ERROR.
    IF AVAILABLE _U THEN p_ok = no.
  END.
  /* In some cases we don't want to report an error and we don't want
     to use the _valname.p which will also report an error */
  IF p_report THEN DO:
    IF p_ok eq no
    THEN MESSAGE "Another object already uses this name." {&SKP}
                 "Please enter another name."
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ELSE 
      /* There was no other widget.  We still need to validate that the name
         isa valid PROGRESS identifier. */
      RUN adecomm/_valname.p (p_test, FALSE, OUTPUT p_ok).
  END.
end.

/* move-selection-to: move the selection to line n. */
procedure move-selection-to.
  def input parameter n as integer no-undo.

  def var cur-item 	as char		no-undo.
  def var n-item 	as char		no-undo.
  def var l-ok 		as logical 	no-undo. 
  
  cur-item = h_tree:ENTRY (selection).
  l-ok = h_tree:DELETE(cur-item).
  if n > h_tree:NUM-ITEMS
  THEN l-ok = h_tree:ADD-LAST(cur-item).
  ELSE ASSIGN n-item = h_tree:ENTRY (n)
              l-ok = h_tree:INSERT(cur-item, n-item).

  if l-ok THEN DO:
    h_tree:SCREEN-VALUE = cur-item.
    selection = n.
  end.
end procedure. 

/* update-selection: get the new value for the current selection and
   replace it with the new value.*/
procedure update-selection.
  def var cur-item 	as char		no-undo.
  def var new-item 	as char 	no-undo.
  def var l-ok 		as logical 	no-undo. 
  
  cur-item = h_tree:ENTRY (selection).
  CASE mi.TYPE:
    WHEN "RULE" THEN RUN unique-name ("RULE", "", mi.level, OUTPUT new-item).
    WHEN "SKIP" THEN RUN unique-name ("SKIP", "", mi.level, OUTPUT new-item).
    OTHERWISE  RUN unique-name (mi.lbl, mi.accel, mi.level, OUTPUT new-item).
  END CASE.
  l-OK = h_tree:REPLACE (new-item, cur-item).
  h_tree:SCREEN-VALUE = new-item.
end procedure. 

/* reset_UI: Depending on the menu element, enable and disable various actions */
procedure reset_UI:
  def var nrml-item   as logical no-undo.
  def var is-sub-menu as logical no-undo.

  FIND mi WHERE mi.order = selection.
  FIND xmi WHERE xmi.order = selection + 1 NO-ERROR.
  /* Either enable or disable all the fields if the current line is a RULE or
      RULE or a SKIP, */
  ASSIGN nrml-item   = NOT CAN-DO ("RULE,SKIP",mi.type). 
         is-sub-menu = (AVAILABLE xmi AND xmi.level eq mi.level + 1).
  DO WITH FRAME menu_edit:
    /* Certain actions are allowed on top-level menubars.             */
    /* Note that some of these actions could have been set while the  */
    /* Item was on a different level so don't grey them out.          */
    IF menu_type eq "MENUBAR" AND mi.level eq 1
    THEN ASSIGN b_accel:SENSITIVE    = (mi.accel ne "")
                toggle-box:SENSITIVE = toggle-box /* can turn it off, not on */
                b_mi_rule:SENSITIVE  = no
                b_mi_skip:SENSITIVE  = no.
    ELSE ASSIGN b_accel:SENSITIVE    = nrml-item AND NOT is-sub-menu
                toggle-box:SENSITIVE = (nrml-item AND NOT is-sub-menu) OR
                                       toggle-box /* Let user turn it off always */
   	    b_mi_rule:SENSITIVE  = yes
                b_mi_skip:SENSITIVE  = yes.
    /* Set values that are always true */
    ASSIGN mi.lbl:SENSITIVE = nrml-item
           mi.lbl-attr:SENSITIVE = nrml-item
           mi.name:SENSITIVE = nrml-item
           mi.disabled:SENSITIVE = nrml-item
           /* Only allow clearing of accelerator if there is a key */
           b_clear:SENSITIVE = (mi.accel ne "").
  end.
end procedure. 
  
/* delete-selection: remove the current selection and set selection to its
   new value. */
procedure delete-selection.
  def var l-ok as logical no-undo. 
  def var cur-item as char no-undo.
  
  cur-item = h_tree:ENTRY (selection).
  l-OK = h_tree:DELETE (cur-item).
  RUN set-selection-number (selection).
end procedure.   

/* Insert a new item into the temp table and show it in the select list */
PROCEDURE insert-menu-item.
  define input parameter new-type       as char         no-undo.
  define input parameter at-order       as integer      no-undo.
  define input parameter at-level 	as integer   	no-undo.

  define var item 	as char 	no-undo.
  def var l-ok 		as logical	 		no-undo. 
  def var cur-item 	as char			 	no-undo.

  CREATE mi.
  ASSIGN mi.level = at-level
         mi.type  = new-type  /* menu-item, rule or skip */
         cur_mi   = RECID(mi).
  IF CAN-DO ("RULE,SKIP",mi.type)
  THEN ASSIGN mi.lbl = mi.type
  	      item   = mi.type.
  ELSE ASSIGN mi.lbl = ""
  	      item   = "".
  DO PRESELECT EACH xmi WHERE xmi.order >= at-order:
     REPEAT: 
       FIND NEXT xmi.
       xmi.order = xmi.order + 1. 
    END.
  END.
  mi.order = at-order.
       
  /* Make sure we have a unique new item name */
  RUN unique-name (item, "", at-level, OUTPUT item).
  
  /* insert the line above in the selection list. */
  ASSIGN cur-item     = h_tree:ENTRY (at-order)
         l-OK         = h_tree:INSERT (item, cur-item)
         h_tree:SCREEN-VALUE = item.
  RUN set-selection.
end procedure.   

/* unique-name: Make a unique name for the current mi record so that it
		can appear in tree uniquely.  We do this by adding spaces
		to the end until we are sure that the new-item does not exist. */
procedure unique-name.
  def input  parameter labl as char no-undo.
  def input  parameter accl as char no-undo.
  def input  parameter lvl as integer no-undo.
  def output parameter new-item as char no-undo.

  def var i 		as integer 	no-undo.

  /* Insert the current name and accelerator, if necessary */
  new-item = labl.
  DO i = 2 TO lvl:
    new-item = "- " + new-item.
  END.
  /* Fill in from raw character position 30 onward with the accelerator.
     (NOTE: if the item label uses DOUBLE-BYTE characters, these do take
     two columns. So RAW is indeed the correct choice here.) */
  IF accl <> "" THEN SUBSTRING (new-item,30,0,"RAW":U) = accl. 
  /* Make sure we have a unique new item name */
  i = 1. 
  DO WHILE i > 0:
    ASSIGN new-item = new-item + " "
           i        = h_tree:LOOKUP (new-item).
  END.
end procedure.

/* -------------------------------------------------------------*/
/*			    Triggers				*/
/* -------------------------------------------------------------*/

/* Help triggers */
ON CHOOSE OF b_help OR HELP OF FRAME menu_edit
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Menu_Editor_Dlg_Box}, ? ).

/* Change Menu Owner */
ON CHOOSE OF b_delete DO:
  DEFINE VAR ans AS logical		NO-UNDO.
  
  MESSAGE "Do you want to delete this menu?" 
  	VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE ans.
  IF ans THEN DO:
    /* Delete all but the last mi (unless we need to save it so we can delete 
       the _U later.). */
    FOR EACH xmi:
      IF xmi.is-extra THEN xmi.order =  1.
      ELSE IF xmi.u-recid <> ? THEN xmi.order = ?.
      ELSE DELETE xmi.
    END.
    /* Empty the tree list */
    ASSIGN h_tree:SCREEN-VALUE = ?
    	   h_tree:LIST-ITEMS = " "    	   
    	   menu-name  = dflt-menu-name
    	   menu-title = ""
    	   menu-name:SCREEN-VALUE IN FRAME menu_edit  = menu-name
    	   menu-title:SCREEN-VALUE IN FRAME menu_edit = menu-title
    	   /* If you delete everything, then you are not deleting items 1 by 1. */
          deleting-1x1 = no.
    RUN set-selection-number (1).
  END.
END.

/* Clear a menu accelerator key */
ON CHOOSE OF b_clear IN FRAME menu_edit DO:
  ASSIGN mi.accel = ""
         mi.accel:SCREEN-VALUE = ""
         SELF:SENSITIVE = no.
  RUN update-selection.
END.

/* Make sure string attributes are valid */
ON LEAVE OF mi.lbl-attr IN FRAME menu_edit DO:
  IF AVAILABLE mi THEN DO:
    IF mi.lbl-attr NE SELF:SCREEN-VALUE THEN DO:
      SELF:SCREEN-VALUE = LEFT-TRIM(SELF:SCREEN-VALUE).
      RUN adeuib/_strattr.p (SELF:SCREEN-VALUE).
      IF RETURN-VALUE NE "":U THEN DO:
        error_on_leave = yes.
        RETURN NO-APPLY.
      END.
      ASSIGN SELF:SCREEN-VALUE = CAPS (SELF:SCREEN-VALUE)
             mi.lbl-attr       = SELF:SCREEN-VALUE.
    END.
  END.    
END.
  
/* Assign new changes to information */
ON VALUE-CHANGED OF mi.disabled  
   ASSIGN mi.disabled  = (SELF:SCREEN-VALUE = STRING(true)).
ON VALUE-CHANGED OF toggle-box DO:
   ASSIGN toggle-box = (SELF:SCREEN-VALUE = STRING(true))
          mi.type  = IF toggle-box THEN "TOGGLE-BOX" ELSE "NORMAL".
END.

/* Choose a new accelerator key */
ON CHOOSE OF b_accel IN FRAME menu_edit DO:
  DEFINE VAR menu_item AS CHAR.

  menu_item = mi.lbl:SCREEN-VALUE in frame menu_edit.
  IF mi.lbl = "" THEN menu_item = "[Unlabelled]".
  RUN adecomm/_dlgrecm.p (INPUT menu_item, INPUT-OUTPUT mi.accel).
  DISPLAY mi.accel with frame menu_edit.
  IF mi.accel ne "" THEN b_clear:SENSITIVE = yes.
  RUN update-selection.
  RUN check-extra-mi.
END.

/* Choose a new menu element */
ON VALUE-CHANGED OF tree IN FRAME menu_edit DO:
  RUN set-selection.
  RUN edit-lbl.
END.

/* Go into auto-insert mode if we are editting the label */
ON ENTRY OF mi.lbl IN FRAME menu_edit DO:
  FRAME menu_edit:DEFAULT-BUTTON = b_auto_insert:HANDLE.
END.

/* Check the label -- if ENTER/RETURN here then create a new item */
ON CHOOSE OF b_auto_insert OR LEAVE OF mi.lbl IN FRAME menu_edit DO:
  DEF VAR n       AS CHAR    NO-UNDO.
  DEF VAR ch      AS CHAR    NO-UNDO.
  DEF VAR base    AS CHAR    NO-UNDO.
  DEF VAR okname  AS LOGICAL NO-UNDO.
  DEF VAR i       AS INTEGER NO-UNDO.
  DEF VAR new_lbl AS CHAR CASE-SENSITIVE NO-UNDO.

  new_lbl = mi.lbl:SCREEN-VALUE.
  IF new_lbl <> mi.lbl THEN DO:
    /* Error conditions: (1) empty label or (2) Name is already used [we check
       for this because selection lists can't handle two lines the same. ] */
    IF TRIM(new_lbl) = "" THEN DO:
      message "A menu-item must have a non-blank label." 
      	      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      return NO-APPLY.
    END.
    /* Label is a good name */
    mi.lbl = new_lbl.
    RUN update-selection.
    RUN check-extra-mi.
    /* Fill in the widget name, if it is blank. */
    IF mi.name = "" THEN DO:
      n = "m_".
      DO i = 1 to LENGTH(mi.lbl):
        ch = SUBSTRING(mi.lbl,i,1).
        IF ch EQ " " THEN n = n + "_".
        /* Note INDEX lists alphabet in frequency order */
        ELSE IF INDEX("ETAONRISHDLFCMUGYPWBVKXJQZ-_0123456789#$%",ch) > 0
        THEN n = n + ch.
      END.  
      /* If the name had no valid characters, change it to "m_item".
         (This could happen in international situations where lots of
          foriegn characters are used). */
      IF n = "m_" THEN n = "m_item".
             
      /* If the generated name is too long, then we'll cut it off
       * at 29 bytes to allow room for a number (if needed).
       */
      IF LENGTH(n,"CHARACTER") > 29 THEN n = SUBSTRING(n,1,29).
      
      /* See that this name doesn't already exist -- if so add a number. */
      ASSIGN base = n
             i = 1.
      RUN ok_menu_name (n, no, OUTPUT okname).
      
      DO WHILE NOT okname:
        ASSIGN i = i + 1
               n = base + STRING(i).
        RUN ok_menu_name (n, no, OUTPUT okname).
      END.
      mi.name = n.
      display mi.name with frame menu_edit.
    END.
  END.

  /* Special Case of RETURN (or ENTER under Windows)
     -- Go to next record */
  IF SELF EQ b_auto_insert:HANDLE THEN DO:
    IF (selection + 1) <= h_tree:NUM-ITEMS
    THEN RUN insert-menu-item ("NORMAL", mi.order + 1, mi.level).
    RUN edit-lbl.
    RETURN NO-APPLY.
  END.
  /* Get out of auto-insert mode */
  ELSE ASSIGN FRAME menu_edit:DEFAULT-BUTTON = b_ok:HANDLE.

END.

ON LEAVE OF menu-name IN FRAME menu_edit DO:
  DEF VAR valid_name AS LOGICAL NO-UNDO.
  DEF VAR new_name AS CHAR NO-UNDO.
  
  new_name = TRIM(SELF:SCREEN-VALUE).
  IF new_name = menu-name THEN menu-name = new_name. /* Get changes in "Case" */
  ELSE DO:
    /* Error conditions: (1) empty name or (2) Name is invalid */
    IF new_name = "" THEN DO:
      message "A menu-bar must have a unique, non-blank object name." 
      	      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      error_on_leave = yes.
      RETURN NO-APPLY.
    END. 
    RUN ok_menu_name (new_name, yes, OUTPUT valid_name).
    IF NOT valid_name THEN DO:
      error_on_leave = yes.
      RETURN NO-APPLY.
    END.
    ELSE menu-name = new_name.
  END.
END.

ON LEAVE OF menu-title IN FRAME menu_edit DO:
  DEF VAR new_title AS CHAR NO-UNDO.
  ASSIGN new_title  = IF SELF:SCREEN-VALUE = ? THEN "" ELSE TRIM(SELF:SCREEN-VALUE) 
         menu-title = new_title
         SELF:SCREEN-VALUE = menu-title.
  /* Note that title is not supported under MS-WINDOWS */
  IF menu-title NE "" AND SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" 
  THEN MESSAGE "Menu titles are not supported under Windows." {&SKP}
               "However, the title will be used if you run" {&SKP}
               "your application on other platforms."
               VIEW-AS ALERT-BOX WARNING BUTTONS OK. 
END.

ON LEAVE OF mi.name IN FRAME menu_edit DO:
  DEF VAR valid_name AS LOGICAL NO-UNDO.
  DEF VAR new_name   AS CHAR NO-UNDO.  
  DEF VAR this_mi    AS RECID NO-UNDO.
  
  ASSIGN this_mi  = RECID(mi)
         new_name = TRIM(SELF:SCREEN-VALUE).
  IF new_name eq mi.name THEN mi.name = new_name. /* Get changes in "Case" */
  ELSE DO:
    /* Error conditions: (1) empty name or (2) Name is invalid */
    IF new_name eq "" THEN DO:
      message "A menu-item must have a unique, non-blank object name." 
      	      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      error_on_leave = yes.
      RETURN NO-APPLY.
    END.
    RUN ok_menu_name (new_name, yes, OUTPUT valid_name).    
    IF NOT valid_name THEN DO:
      error_on_leave = yes.
      IF NOT AVAILABLE mi THEN FIND mi WHERE RECID(mi) eq this_mi.  
      APPLY "ENTRY" TO SELF.
      SELF:AUTO-ZAP = TRUE.
      RETURN NO-APPLY.         
    END.   
    mi.name = new_name.
    RUN check-extra-mi.
    /* Fill in the widget label if necessary */
    IF mi.lbl = "" THEN DO:
       mi.lbl = mi.name.
       RUN update-selection.
       display mi.lbl with frame menu_edit.
    END.
  END.
END.
  
/* --------------- Triggers to Change Menu Selection ---------------- */
&Scoped-define All_Fields menu-name, ~
mi.name, mi.lbl, mi.lbl-attr, b_accel, b_clear, mi.disabled, toggle-box, ~
b_mi_insert, b_mi_delete, b_mi_rule, b_mi_skip, ~
b_mi_up, b_mi_down, b_mi_left, b_mi_right 

ON CURSOR-DOWN OF {&All_Fields} DO: 
  IF not mi.is-extra THEN DO:
    RUN set-selection-number(selection + 1).
    RUN edit-lbl.
  END.
  RETURN NO-APPLY.
END.

ON CURSOR-UP OF {&All_Fields} DO: 
  IF selection > 1 THEN DO:
    RUN set-selection-number (selection - 1).
    RUN edit-lbl.
  END.
  RETURN NO-APPLY.
END.


/* --------------- Triggers to Change the Order of The Menu ---------------- */

procedure edit-lbl:
  /* After changing the order of the menu, then edit the label of the item */
  IF mi.lbl:SENSITIVE IN FRAME menu_edit
  THEN APPLY "ENTRY":U TO mi.lbl IN FRAME menu_edit.
  ELSE APPLY "ENTRY":U TO tree IN FRAME menu_edit. 
end procedure.

ON CHOOSE OF b_mi_delete DO:
  IF mi.is-extra THEN RETURN NO-APPLY. /* Always keep an extra item at bottom */
  /* Delete the mi record (unless we need to save it so we can delete the _U
     later.). */
  IF mi.u-recid <> ? THEN mi.order = ?.
  ELSE DELETE mi.
  FOR EACH xmi WHERE xmi.order > selection USE-INDEX order:
    xmi.order = xmi.order - 1.
  END.
  RUN delete-selection.  
  RUN edit-lbl.
  /* Note that the user has been deleting menu-items 1-by-1. */
  deleting-1x1 = yes.
END.

/* Insert a menu-item, a rule or a skip */
ON CHOOSE OF b_mi_insert, b_mi_rule, b_mi_skip DO:
  DEFINE VAR blank2ruleOrSkip AS LOGICAL NO-UNDO.
  /* If we are adding a ruleOrSkip to a currently blank line, then
     insert at the current line and move past it.  Otherwise add after
     and go to it. */
  blank2ruleOrSkip = mi.lbl eq "" AND mi.name eq "" AND
                     CAN-DO("RULE,SKIP", SELF:PRIVATE-DATA).
  RUN insert-menu-item 
           (SELF:PRIVATE-DATA, 
            MIN(selection + (IF blank2ruleOrSkip THEN 0 ELSE 1),
                h_tree:NUM-ITEMS), 
            mi.level).
  IF blank2ruleOrSkip THEN RUN set-selection-number (selection + 1).
  RUN edit-lbl.
END.

ON CHOOSE OF b_mi_left OR ALT-CURSOR-LEFT OF {&All_Fields} DO:
  IF mi.level < 2 THEN bell.
  ELSE DO:
    mi.level = mi.level - 1.
    RUN update-selection.
    RUN reset_UI. /* Enable/Disable User options */
  END.
  RUN edit-lbl.
END.

ON CHOOSE OF b_mi_right OR ALT-CURSOR-RIGHT OF {&All_Fields} DO:
  def var temp-level as integer no-undo.
  IF mi.level > 5 THEN bell.
  ELSE DO:
    mi.level = mi.level + 1.
    run update-selection.
    RUN reset_UI. /* Enable/Disable User options */
  END.
  RUN edit-lbl.
END.

ON CHOOSE OF b_mi_up OR ALT-CURSOR-UP OF {&All_Fields} DO:
  IF mi.is-extra THEN RETURN NO-APPLY. /* Always keep an extra item at bottom */
  IF selection < 2 THEN bell.
  ELSE DO.
    FIND xmi WHERE xmi.order = (selection - 1).
    ASSIGN xmi.order = selection
           mi.order  = selection - 1.
    RUN move-selection-to (mi.order).
    RUN reset_UI. /* Enable/Disable User options */
  END.
  RUN edit-lbl.
END.

ON CHOOSE OF b_mi_down OR ALT-CURSOR-DOWN OF {&All_Fields} DO:
  IF mi.is-extra THEN RETURN NO-APPLY. /* Always keep an extra item at bottom */
  FIND xmi WHERE xmi.order = (selection + 1) NO-ERROR.
  IF (AVAILABLE xmi) AND NOT xmi.is-extra THEN DO:
    ASSIGN xmi.order = selection
           mi.order  = selection + 1.
    RUN move-selection-to (mi.order).
    RUN reset_UI. /* Enable/Disable User options */
  END.
  RUN edit-lbl.
END.

/* --------------------------------------------------------------- */
/*		        Exit Conditions				   */
/* --------------------------------------------------------------- */

/* GO Action : NOTE b_ok is AUTO-GO. */
ON GO, END-ERROR, WINDOW-CLOSE OF FRAME menu_edit DO:
  DEFINE VAR ans AS LOGICAL NO-UNDO.
  
  /* Apply LEAVE to the current widget ("Enter"/GO will not do this) */
  error_on_leave = NO.
  
  /**** We don't need this anymore, LEAVE is applied automatically  */
  /*IF CAN-QUERY(FOCUS, "MODIFIED":U) THEN APPLY "LEAVE":U TO FOCUS.*/
  
  IF error_on_leave THEN RETURN NO-APPLY.

  /* Only go if you have valid menus. */
  FIND mi WHERE mi.order = 1 NO-ERROR.

  /* Check for case of whole menu deleted */
  IF AVAILABLE mi AND
     ((menu-name = dflt-menu-name) OR (mi.name = "" AND mi.lbl = ""))
       AND mi.is-extra
  THEN DO:
    ASSIGN delete_menu = true
           valid-menus = TRUE.
    /* Give a warning message if the menu has been deleted item by item. */
    IF deleting-1x1 THEN DO:
      ans = yes.
      MESSAGE "You have deleted the entire menu. Is this OK?"
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE ans.
      IF ans eq NO THEN RETURN NO-APPLY.
    END.
  END.
  ELSE RUN check-menu-elements.

  IF NOT valid-menus THEN RETURN NO-APPLY.
  ELSE DO:
    /* Check for Accelerator key on MSW popup menu */
    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN":U &THEN
      IF menu_type = "POPUP-MENU":U AND CAN-FIND(FIRST mi WHERE
         mi.u-recid = u-rec and mi.accel NE "":U) THEN 
        MESSAGE "Windows does not support accelerator keys on popup menus."
           VIEW-AS ALERT-BOX WARNING.
    &ENDIF
    /* Get the user inputs and Copy the new values back to the _U records */
    RUN rebuild-menus.
    /* If we get here then return the values of the selected menu. */
    pressed_ok = TRUE.

    /* set the window-saved state to false, since we changed attributes */
    RUN adeuib/_winsave.p (h_cur_win, FALSE).
    
    APPLY "U2":U TO FRAME menu_edit. /* This is my WAIT-FOR condition */
  END.
END.

/* Cancel Action  : NOTE b_cancel is AUTO-END-KEY. */
ON END-ERROR, WINDOW-CLOSE OF FRAME menu_edit DO:
  ASSIGN pressed_ok = no
         valid-menus = yes.  /* "cancelling" is a valid action */  
  APPLY "U2":U TO FRAME menu_edit. /* This is my WAIT-FOR condition */
END.

/* --------------------------------------------------------------- */
/*		        Executable Code				   */
/* --------------------------------------------------------------- */

/* Setup for bad exit and other initializations. */
ASSIGN  pressed_ok   = FALSE
	delete_menu  = FALSE
	valid-menus  = FALSE
	deleting-1x1 = FALSE
        /* Set up the buttons that can insert a menu-element */
	b_mi_insert:PRIVATE-DATA = "NORMAL"
	b_mi_rule:PRIVATE-DATA   = "RULE"
	b_mi_skip:PRIVATE-DATA   = "SKIP"
        /* Create List of Menu sub-items */
        h_tree                   = tree:HANDLE in frame menu_edit
	h_tree:DELIMITER         = {&NL} .

/* Compute the caption for the menu */
FIND _U WHERE RECID(_U) = parent_recid.
ASSIGN caption   = "Property Sheet - " + (IF menu_type = "MENUBAR" THEN
	         "Menu Bar" ELSE "Popup Menu") + " for " + _U._NAME
       h_cur_win = _U._WINDOW-HANDLE
       win-type  = _U._WIN-TYPE.
/* Create a default name (used if menu-recid is ? or if user deletes a menu). */
/* ksu 02/22/94 LENGTH SUBSTRING use raw mode */
  IF LENGTH(_U._NAME, "raw":U) > 30 
  THEN dflt-menu-name = "M-" + SUBSTRING(_U._NAME,1,30, "raw":U).
  ELSE IF LENGTH(_U._NAME, "raw":U) > 24 
  THEN dflt-menu-name = "M-" + _U._NAME.
  ELSE dflt-menu-name = 
    (IF menu_type EQ "MENUBAR" THEN "MENU-BAR" ELSE menu_type) + "-" + _U._NAME.
  ASSIGN dflt-menu-name = REPLACE(REPLACE(dflt-menu-name,"[":U,"-":U),
                                   "]":U,"":U).

/* Get the menu information -- if there is no menu then make up one. */
IF menu_recid <> ? THEN DO:
  FIND _U WHERE RECID(_U) = menu_recid.
  /* Copy _M records to the local mi's */
  FIND _M WHERE RECID(_M) = _U._x-recid.
  IF _M._child-recid <> ? THEN RUN menu-report ( _M._child-recid, 1, 1).
  ASSIGN menu-name = _U._NAME
  	 menu-title = _U._LABEL.
END.
ELSE ASSIGN menu-title = ""
            menu-name  = dflt-menu-name.
RUN make-extra-mi.

enable all except mi.accel with frame menu_edit.

DO ON ERROR UNDO, LEAVE  
   ON ENDKEY UNDO, LEAVE:

  DISPLAY menu-name txt tree WITH FRAME menu_edit TITLE caption.
  IF menu_type <> "MENUBAR" 
  THEN DISPLAY menu-title WITH FRAME menu_edit.
  ELSE ASSIGN menu-title:HIDDEN IN FRAME menu_edit    = yes.
  /* Now show everything . Then reset the current cursor at the last 
     possible moment (prior to waiting for user input). */
  VIEW FRAME menu_edit.
  /* If a menu-element is specified, then select that menu-element */
  FIND mi WHERE mi.u-recid eq focus_recid NO-ERROR.
  IF focus_recid ne ? AND AVAILABLE mi THEN DO:
    RUN set-selection-number (mi.order) .
    /* Wait for exit condition (initial focus on menu-element label) */
    RUN adecomm/_setcurs.p ("").
    WAIT-FOR "U2":U OF FRAME menu_edit FOCUS mi.lbl. 
  END.
  ELSE DO:
    RUN set-selection-number (1).
    /* Wait for exit condition (initial focus in menu name) */
    RUN adecomm/_setcurs.p ("").
    WAIT-FOR "U2":U OF FRAME menu_edit FOCUS mi.lbl. 
  END.
  
END.

