/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _uibrows.p

Description:
    The UIB browser.  It lists all the objects created.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author       : D. Ross Hunter,  Wm.T.Wood

Date Created : August 21, 1992 

Last Modified: February 22, 1994 by RPR (updated browser to include new fields,
               locked-column, and separators for Windows.

               10/23/96 gfs Installed Win95 images
               12/19/96 gfs ported for OCX
               03/18/97 gfs OCXs should not show in list if layout is TTY
               08/17/98 jep Made Property Window actively update when selected
                            object in list changes. See 98-04-24-061.
               06/10/99 tsm Changed list parameter to clist, compiler starting
                            complaining about list b/c it is an abbreviation
                            of a reserved keyword (LISTING), the fact that the
                            compiler didn't complain about it before was a bug
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adeuib/uibhlp.i}     /* Help pre-processor directives    */

&Scoped-Define USE-3D YES
{adecomm/adestds.i} /* Standard Definitions             */ 

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

FUNCTION DelString RETURNS CHARACTER (dString AS CHAR, clist AS CHAR) FORWARD.
/*
 * VBX controls are a WINDOWS 3.1 only feature. If this
 * is MOTIF or WIN32, then the define won't happen and the
 * variable won't be added to any display list 
 */
DEFINE VAR DISPLAY-OCX AS LOGICAL NO-UNDO.

/* We must be on the Win32 platform and not in a TTY layout to see OCXs */
ASSIGN DISPLAY-OCX = (OPSYS = "WIN32":U AND _cur_win_type).
IF NOT DISPLAY-OCX THEN _wid-list = DelString ("{&WT-CONTROL}", _wid-list).

DEFINE VAR    cType        AS CHAR NO-UNDO.
DEFINE VAR    ldummy       AS LOGICAL NO-UNDO.
DEFINE VAR    win-count    AS INTEGER NO-UNDO.
DEFINE VAR    cur-rec      AS RECID      INITIAL ? NO-UNDO.

/* Define the buttons for the window. */
DEFINE BUTTON b_ok    LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_help   LABEL "&Help":C12  {&STDPH_OKBTN}.

DEFINE BUFFER p_U   FOR _U.
DEFINE BUFFER w_U   FOR _U.

DEFINE QUERY  widgbrws FOR _U, p_U.
/* Browser definitions                                                      */
DEFINE BROWSE widgbrws QUERY widgbrws
   DISPLAY _U._Name  FORMAT "X(17)":U
           _U._TYPE  FORMAT "X(15)":U
           IF _U._LABEL eq ? THEN "" ELSE _U._LABEL
               FORMAT &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF"
               &THEN "X(25)":U &ELSE "X(18)":U &ENDIF LABEL "Label/Title":U
           (IF p_U._TYPE eq "WINDOW" AND p_U._SUBTYPE eq "Design-Window"
            THEN p_U._LABEL
            ELSE p_U._NAME ) FORMAT "X(17)":U LABEL "Parent":U
           _U._DISPLAY LABEL "Viewed?":U
           _U._ENABLE  LABEL "Enabled?":U
           _U._HIDDEN  LABEL "Hidden?":U
           _U._DBNAME  FORMAT "X(25)":U LABEL "Database Name":U
           _U._TABLE   FORMAT "X(25)":U LABEL "Table Name":U
           &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF" &THEN
                WITH SIZE 84 BY 15.
           &ELSE 
                WITH SEPARATORS WIDTH 80 13 DOWN.
           &ENDIF
           

DEFINE VAR    icon-shft  AS DECIMAL                                    NO-UNDO.
DEFINE VAR    sort-by    AS INTEGER  INITIAL 0                         NO-UNDO
              LABEL   "Sort By"
              VIEW-AS RADIO-SET HORIZONTAL
                      RADIO-BUTTONS "Name", 0,
                                    "Type", 1,
                                    "Parent",2.
DEFINE VAR    in-all-windows AS LOGICAL INITIAL NO                    NO-UNDO
              LABEL "Procedures" 
              VIEW-AS RADIO-SET HORIZONTAL
                      RADIO-BUTTONS "All", YES,
                                    "Current Only", NO .

DEFINE BUTTON b_filters
        IMAGE-UP FILE {&ADEICON-DIR} + "filt-u95" + "{&BITMAP-EXT}" 
        FROM X 0 Y 0  IMAGE-SIZE-P 32 BY 30. 
DEFINE BUTTON b_attrib
        IMAGE-UP FILE {&ADEICON-DIR} + "props-u" +  "{&BITMAP-EXT}"  
        FROM X 0 Y 0  IMAGE-SIZE-P 32 BY 30. 
DEFINE BUTTON b_totop
        IMAGE-UP FILE {&ADEICON-DIR} + "ttop-u95" + "{&BITMAP-EXT}"
        FROM X 0 Y 0  IMAGE-SIZE-P 32 BY 30. 

DEFINE RECTANGLE  rect1    SIZE 15 by .1 {&STDPH_SDIV} EDGE-PIXELS 0.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE  bot-rect {&STDPH_OKBOX}.
&ENDIF
      
DEFINE FRAME instruct
        widgbrws &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF" 
                 &THEN AT ROW 3.7 COL 2
                 &ELSE AT ROW 3.5 COL 4.5 &ENDIF 

       {adecomm/okform.i
   &BOX    = "bot-rect"
   &STATUS = "no"
   &OK     = "b_ok"
   &HELP   = "btn_Help"}

        sort-by         AT ROW 1.3 COLUMN 13 COLON-ALIGNED      
        in-all-windows  COLON 13
        b_totop         AT ROW 1.3 COL 56
        b_filters       AT ROW 1.3 COL 66
        b_attrib        TO 81        
   WITH THREE-D VIEW-AS DIALOG-BOX SIDE-LABELS KEEP-TAB-ORDER TITLE "List Objects"    
   &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF" &THEN
      SIZE 86 BY 21.5.
   &ELSE
      SIZE 87 BY 18.75.
   &ENDIF
 
/* Define tooltips (they do not yet work on the DEFINE) */  
ASSIGN b_filters:TOOLTIP = "Filter"
       b_attrib:TOOLTIP  = "Properties"
       b_totop:TOOLTIP   = "Move to top"
       sort-by:HEIGHT    = 1.125
       in-all-windows:HEIGHT = 1.125
.      
             
RUN adecomm/_setcurs.p (INPUT "WAIT":U).

/* Standard dialog boxes - also equates WINDOW-CLOSE with END-ERROR */
{adeuib/std_dlg.i &FRAME_CLOSE = instruct}

/* Put window name in title if more than 1                                 */
win-count = 0.
FOR EACH _U WHERE CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) AND _U._STATUS = "NORMAL":
  win-count = win-count + 1.
END.
RUN set-title.

/* Help triggers */
ON CHOOSE OF btn_help IN FRAME instruct OR HELP OF FRAME instruct
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Widget_Browser_Window}, ? ).

ON END-ERROR OF FRAME instruct OR
   WINDOW-CLOSE OF FRAME instruct APPLY "GO" TO b_ok.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "FRAME instruct" 
   &BOX   = "bot-rect"
   &OK    = "b_ok" 
   &HELP  = "btn_Help"
}

/* Nudge stuff */
ASSIGN
  b_attrib:COLUMN       = widgbrws:COLUMN + widgbrws:WIDTH - b_attrib:WIDTH
  b_filters:COLUMN      = b_attrib:COLUMN - b_filters:WIDTH - 0.3
  b_totop:COLUMN        = b_filters:COLUMN - b_totop:WIDTH - 0.3
  FRAME instruct:SCROLLABLE = no
  FRAME instruct:WIDTH  = widgbrws:COLUMN + widgbrws:WIDTH + widgbrws:COLUMN - 1
  ldummy = widgbrws:SET-REPOSITIONED-ROW(widgbrws:DOWN - 1, "CONDITIONAL")
  .
 
ASSIGN
   widgbrws:NUM-LOCKED-COLUMNS IN FRAME instruct = 1.

ON VALUE-CHANGED OF sort-by DO:
  sort-by = INTEGER(SELF:SCREEN-VALUE).
  RUN open_query.
END.

ON VALUE-CHANGED OF in-all-windows DO:
  in-all-windows = (SELF:SCREEN-VALUE eq STRING(YES)).
  IF in-all-windows THEN FRAME instruct:TITLE = "List Objects".
  ELSE run set-title.
  RUN open_query.
END.

ON CHOOSE OF b_totop DO:
  DEF VARIABLE tmp-wh AS HANDLE NO-UNDO.
  
  IF _U._TYPE = "DIALOG-BOX":U 
  THEN tmp-wh = _U._HANDLE:PARENT.
  ELSE tmp-wh = _U._HANDLE.
  
  /* Always move the current widget to the top (even if it is a window) */
  ldummy = tmp-wh:MOVE-TO-TOP().
  /* If the widget wasn't a window, then pop its parents to the top. But don't
     pop the window ancestor because this will cover the UIB Browser Dialog box .*/
  DO WHILE tmp-wh:TYPE ne "WINDOW":U: 
    tmp-wh = tmp-wh:PARENT.  
    IF tmp-wh:TYPE NE "WINDOW":U AND CAN-QUERY(tmp-wh,"MOVE-TO-TOP") 
    THEN ldummy = tmp-wh:MOVE-TO-TOP().
  END.
END.

ON CHOOSE OF b_filters DO:
  /* Buttons for the bottom of the screen                                   */
  DEFINE BUTTON btn_ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
  DEFINE BUTTON btn_cancel LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
  DEFINE BUTTON btn_all    LABEL "Select All"
   SIZE 13 BY {&H_OKBTN} MARGIN-EXTRA DEFAULT.
  DEFINE BUTTON btn_cle  LABEL "Clear All" LIKE btn_all.
  DEFINE BUTTON btn_help LABEL "&Help":C12  {&STDPH_OKBTN}.

  /* standard button rectangle */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
  &ENDIF


  DEFINE VAR       i  AS INTEGER                                       NO-UNDO.
  DEFINE VAR tog_brw  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Browsers"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_but  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Buttons"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_com  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Combo-boxes"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_dia  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Dialog-boxes"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_edi  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Editors"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_fil  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Fill-ins"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_frm  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Frames"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_ima  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Images"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_men  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Menus"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_qry  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Queries"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_rad  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Radio-sets"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_rec  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Rectangles"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_sel  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Selection-lists"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_sli  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Sliders"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_sma  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "SmartObjects"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_tog  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Toggle-boxes"
                         INITIAL FALSE                                 NO-UNDO.
  DEFINE VAR tog_txt  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Text"
                         INITIAL FALSE                                 NO-UNDO.

  /*
   * Always define the vbx toggle box, regardless of platform. Then the
   * assignment statements don't have to platform dependent.
   */

  DEFINE VAR tog_ocx  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "{&WL-CONTROL}"
                         INITIAL FALSE                                 NO-UNDO.

  DEFINE VAR tog_win  AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Windows"
                         INITIAL FALSE                                 NO-UNDO.
                         
  DEFINE FRAME filter
        SKIP({&TFM_WID})
        tog_brw AT 17 tog_but AT ROW-OF tog_brw COL 44
        tog_com AT 17 tog_dia AT ROW-OF tog_com COL 44
        tog_edi AT 17 tog_fil AT ROW-OF tog_edi COL 44
        tog_frm AT 17 tog_ima AT ROW-OF tog_frm COL 44
        tog_men AT 17 tog_qry AT ROW-OF tog_men COL 44
        tog_rad AT 17 tog_rec AT ROW-OF tog_rad COL 44
        tog_sel AT 17 tog_sli AT ROW-OF tog_sel COL 44
        tog_sma AT 17 tog_txt AT ROW-OF tog_sma COL 44
        tog_tog AT 17 tog_ocx AT ROW-OF tog_tog COL 44
        tog_win AT 17 
        SKIP

  {adecomm/okform.i
      &BOX    = "rect_Btns"
      &STATUS = "no"
      &OK     = "btn_ok"
      &CANCEL = "btn_cancel"
      &OTHER  = "space({&HM_DBTNG}) btn_all space({&HM_DBTN}) btn_cle"
      &HELP   = "btn_help" }

    WITH NO-LABELS DEFAULT-BUTTON btn_Ok TITLE "Filters"
    THREE-D VIEW-AS DIALOG-BOX WIDTH 83.
                   
  /* Run time layout for button area. */
  {adecomm/okrun.i  
     &FRAME = "FRAME filter" 
     &BOX   = "rect_Btns"
     &OK    = "btn_OK"
     &HELP  = "btn_Help"
  }

  /* Help triggers */
  ON CHOOSE OF btn_help IN FRAME filter OR HELP OF FRAME filter
    RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Widget_Filters_Dlg_Box}, ? ).

  /* Initialize toggles */
  DO i = 1 TO NUM-ENTRIES(_wid-list):
    CASE ENTRY(i,_wid-list):
      WHEN "BROWSE"         THEN tog_brw = yes.
      WHEN "BUTTON"         THEN tog_but = yes.
      WHEN "COMBO-BOX"      THEN tog_com = yes.
      WHEN "DIALOG-BOX"     THEN tog_dia = yes.
      WHEN "EDITOR"         THEN tog_edi = yes.
      WHEN "FILL-IN"        THEN tog_fil = yes.
      WHEN "FRAME"          THEN tog_frm = yes.
      WHEN "IMAGE"          THEN tog_ima = yes.
      WHEN "MENU"           THEN tog_men = yes.
      WHEN "QUERY"          THEN tog_qry = yes.
      WHEN "SUB-MENU"       THEN tog_men = yes.
      WHEN "MENU-ITEM"      THEN tog_men = yes.
      WHEN "RADIO-SET"      THEN tog_rad = yes.
      WHEN "RECTANGLE"      THEN tog_rec = yes.
      WHEN "SELECTION-LIST" THEN tog_sel = yes.
      WHEN "SLIDER"         THEN tog_sli = yes.
      WHEN "SmartObject"    THEN tog_sma = yes.
      WHEN "TOGGLE-BOX"     THEN tog_tog = yes.
      WHEN "TEXT"           THEN tog_txt = yes.
      WHEN "{&WT-CONTROL}"  THEN tog_ocx = yes.
      WHEN "WINDOW"         THEN tog_win = yes.    
    END CASE.
  END.  /* DO i = 1 TO NUM entries */

  /* Exit dialog on window-close */
  ON WINDOW-CLOSE OF FRAME filter APPLY "END-ERROR" TO SELF.
 
  DO TRANSACTION:
    ON CHOOSE OF btn_all IN FRAME filter DO:
      DO WITH FRAME filter:
        ASSIGN tog_brw = yes
               tog_but = yes
               tog_com = yes
               tog_dia = yes
               tog_edi = yes
               tog_fil = yes
               tog_frm = yes
               tog_ima = yes
               tog_men = yes
               tog_qry = yes
               tog_rad = yes
               tog_rec = yes
               tog_sel = yes
               tog_sli = yes
               tog_sma = yes
               tog_tog = yes
               tog_txt = yes
               tog_ocx = DISPLAY-OCX
               tog_win = yes.
        DISPLAY tog_brw tog_but tog_com tog_dia tog_edi tog_fil tog_frm
                tog_ima tog_men tog_qry tog_rad tog_rec tog_sel tog_sli tog_sma
                tog_tog tog_txt tog_ocx tog_win WITH FRAME filter.
      END. /* DO WITH FRAME filter */
    END. /* ON CHOOSE OF btn_all */

    ON CHOOSE OF btn_cle IN FRAME filter DO:
      DO WITH FRAME filter:
        ASSIGN tog_brw = no
               tog_but = no
               tog_com = no
               tog_dia = no
               tog_edi = no
               tog_fil = no
               tog_frm = no
               tog_ima = no
               tog_men = no
               tog_qry = no
               tog_rad = no
               tog_rec = no
               tog_sel = no
               tog_sli = no
               tog_sma = no
               tog_tog = no
               tog_txt = no
               tog_ocx = no
               tog_win = no.
        DISPLAY tog_brw tog_but tog_com tog_dia tog_edi tog_fil tog_frm
                tog_ima tog_men tog_qry tog_rad tog_rec tog_sel tog_sli 
                tog_sma tog_tog tog_txt tog_ocx tog_win 
              WITH FRAME filter.
      END. /* DO WITH FRAME filter */
    END. /* ON CHOOSE OF btn_cle */

    ON VALUE-CHANGED OF tog_brw, tog_but, tog_com, tog_dia, tog_edi,
                        tog_fil, tog_frm, tog_ima, tog_men, tog_qry, 
                        tog_rad, tog_rec, tog_sel, tog_sli, tog_sma, 
                        tog_tog, tog_txt, tog_ocx, tog_win 
                     IN FRAME filter DO:
      DO WITH FRAME filter:
        ASSIGN tog_brw tog_but tog_com tog_dia tog_edi tog_fil tog_frm
               tog_ima tog_men tog_qry tog_rad tog_rec tog_sel tog_sli
               tog_sma tog_tog tog_txt tog_ocx tog_win.
             
        DISPLAY tog_brw tog_but tog_com tog_dia tog_edi tog_fil tog_frm
                tog_ima tog_men tog_qry tog_rad tog_rec tog_sel tog_sli 
                tog_sma tog_tog tog_txt tog_ocx tog_win 
             WITH FRAME filter.
      END.  /* DO WITH FRAME filter */
    END.

    UPDATE btn_ok btn_cancel btn_all btn_cle btn_help tog_brw tog_but tog_com
      tog_dia tog_edi tog_fil tog_frm tog_ima tog_men tog_qry tog_rad 
      tog_rec  tog_sel tog_sli tog_sma tog_txt tog_tog
      tog_ocx WHEN DISPLAY-OCX tog_win 
        WITH FRAME filter.
        
    _wid-list = "".
    IF tog_brw THEN _wid-list = "BROWSE".
    IF tog_but THEN _wid-list = _wid-list + ",BUTTON".
    IF tog_com THEN _wid-list = _wid-list + ",COMBO-BOX".
    IF tog_dia THEN _wid-list = _wid-list + ",DIALOG-BOX".
    IF tog_edi THEN _wid-list = _wid-list + ",EDITOR".
    IF tog_fil THEN _wid-list = _wid-list + ",FILL-IN".
    IF tog_frm THEN _wid-list = _wid-list + ",FRAME".
    IF tog_ima THEN _wid-list = _wid-list + ",IMAGE".
    IF tog_men THEN _wid-list = _wid-list + ",MENU,SUB-MENU,MENU-ITEM".
    IF tog_qry THEN _wid-list = _wid-list + ",QUERY".
    IF tog_rad THEN _wid-list = _wid-list + ",RADIO-SET".
    IF tog_rec THEN _wid-list = _wid-list + ",RECTANGLE".
    IF tog_sel THEN _wid-list = _wid-list + ",SELECTION-LIST".
    IF tog_sli THEN _wid-list = _wid-list + ",SLIDER".
    IF tog_sma THEN _wid-list = _wid-list + ",SmartObject".
    IF tog_tog THEN _wid-list = _wid-list + ",TOGGLE-BOX".
    IF tog_txt THEN _wid-list = _wid-list + ",TEXT".
    IF DISPLAY-OCX AND tog_ocx
               THEN _wid-list = _wid-list + ",{&WT-CONTROL}".
    IF tog_win THEN _wid-list = _wid-list + ",WINDOW".
    RUN open_query.
    
  END. /* TRANSACTION */
  
  HIDE FRAME filter.

END. /* On choose of filters button */

ON CHOOSE OF b_attrib OR MOUSE-SELECT-DBLCLICK OF widgbrws IN FRAME instruct DO:
  DEFINE VARIABLE cWidgets AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp-wh   AS HANDLE    NO-UNDO.
  
  IF NOT AVAILABLE _U 
  THEN MESSAGE "There are no objects that satisfy the filter." SKIP
               "Please change the filter to include an object."
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE DO:
    ASSIGN 
      cur-rec  = RECID(_U)
      cType    = _U._TYPE
      cWidgets = "EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,TOGGLE-BOX,TEXT":U.
      
    RUN adecomm/_setcurs.p ("WAIT"). /* Set the cursor pointer in all windows */
   
    FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
    IF _P._TYPE BEGINS "WEB":U AND CAN-DO(cWidgets,_U._TYPE) THEN
      RUN property_sheet IN _h_uib (_U._HANDLE).
    ELSE
      RUN adeuib/_proprty.p (_U._HANDLE).
      
    /* The Menu property sheet can actually delete menus. */
    IF CAN-DO("MENU,MENU-ITEM,SUB-MENU", cType) THEN DO:
      IF NOT AVAILABLE _U THEN DO:
        FIND _U WHERE _U._HANDLE = _h_win.
        ASSIGN _h_cur_widg  = _U._HANDLE
               cur-rec      = RECID(_U).
               IF CAN-DO("DIALOG-BOX",_U._TYPE) THEN _h_frame = _U._HANDLE.
               ELSE _h_frame = ?.
      END.
    END. /* If menu... */
    
    /* Sometimes, the window/dialog pops up over this dialog, so let's
     * make sure that it gets out of the way by sending it to the
     * bottom. It will then be brought back to the top when this dialog
     * is dismissed.
     */
    IF CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) THEN DO:
      IF _U._TYPE = "DIALOG-BOX":U 
        THEN tmp-wh = _U._HANDLE:PARENT.
      ELSE tmp-wh = _U._HANDLE.
      ASSIGN ldummy = tmp-wh:MOVE-TO-BOTTOM().
    END.
    
    RUN adecomm/_setcurs.p ("").  /* Set the cursor pointer in all windows */
    IF NOT DISPLAY-OCX THEN _wid-list = DelString ("{&WT-CONTROL}", _wid-list).
    RUN open_query.

    /* Deselect all widgets (except _h_cur_widg) */
    RUN deselect_all  IN _h_uib (_h_cur_widg, ?).
    /* Make this the current widget */
    RUN curframe  IN _h_uib (_h_cur_widg).
    RUN display_current IN _h_uib.

    APPLY "ENTRY" TO b_ok IN FRAME instruct.  
  END.
END.  /* On choose of b_attrib */

ON ITERATION-CHANGED, MOUSE-SELECT-CLICK OF BROWSE widgbrws DO:
  IF AVAILABLE _U THEN DO:
    ASSIGN _h_cur_widg  = _U._HANDLE
           _h_win       = _U._WINDOW-HANDLE
           cur-rec      = RECID(_U).
    FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
    IF AVAILABLE _F THEN _h_frame = _F._FRAME.
    ELSE IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN _h_frame = _U._HANDLE.
    ELSE _h_frame = ?.

    /* Deselect all widgets (except _h_cur_widg) */
    RUN deselect_all  IN _h_uib (_h_cur_widg, ?).
    /* Make this the current widget */
    RUN curframe  IN _h_uib (_h_cur_widg).
    RUN display_current IN _h_uib.
    
  END.
END.                                                                         

/* **************************** Main Code Block **************************** */

/* Get the recid of the current widget if there is one */
FIND _U WHERE _U._HANDLE = _h_cur_widg AND
              CAN-DO(_wid-list,_U._TYPE) NO-ERROR.
IF AVAILABLE _U AND _U._STATUS = "NORMAL" THEN cur-rec = RECID(_U).

DISPLAY widgbrws sort-by in-all-windows b_totop b_filters b_attrib b_ok btn_help
   WITH FRAME instruct.
RUN open_query.   

RUN adecomm/_setcurs.p (INPUT "":U). 
DO ON ENDKEY UNDO, RETURN:
  UPDATE b_ok btn_help sort-by in-all-windows b_filters WITH FRAME instruct.
  HIDE FRAME instruct.
END.  
IF LOOKUP("{&WT-CONTROL}",_wid-list) = 0 THEN 
  ASSIGN _wid-list = _wid-list + "," + "{&WT-CONTROL}". /* Put OCX back in the list */  
  
/* **************************** Internal Procedures ************************** */

/* open_query - based on the status of sort_by, reopen the widgetbrws query. */
PROCEDURE open_query:
  DEFINE VAR cur-type AS CHARACTER NO-UNDO.
  IF cur-rec NE ? THEN DO:
    FIND _U WHERE RECID(_U) = cur-rec.   
    IF (_U._TYPE eq "WINDOW" AND _U._SUBTYPE eq "Design-Window":U) 
       OR NOT CAN-DO(_wid-list,_U._TYPE)
    THEN cur-rec = ?.
    ELSE cur-type = _U._TYPE.
  END.
  
  CASE sort-by:   /* Reopen to reflect any changes  */
      WHEN 0 THEN
       OPEN QUERY widgbrws FOR EACH _U WHERE (NOT (_U._NAME BEGINS "_LBL"
                                                    OR (_U._TYPE eq "WINDOW" AND
                                                        _U._SUBTYPE eq "Design-Window":U)))
                                         AND _U._STATUS EQ "NORMAL"
                                         AND CAN-DO(_wid-list,_U._TYPE) 
                                         AND (in-all-windows OR
                                              _U._WINDOW-HANDLE eq _h_win),
                               EACH p_U WHERE RECID(p_U) = _U._PARENT-RECID
                                       BY _U._NAME.
      WHEN 1 THEN
        OPEN QUERY widgbrws FOR EACH _U WHERE (NOT (_U._NAME BEGINS "_LBL"
                                                    OR (_U._TYPE eq "WINDOW" AND
                                                        _U._SUBTYPE eq "Design-Window":U)))
                                         AND _U._STATUS EQ "NORMAL"
                                         AND CAN-DO(_wid-list,_U._TYPE) 
                                         AND (in-all-windows OR
                                              _U._WINDOW-HANDLE eq _h_win),
                                EACH p_U WHERE RECID(p_U) = _U._PARENT-RECID
                                       BY _U._TYPE.
      WHEN 2 THEN
        OPEN QUERY widgbrws FOR EACH _U WHERE (NOT (_U._NAME BEGINS "_LBL"
                                                    OR (_U._TYPE eq "WINDOW" AND
                                                        _U._SUBTYPE eq "Design-Window":U)))
                                         AND _U._STATUS EQ "NORMAL"
                                         AND CAN-DO(_wid-list,_U._TYPE) 
                                         AND (in-all-windows OR
                                              _U._WINDOW-HANDLE eq _h_win),
                                EACH p_U WHERE RECID(p_U) = _U._PARENT-RECID
                                     BY _U._WINDOW-HANDLE
                                     BY IF _U._TYPE = "WINDOW" THEN 1 ELSE 2
                                     BY IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE)
                                                     THEN 1 ELSE 2
                                     BY p_U._NAME
                                     BY _U._NAME.
  END CASE.
  
  IF cur-rec NE ? THEN REPOSITION widgbrws TO RECID cur-rec.
  IF NUM-RESULTS("widgbrws") > 0 AND widgbrws:VISIBLE IN FRAME instruct THEN
    ldummy = widgbrws:SELECT-FOCUSED-ROW() IN FRAME instruct.

  IF AVAILABLE _U 
  THEN ENABLE widgbrws b_totop b_attrib WITH FRAME instruct.
  ELSE DISABLE widgbrws b_totop b_attrib WITH FRAME instruct.

END PROCEDURE.

PROCEDURE set-title.
  IF win-count > 1 THEN DO:
    FIND w_U WHERE w_U._HANDLE = _h_win.  
    FRAME instruct:TITLE = "List Objects - " +  
                 (IF w_U._SUBTYPE ne "Design-Window":U 
                  THEN w_U._NAME ELSE w_U._LABEL).
  END.
END PROCEDURE.

FUNCTION DelString RETURNS CHARACTER
  (dstring AS CHARACTER, clist AS CHARACTER):

  /* Deletes an element from a comma separated list */
  DEFINE VARIABLE loc AS INTEGER NO-UNDO.

  ASSIGN loc = LOOKUP(dstring,clist).
  IF loc > 0 /* found */ THEN
    clist = REPLACE(clist,(IF loc = 1 THEN "" ELSE ",") + dstring, "").
  
  RETURN clist.

END FUNCTION.

