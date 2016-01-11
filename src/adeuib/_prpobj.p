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

File: _prpobj.p

Description:
    Procedure to create a property sheet for all the standard objects.
    This is a single source file that creates a dialog-box and modifies
    it dynamically to handle different widget types.

Note:
    Originally, this was called _proprty.  However, with the advent of
    new objects (such as a QUERY or SmartObjects or no-window Windows),
    we needed a way to go to different programs depending on the object
    type.
    
Input Parameters:
   h_self : The handle of the object we are editing

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1994     

Modified:
  wood 7/31/95  Parent Property Sheet to ACTIVE-WINDOW (so it pops up over
                the current window when you dbl-click
  wood 8/1/95   Don't allow editting ROW/COL if "Size-to-Parent".
  gfs  3/8/96   Added support for Win95 slider 
  gfs  3/11/96  Added support for load-small-icon on a window
  drh  7/12/96  Removed support for load-small-icon on a window
  wood 8/14/96  Remove NO-BOX, NO-LABELS, NO-UNDERLINE support 
                (because it did not work Bug # 96-06-24-033)  
  gfs  10/23/96 Removed text from image buttons and installed tooltips.
  gfs  10/29/96 Added tooltip field on primary property page
  gfs  01/06/97 Needed to recreate slider if NO-CURRENT-VALUE was changed
  gfs  01/06/97 Needed to recreate editor if NO-BOX was changed
  gfs  01/06/97 Display error if radio-buttons string < 1 item.
  drh  01/23/97 Implemented new button size & fixed image text
  gfs  01/29/98 Changed refs to _F._SCROLLBAR-V to _U._SCROLLBAR-V
  slk  01/98    Added parameters to _fldinfo.p call
  gfs  02/12/98 Expanded slider min and max to 32bit numbers.
  jep  03/12/98 Enabled DB-FIELDS button to work with Data Objects by
                updating PROCEDURE db_field_selection to support
                Data Object Fields.
  hd   09/04/98 Moved validation of list-items and radio-buttons to _abfunc.w.
  hd   09/22/98 Moved change-data-type to _abfunc.w.
  gfs  10/21/98 Added support for  list-item-pairs for sellist and combo 
  tsm  02/18/99 Change slider frequency validation to check for the difference
                between the min and max values when the min value is negative
                or greater than zero  
  tsm  04/12/99 Added support for various Intl Numeric Formats (in addition to
                American and European).  Used session set-numeric-format method
                to set format back to user's setting after setting it to 
                American.  Check session numeric-decimal-point and
                numeric-separator to determine if adecomm/_convert is called
                rather than checking if European or American.  And changed calls 
                to adecomm/_convert to support converting from American to 
                non-American (A-TO-N) and non-American to American (N-TO-A), 
                rather than American to European and vice versa.  Used 
                session numeric-decimal-point and numeric-separator to set
                standard formats and to display the format based on user's 
                options.   
  tsm  05/27/99 Changed filters parameter in call to _fndfile.p because it now 
                needs list-item pairs rather than list-items to support new 
                image formats
  tsm  06/03/99 Added tog-proc.i and moved toggle-placement block into its
                own internal procedure to avoid blowing the action code
                segment limit
  tsm  06/03/99 Added stretch-to-fit, retain-shape and transparent image attributes
  tsm  06/04/99 Added context-help and context-help file attributes
  tsm  06/07/99 Added context-help-id attribute
  tsm  06/08/99 Added support for editable combo-boxes (Subtype attribute) 
  tsm  06/10/99 Added auto-completion and unique-match for combo-boxes
  tsm  06/14/99 Added support for separator fgcolor
  tsm  06/18/99 Added support for max-chars
  hd   06/18/99 Error message in menu_bar_change if foreign menubar.
  tomn 01/07/2000 Include "RowObject" Temp-Table definition for SDO when
                  writing out db field to determine new size and type. 
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h_self   AS WIDGET                            NO-UNDO.



&GLOBAL-DEFINE WIN95-BTN  TRUE
&SCOPED-DEFINE USE-3D     YES

{adecomm/adestds.i}             /* Standards for "Sullivan Look"            */
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/layout.i}               /* Definitions of the layout records        */
{adeuib/property.i}             /* Temp-Table containing attribute info     */
{adeuib/triggers.i}             /* Trigger Temp-table definition            */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */
{adeuib/sharvars.i}             /* The shared variables                     */
{adm2/globals.i}
/** Contains definitions for dynamics design-time temp-tables. **/
{destdefi.i}

/* FUNCTION PROTOTYPES */
FUNCTION db-tbl-name RETURNS CHARACTER
  (INPUT db-tbl AS CHARACTER) IN _h_func_lib.

FUNCTION validate-list-items RETURNS LOGICAL
  (INPUT p_Uhandle AS HANDLE) IN _h_func_lib.

FUNCTION validate-list-item-pairs RETURNS LOGICAL
  (INPUT p_Uhandle AS HANDLE) IN _h_func_lib.

FUNCTION validate-radio-buttons RETURNS LOGICAL
  (INPUT p_Uhandle AS HANDLE) IN _h_func_lib.

FUNCTION change-data-type RETURNS LOGICAL
  (INPUT p_Uhandle    AS HANDLE,
   INPUT pNewDataType AS CHAR) IN _h_func_lib.

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

&SCOPED-DEFINE datatypes CHARACTER,DATE,DECIMAL,LOGICAL,INTEGER,RECID
&SCOPED-DEFINE FRAME-NAME prop_sht

&SCOPED-DEFINE sicon_txt IF _C._SMALL-ICON eq '' THEN ''~
                         ELSE ENTRY(NUM-ENTRIES(_C._SMALL-ICON,'/'),_C._SMALL-ICON,'/')

{adeuib/tog-hand.i}             /* Definitions of the handles for the toggles */
DEFINE BUFFER      x_U FOR _U.
DEFINE BUFFER      x_C FOR _C.
DEFINE BUFFER      x_L FOR _L.
DEFINE BUFFER      x_P FOR _P.
DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER parent_C FOR _C.
DEFINE BUFFER PARENT_P FOR _P.
DEFINE BUFFER  label_U FOR _U.     

DEFINE NEW SHARED VARIABLE v-hgt  AS DECIMAL                 NO-UNDO.
DEFINE NEW SHARED VARIABLE v-wdth AS DECIMAL                 NO-UNDO.

DEFINE VARIABLE  isDynbrow         AS LOGICAL NO-UNDO.
DEFINE VARIABLE  isDynview         AS LOGICAL NO-UNDO.
DEFINE VARIABLE  adjust AS        DECIMAL           DECIMALS 2 NO-UNDO.
DEFINE VARIABLE  col-lbl-adj AS   DECIMAL INITIAL 0 DECIMALS 2 NO-UNDO.
DEFINE VARIABLE  name AS          CHAR LABEL "Object":U FORMAT "X(80)" VIEW-AS FILL-IN
                                     SIZE 61 BY 1            NO-UNDO.
DEFINE BUTTON    btn_adv          LABEL "&Advanced...":L SIZE 15 BY 1.125.
DEFINE BUTTON    btn_color        IMAGE-UP FILE {&ADEICON-DIR} + "color1-u" +
                                   "{&BITMAP-EXT}" FROM X 2 Y 2 IMAGE-SIZE-P 32 BY 32.  
DEFINE RECTANGLE rect-pal         SIZE .18 BY 3   NO-FILL EDGE-PIXELS 3 FGC 1.
DEFINE VARIABLE  fg_h             AS WIDGET-HANDLE           NO-UNDO.
/* fg_h          is the handle of the frames field group.  NOTE: in the UIB         */
/*               all frames are dynamic and therefore single frames with only 1     */
/*               field group.                                                       */
DEFINE VARIABLE  child_handle     AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE  last-tab         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE  l_error_on_go    AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE  lbl_wdth         AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE  low-limit        AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE  new_btns         AS LOGICAL INITIAL "TRUE"  NO-UNDO.
DEFINE VARIABLE  IF_OK            AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE  recreate-self    AS LOGICAL INITIAL "FALSE" NO-UNDO.
DEFINE VARIABLE  ret-msg          AS CHARACTER               NO-UNDO.
DEFINE VARIABLE  stupid           AS LOGICAL NO-UNDO.  /* Error catcher for methods */
DEFINE VARIABLE  tmp_hdl          AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE  togcnt           AS INTEGER                 NO-UNDO.
DEFINE VARIABLE  tog-rows         AS INTEGER                 NO-UNDO.
DEFINE VARIABLE  tog-spc          AS DECIMAL INITIAL .99     NO-UNDO.
DEFINE VARIABLE  txt_geom         AS CHAR VIEW-AS TEXT SIZE 72 BY .77 FORMAT "X(40)".
DEFINE VARIABLE  txt_attrs        AS CHAR VIEW-AS TEXT SIZE 72 BY .77 FORMAT "X(40)".
DEFINE VARIABLE  h_menu           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE  update_menu      AS LOGICAL   INITIAL no    NO-UNDO.
DEFINE VARIABLE  delete_menu      AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE  popup_recid      AS RECID                   NO-UNDO.
DEFINE VARIABLE  h_menu-bar       AS WIDGET                  NO-UNDO.
DEFINE VARIABLE  update_menu-bar  AS LOGICAL   INITIAL no    NO-UNDO.
DEFINE VARIABLE  delete_menu-bar  AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE  menu-bar_recid   AS RECID                   NO-UNDO.
DEFINE VARIABLE  tog-col-2        AS DECIMAL DECIMALS 2  INITIAL 27.5  NO-UNDO.
DEFINE VARIABLE  tog-col-3        AS DECIMAL DECIMALS 2  INITIAL 50.5  NO-UNDO.
DEFINE VARIABLE  upr-limit        AS DECIMAL DECIMALS 2                NO-UNDO.
DEFINE VARIABLE  xpos             AS DECIMAL DECIMALS 2                NO-UNDO.
DEFINE VARIABLE  valid-data-tp    AS CHAR                    NO-UNDO
                 INITIAL "Character,Date,Decimal,Integer,Logical".
DEFINE VARIABLE  valid-data-tp-fill-in AS CHAR                    NO-UNDO
                 INITIAL "Character,Date,DateTime,DateTime-Tz,Decimal,Integer,Logical".
DEFINE VARIABLE  valid-data-tp-editor  AS CHAR                    NO-UNDO
                 INITIAL "Character,LongChar".
DEFINE VARIABLE  valid-list       AS CHAR                    NO-UNDO.
DEFINE VARIABLE  conv_fmt         AS CHAR                    NO-UNDO.
DEFINE VARIABLE hDataObject       AS HANDLE                  NO-UNDO.
DEFINE VARIABLE UsesDataObject    AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE image-formats     AS CHAR                    NO-UNDO.
DEFINE VARIABLE lFreqValidate     AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE h_align               AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_dbfld           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_down            AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_flds            AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_fmt             AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_font            AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_insen           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_mdfy            AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_menu-bar        AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_tabs            AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_trans           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_ttl_clr         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_up              AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_btn_popup           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_col                 AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_col_lbl             AS WIDGET-HANDLE           NO-UNDO. 
DEFINE VARIABLE h_context-help        AS WIDGET-HANDLE           NO-UNDO. 
DEFINE VARIABLE h_context-help-btn    AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_context-help-file   AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_context-help-id     AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_context-hlp-fil_lbl AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_context-hlp-id_lbl  AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_context-txt         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_data-type           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE hDevManager           AS HANDLE                  NO-UNDO.
DEFINE VARIABLE h_dt_lbl              AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_ep_lbl              AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_edge-pixels         AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_fmt_lbl             AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_fn_txt              AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_fn_dwn_txt          AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_fn_ins_txt          AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_format              AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_frequency           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_freq_lbl            AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_hgt                 AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_hgt_lbl             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_inner-lines         AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_innr-lns_lbl        AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_label               AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_label_lbl           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_listType            AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_locked-cols         AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_locked-cols_lbl     AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_max-chars           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_mac_lbl             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_max-dg              AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_max-dg_lbl          AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_max-value           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_mav_lbl             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_min-value           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_miv_lbl             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_query               AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_qry_lbl             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_nolbl               AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_row                 AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_row_lbl             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_row-hgt             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_row-hgt_lbl         AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_sicon               AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_sicon_txt           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_subtype             AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_tic-marks           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_tic_lbl             AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_tog                 AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_v-hgt               AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_v-hgt_lbl           AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_v-wdth              AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_v-wdth_lbl          AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_wdth                AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE h_wdth_lbl            AS WIDGET-HANDLE           NO-UNDO.  
DEFINE VARIABLE txt_down              AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE txt_image             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE txt_insen             AS WIDGET-HANDLE           NO-UNDO.   
DEFINE VARIABLE txt_sicon             AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE txt_up                AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_tooltip             AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_tooltip_lbl         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_delimiter           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_delimiter_lbl       AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_folder-win-to-launch           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_folder-win-to-launch_lbl       AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_window-title-field             AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_window-title-field_lbl         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_custom-super-proc              AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_custom-super-proc_lbl          AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_custom-super-proc_btn          AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h_custom-super-proc_btnd         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE cCustom_super_proc               AS CHARACTER               NO-UNDO.
DEFINE VARIABLE cCustom_Super_path               AS CHARACTER               NO-UNDO.

DEFINE VARIABLE y-move            AS INTEGER                 NO-UNDO.
/* y-move       is the number of pixels a field must move in converting from     */
/*              side-labels to column-labels or vice-versa                       */

DEFINE VARIABLE cur-row           AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE dir-del           AS CHARACTER
                INITIAL &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF"
                      &THEN "/" &ELSE "~\" &ENDIF            NO-UNDO.
DEFINE VARIABLE icon-hp           AS INTEGER                 NO-UNDO.
DEFINE VARIABLE icon-wp           AS INTEGER                 NO-UNDO.

/* Save values for comparison on ok */
DEFINE VARIABLE sav-box     AS LOGICAL   INITIAL ? NO-UNDO. /* BOX                */
DEFINE VARIABLE sav-dflt    AS LOGICAL   INITIAL ? NO-UNDO. /* DEFAULT STYLE      */
DEFINE VARIABLE sav-dt      AS CHARACTER INITIAL ? NO-UNDO. /* DATA-TYPE          */
DEFINE VARIABLE sav-exp     AS LOGICAL   INITIAL ? NO-UNDO. /* Radio-set Expand   */
DEFINE VARIABLE sav-freq    AS INTEGER   INITIAL ? NO-UNDO. /* FREQUENCY          */
DEFINE VARIABLE sav-hgt     AS INTEGER   INITIAL ? NO-UNDO. /* HEIGHT             */
DEFINE VARIABLE sav-hor     AS LOGICAL   INITIAL ? NO-UNDO. /* HORIZONTAL         */
DEFINE VARIABLE sav-id      AS CHARACTER NO-UNDO.           /* DOWN IMAGE         */
DEFINE VARIABLE sav-ii      AS CHARACTER NO-UNDO.           /* INSENSITIVE IMAGE  */
DEFINE VARIABLE sav-init    AS CHARACTER INITIAL ? NO-UNDO. /* INITIAL-DATA       */
DEFINE VARIABLE sav-iu      AS CHARACTER NO-UNDO.           /* UP (or ICON) IMAGE */
DEFINE VARIABLE sav-iu2     AS CHARACTER NO-UNDO.           /* SMALL-ICON file    */
DEFINE VARIABLE sav-l-s     AS LOGICAL   INITIAL ? NO-UNDO. /* LARGE-TO-SMALL     */
DEFINE VARIABLE sav-lbl     AS LOGICAL   INITIAL ? NO-UNDO. /* LABELS             */
DEFINE VARIABLE sav-lbla    AS CHARACTER INITIAL ? NO-UNDO. /* Label str-attrs    */
DEFINE VARIABLE sav-lo      AS CHARACTER INITIAL ? NO-UNDO. /* Layout Name        */
DEFINE VARIABLE sav-max     AS INTEGER   INITIAL ? NO-UNDO. /* MAX-VALUE          */
DEFINE VARIABLE sav-min     AS INTEGER   INITIAL ? NO-UNDO. /* MIN-VALUE          */
DEFINE VARIABLE sav-msg     AS LOGICAL   INITIAL ? NO-UNDO. /* Message Area       */
DEFINE VARIABLE sav-ncv     AS LOGICAL   INITIAL ? NO-UNDO. /* NO-CURRENT-VALUE   */
DEFINE VARIABLE sav-qry     AS CHARACTER INITIAL ? NO-UNDO. /* Query editor       */
DEFINE VARIABLE sav-rb      AS CHARACTER CASE-SENSITIVE NO-UNDO. /* Radio buttons */
DEFINE VARIABLE sav-scr     AS LOGICAL   INITIAL ? NO-UNDO. /* SCROLLABLE         */
DEFINE VARIABLE sav-sh      AS LOGICAL   INITIAL ? NO-UNDO. /* SCROLLBAR-H        */
DEFINE VARIABLE sav-slab    AS LOGICAL   INITIAL ? NO-UNDO. /* SIDE-LABEL         */
DEFINE VARIABLE sav-sub     AS CHARACTER INITIAL ? NO-UNDO. /* Combo SUBTYPE      */    
DEFINE VARIABLE sav-sv      AS LOGICAL   INITIAL ? NO-UNDO. /* SCROLLBAR-V        */
DEFINE VARIABLE sav-tic     AS CHARACTER INITIAL ? NO-UNDO. /* TIC-MARKS          */
DEFINE VARIABLE sav-ttl     AS LOGICAL   INITIAL ? NO-UNDO. /* TITLE              */
DEFINE VARIABLE sav-3d      AS LOGICAL   INITIAL ? NO-UNDO. /* 3-D LOOK           */
DEFINE VARIABLE sav-stsa    AS LOGICAL   INITIAL ? NO-UNDO. /* Status-Bar         */
DEFINE VARIABLE sav-vat     AS CHARACTER INITIAL ? NO-UNDO. /* VIEW-AS-TEXT       */
DEFINE VARIABLE sav-ldef    AS INTEGER   INITIAL ? NO-UNDO. /* Logical Fill-in initial */
DEFINE VARIABLE switchlist  AS LOGICAL   INITIAL no NO-UNDO. /* Switch between LIST-ITEMS and LIST-ITEM-PAIRS */
DEFINE VARIABLE sav-lp      AS CHARACTER INITIAL ? NO-UNDO. /* Save list-item-pairs */
DEFINE VARIABLE tmpstr      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE i           AS INTEGER             NO-UNDO.

DEFINE BUFFER sync_L   FOR _L.
DEFINE VARIABLE sav_row      LIKE _L._ROW                      NO-UNDO.
DEFINE VARIABLE sav_col      LIKE _L._COL                      NO-UNDO.
DEFINE VARIABLE sav_width    LIKE _L._WIDTH                    NO-UNDO.
DEFINE VARIABLE sav_height   LIKE _L._HEIGHT                   NO-UNDO.
DEFINE VARIABLE sav_v-height LIKE _L._VIRTUAL-HEIGHT           NO-UNDO.
DEFINE VARIABLE sav_v-width  LIKE _L._VIRTUAL-WIDTH            NO-UNDO.

DEFINE VARIABLE notAmerican  AS LOGICAL  NO-UNDO.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

DEFINE STREAM  temp_stream.
DEFINE BUFFER B_U FOR _U.
DEFINE BUFFER B_C FOR _C.


CREATE WIDGET-POOL.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
  ASSIGN icon-hp = 38
         icon-wp = 38.
&ELSE
  ASSIGN icon-hp = MIN(48, 1.55 * SESSION:PIXELS-PER-ROW)
         icon-wp = MIN(40, 7 * SESSION:PIXELS-PER-COLUMN).
&ENDIF

/* Determine whether the numeric format is non-American and sets notAmerican
   variable which is used to determine whether to call _convert.p or not */
IF _numeric_separator NE "," OR _numeric_decimal NE "." THEN notAmerican = yes.
ELSE notAmerican = no.
  
/* We convert from a selection list to a text list by replacing commas with
   the End-Of-Line string.  This is chr(10) in UNIX but is chrs 13/10 in
   windows. */     

BIG-TRANS-BLK:
DO TRANSACTION:
/* Turn off status messages, otherwise they will appear in the status area of
 * the Design window.  They are turned back on before exiting the procedure */
STATUS INPUT OFF.

/* Create necessary widgets and initialize with current data                */
FIND _U WHERE _U._HANDLE = h_self.
FIND _L WHERE RECID(_L) = _U._lo-recid.
FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
IF NOT AVAILABLE _F THEN DO:
  FIND _C WHERE RECID(_C) = _U._x-recid.
  IF _C._q-recid NE ? THEN FIND _Q WHERE RECID(_Q) = _C._q-recid NO-ERROR.
END.



/* Text widgets are not changeable in an alternative layout */
IF _U._TYPE = "TEXT" AND _U._LAYOUT-NAME NE "Master Layout" THEN DO:
  /* Text widgets are not changeable in an alternative layout */
  MESSAGE "Text objects may only be modified in the Master Layout." SKIP
          "Use a fill-in with the VIEW-AS-TEXT attribute instead."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  RETURN.
END.

FIND parent_U WHERE RECID(parent_U) = _U._parent-recid NO-ERROR.
IF AVAILABLE parent_U THEN DO:
  FIND parent_C WHERE RECID(parent_C) = parent_U._x-recid.
  FIND parent_L WHERE RECID(parent_L) = parent_U._lo-recid.
  FIND PARENT_P WHERE parent_P._WINDOW-HANDLE eq parent_U._WINDOW-HANDLE.
  RUN save_parent_info.
END.

/*Note that certain fields are not sensitized if not dynamic object*/
IF _DynamicsIsRunning AND AVAILABLE _P THEN DO:
    ASSIGN isDynbrow =  LOOKUP(_P.OBJECT_type_code, 
                               DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                 INPUT "DynBrow":U)) <> 0.
           isDynView =  LOOKUP(_P.OBJECT_type_code, 
                               DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                 INPUT "DynView":U)) <> 0.
END.
ELSE ASSIGN isDynBrow = FALSE
            isDynView = FALSE.


/* If object is connected to a data object, be sure its running. jep-code */
ASSIGN UsesDataObject = (_P._DATA-OBJECT <> "").
IF UsesDataObject THEN
    hDataObject = DYNAMIC-FUNC("get-proc-hdl" IN _h_func_lib, INPUT _P._DATA-OBJECT).

IF NOT RETRY THEN DO:
  DEFINE FRAME prop_sht
         name         AT ROW 1.13  COL 11 COLON-ALIGNED {&STDPH_FILL}
         rect-pal     AT ROW 1.13  COL 76.5
         btn_color    AT ROW 1.13  COL 78.75 NO-LABEL
         txt_geom     AT ROW 10    COL 2   BGC 1 FGC 15 NO-LABEL
         txt_attrs    AT ROW 25    COL 2   BGC 1 FGC 15 NO-LABEL
         btn_adv      AT ROW 25    COL 50         
       WITH VIEW-AS DIALOG-BOX SIDE-LABELS SIZE 88 BY 28 THREE-D.

  IF CAN-DO("WINDOW",_U._TYPE) THEN RUN setup_for_window.

  RUN remember_layout.
  RUN adjust_frame.
  RUN save_off.    /* Save widget attributes that would cause the widgets to be recreated 
                      if changed.                                                         */
  
  /* *************************** Generate Needed Widgets ************************** */

  /* Set up the stuff at the top of the property sheet --- NON-toggle stuff         */
  RUN create_top_stuff.
  RUN setup_toggles.
  RUN set_tab_order.

  /* Now display toggles */
   RUN count_toggles.
 
  /* Create toggles */
  RUN toggle_placement.
  
  /* Desensitize inappropriate toggles for TTY mode                               */
  IF NOT _L._WIN-TYPE THEN DO:
    IF h_3-D         NE ? THEN h_3-D:SENSITIVE              = FALSE.
  END.

  {adecomm/okbar.i}
  RUN final_adjustments.

END.  /* IF NOT RETRY */

ELSE DO:  /* A RETRY */
  IF _U._TYPE = "DIALOG-BOX" THEN
  /* THIS IS A RETRY - Note only row and col of dialogs cause this to happen    */
    ASSIGN _L._ROW = IF h_row:SCREEN-VALUE = "?" THEN ?
                                                 ELSE DECIMAL(h_row:SCREEN-VALUE)
           _L._COL = IF h_col:SCREEN-VALUE = "?" THEN ?
                                                 ELSE DECIMAL(h_col:SCREEN-VALUE).
END.


ON WINDOW-CLOSE OF FRAME prop_sht APPLY "END-ERROR":U TO SELF.

ON ENDKEY,END-ERROR OF FRAME prop_sht 
DO:
   IF VALID-HANDLE(hDataObject) THEN
      DYNAMIC-FUNCTION("shutdown-proc":U IN _h_func_lib, _P._Data-Object).        
END.

ON CHOOSE OF btn_help IN FRAME prop_sht OR HELP OF FRAME prop_sht DO:
  DEFINE VARIABLE help-context AS INTEGER NO-UNDO.
  CASE _U._TYPE:
    WHEN "BROWSE"         THEN help-context = {&BROWSER_Attrs}.
    WHEN "BUTTON"         THEN help-context = {&BUTTON_Attrs}.
    WHEN "COMBO-BOX"      THEN help-context = {&COMBO_BOX_Attrs}.
    WHEN "DIALOG-BOX"     THEN help-context = {&DIALOG_BOX_Attrs}.
    WHEN "EDITOR"         THEN help-context = {&EDITOR_Attrs}.
    WHEN "FILL-IN"        THEN help-context = {&FILL_IN_Attrs}.
    WHEN "FRAME"          THEN help-context = {&FRAME_Attrs}.
    WHEN "IMAGE"          THEN help-context = {&IMAGE_Attrs}.
    WHEN "RADIO-SET"      THEN help-context = {&RADIO_SET_Attrs}.
    WHEN "RECTANGLE"      THEN help-context = {&RECTANGLE_Attrs}.
    WHEN "SELECTION-LIST" THEN help-context = {&SELECTION_LIST_Attrs}.
    WHEN "SLIDER"         THEN help-context = {&SLIDER_Attrs}.
    WHEN "TEXT"           THEN help-context = {&TEXT_Attrs}.
    WHEN "TOGGLE-BOX"     THEN help-context = {&TOGGLE_BOX_Attrs}.
    WHEN "{&WT-CONTROL}"  THEN help-context = {&VBX_Attrs}.
    WHEN "WINDOW"         THEN help-context = {&WINDOW_Attrs}.
  END CASE.
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", help-context, ? ).
END.

/* Make sure names are valid */
ON LEAVE OF name IN FRAME prop_sht DO:
  DEFINE VARIABLE valid_name AS LOGICAL NO-UNDO.

  IF _U._TYPE NE "TEXT":U THEN DO:
    IF SELF:SCREEN-VALUE <> _U._NAME THEN DO:
      RUN adeuib/_ok_name.p (SELF:SCREEN-VALUE, RECID(_U), OUTPUT valid_name).
      IF valid_name THEN DO:
        /* If the old name is a DBname and the disposition is "LIKE" and
           _LIKE-FIELD is blank, save the old name in the _LIKE-FIELD  */
        IF AVAILABLE(_F) AND _F._DISPOSITION = "LIKE" AND _U._DBNAME NE "" AND
           _F._LIKE-FIELD = "" THEN _F._LIKE-FIELD = _U._NAME.
        ASSIGN _U._NAME = INPUT FRAME prop_sht name
               FRAME prop_sht:TITLE = "Property Sheet - " + _U._NAME.
        IF _U._TYPE = "{&WT-CONTROL}" THEN
          ASSIGN _U._HANDLE:NAME = _U._NAME.
      END.
      ELSE RETURN NO-APPLY.
    END.
  END. /* If not deal with text */
  ELSE
    _F._INITIAL-DATA = INPUT FRAME prop_sht name.
END.

ON CHOOSE OF btn_adv DO:
  /* For logicals, we validate the format so we can get an 
   * appropriate initial-data for the advanced prop sheet. */
  IF CAN-DO("FILL-IN,COMBO-BOX", _U._TYPE) AND _F._DATA-TYPE = "LOGICAL" THEN DO:
    IF NUM-ENTRIES(_F._FORMAT,"/":U) NE 2 THEN DO:
      MESSAGE "'" _F._FORMAT "' is an invalid logical format." SKIP
              "Use a format of the form 'yes/no' or 'true/false'."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      APPLY "ENTRY" TO h_format.
      RETURN NO-APPLY.
    END.
    ELSE _F._INITIAL-DATA = ENTRY (sav-ldef, _F._FORMAT,"/":U).
  END. /* data-type is logical */

  RUN adeuib/_advprop.w (RECID(_U), lbl_wdth).

  /* Update logical fill-ins saved default-- it may have changed in advprop */
  IF CAN-DO("FILL-IN,COMBO-BOX", _U._TYPE) AND _F._DATA-TYPE = "LOGICAL":U THEN DO:
     sav-ldef = LOOKUP (TRIM(_F._INITIAL-DATA), _F._FORMAT,"/":U).
     IF sav-ldef = 0 THEN sav-ldef = 2.
  END.

  IF _U._TYPE = "FRAME" AND (_C._PAGE-TOP OR _C._PAGE-BOTTOM) THEN
    h_DOWN:CHECKED = FALSE.

  IF h_align NE ? THEN h_align:SCREEN-VALUE = _U._ALIGN.

  RUN compute_lbl_wdth. 

  CASE _U._ALIGN:
    WHEN "R" THEN xpos = _L._COL  - 1 + _L._WIDTH.
    WHEN "C" THEN xpos = _L._COL - 2.
    OTHERWISE
      xpos = IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND parent_C._SIDE-LABELS THEN
                   /* SIDE-LABELS */  (_L._COL - lbl_wdth)
                ELSE IF parent_U._TYPE = "FRAME" AND NOT parent_C._SIDE-LABELS AND
                     NOT parent_L._NO-LABELS THEN
                   /* COLUMN LABELS */ (_L._COL - MAX(0, lbl_wdth - _L._WIDTH))
                ELSE _L._COL.
  END.  /* Case */
   
  ASSIGN h_col:SCREEN-VALUE  = IF xpos NE ? THEN STRING(xpos,"->>9.99") ELSE "?"
         h_row:SCREEN-VALUE  = IF _L._ROW NE ? THEN 
                                 STRING(_L._ROW - col-lbl-adj,"->>9.99") ELSE "?"
         h_wdth:SCREEN-VALUE = STRING(_L._WIDTH,">>9.99")
         h_hgt:SCREEN-VALUE  = STRING(_L._HEIGHT,">>9.99").
  IF h_row-hgt NE ? THEN
    ASSIGN h_row-hgt:SCREEN-VALUE = STRING(_C._ROW-HEIGHT,">>9.99").
  IF h_v-wdth NE ? THEN
    ASSIGN h_v-wdth:SCREEN-VALUE = STRING(_L._VIRTUAL-WIDTH,">>9.99")
           h_v-hgt:SCREEN-VALUE  = STRING(_L._VIRTUAL-HEIGHT,">>9.99").
  IF h_REMOVE-FROM-LAYOUT NE ?  THEN
    ASSIGN h_REMOVE-FROM-LAYOUT:CHECKED = _L._REMOVE-FROM-LAYOUT. 
  APPLY "ENTRY" TO btn_OK IN FRAME prop_sht.
END.

ON CHOOSE OF btn_color DO:
  DEFINE VARIABLE l_ok           AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE parent_bgcolor AS INTEGER INITIAL ? NO-UNDO.
  DEFINE VARIABLE parent_fgcolor AS INTEGER INITIAL ? NO-UNDO. 
  DEFINE VARIABLE sav_bgc        AS INTEGER           NO-UNDO.
  DEFINE VARIABLE sav_fgc        AS INTEGER           NO-UNDO.
   
  ASSIGN sav_bgc = _L._BGCOLOR
         sav_fgc = _L._FGCOLOR.
  
  IF NOT CAN-DO("WINDOW,FRAME,DIALOG-BOX",_U._TYPE) THEN
    /* Get the current Windows background and foreground colors. (dma) 
       Backed out for 20000106-021.
    RUN adecomm/_wincolr.p (parent_L._BGCOLOR,
                            parent_L._FGCOLOR,
                            OUTPUT parent_bgcolor, 
                            OUTPUT parent_fgcolor). */ 
    ASSIGN parent_bgcolor = parent_L._BGCOLOR
           parent_fgcolor = parent_L._FGCOLOR.
  
  /* Note that since _L can be undone, it will be if the user clicks CANCEL. */
  /* If the window-system is in {&no_color} then comment that                */
  /*     "Button Color not supported under MS-WINDOWS."                      */
  RUN adecomm/_chscolr.p
       (INPUT "Choose Color",
        INPUT (IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" AND
               CAN-DO("BUTTON,IMAGE",_U._TYPE)
               THEN (TRIM(STRING(LC(_U._TYPE),"!x(20)")) +
                     " color not supported under " +
                     SESSION:WINDOW-SYSTEM + ".")
               ELSE ""),
        INPUT (IF _U._TYPE = "BROWSE" AND _L._SEPARATORS THEN TRUE ELSE FALSE),
        INPUT parent_bgcolor,
        INPUT parent_fgcolor,
        INPUT ?,
        INPUT-OUTPUT _L._BGCOLOR,
        INPUT-OUTPUT _L._FGCOLOR,
        INPUT-OUTPUT _L._SEPARATOR-FGCOLOR,
        OUTPUT l_ok).
        
  IF _L._LO-NAME = "Master Layout" THEN DO:
    FOR EACH sync_L WHERE sync_L._u-recid = _L._u-recid AND
                          sync_L._LO-NAME NE _L._LO-NAME:
      IF sync_L._BGCOLOR = sav_bgc THEN sync_L._BGCOLOR = _L._BGCOLOR.
      IF sync_L._FGCOLOR = sav_fgc THEN sync_L._FGCOLOR = _L._FGCOLOR.
    END.
  END.  /* If this was the master layout */
  APPLY "ENTRY" TO btn_OK IN FRAME prop_sht.
END.  /* ON CHOOSE OF btn_color */

ON GO OF FRAME prop_sht DO:
  /* Validate some things before breaking the wait-for */
  l_error_on_go = FALSE.

  IF (_L._COL NE ? AND _L._ROW EQ ?) OR
     (_L._COL EQ ? AND _L._ROW NE ?) THEN DO:
     MESSAGE "Row and column specifications must both be unknown or they" SKIP
             "must both be valid values." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   l_error_on_go = TRUE.
  END.  /*  _COL & _ROW ckeck */

  IF CAN-DO("SELECTION-LIST,COMBO-BOX",_U._TYPE) THEN RUN process-sellist-and-combo.


  ELSE IF _U._TYPE = "FILL-IN":U THEN DO:
    /* for fill-ins, check the format string, and then set the initial value. */
    /* NOTE: This code is mirrored in the COMBO-BOX section above */
    IF _F._DATA-TYPE = "LOGICAL":U THEN DO:
      IF NUM-ENTRIES (_F._FORMAT, "/") NE 2 THEN DO:
        MESSAGE "'" _F._FORMAT "' is an invalid logical format." SKIP
                " Use a format of the form 'yes/no' or 'true/false'."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        l_error_on_go = TRUE.
      END.  /* If we don't have a slash */
      ELSE _F._INITIAL-DATA = ENTRY (sav-ldef, _F._FORMAT,"/":U).
    END.  /* IF _F._DATA-TYPE = "LOGICAL" */
  END. /* If a FILL-IN */
  
  ELSE IF _U._TYPE = "RADIO-SET" THEN DO:
    DEF VARIABLE rval AS CHAR NO-UNDO.
    DEF VAR cListItems AS CHAR NO-UNDO.

    /* Validation assumes a comma delimiter. */
    IF _F._DELIMITER NE "," AND _F._DELIMITER NE "" AND _F._DELIMITER NE ? THEN
      ASSIGN cListItems    = _F._LIST-ITEMS.
            _F._LIST-ITEMS = REPLACE(_F._LIST-ITEMS,_F._DELIMITER,",").
    
    l_error_on_go = NOT (validate-radio-buttons(_U._HANDLE)).
    
    IF cListItems > "" THEN
      ASSIGN _F._LIST-ITEMS = cListItems.

    IF l_Error_on_go THEN 
       new_btns = FALSE. 
    ELSE DO:
      IF _F._LIST-ITEMS NE sav-rb THEN
        new_btns = TRUE.
      ELSE
        new_btns = FALSE.
      
      IF new_btns THEN DO:
        ASSIGN h_self:HIDDEN      = TRUE.
        IF _L._WIN-TYPE OR SESSION:WINDOW-SYSTEM BEGINS "MS-WIN"
        THEN DO: /* GUI , but MSW only. */
          /* Just redo the radio-buttons */
          RUN adeuib/_rbtns.p (_F._LIST-ITEMS, _F._DATA-TYPE, _F._DELIMITER, OUTPUT rval).
          ASSIGN h_self:AUTO-RESIZE   = no
                 h_self:RADIO-BUTTONS = rval.
        END.  /* If GUI */
        ELSE DO: /* TTY. */
          RUN adeuib/_ttyradi.p (h_self, _F._HORIZONTAL,_F._LIST-ITEMS).
        END. /* TTY */
       /* WTW - We should not have to do this, but it allows us to get
           around a 7.1C bug where AUTO-RESIZE is not working */
       {adeuib/onframe.i
         &_whFrameHandle = "_F._FRAME"
         &_whObjHandle   = "h_self"
         &_lvHidden      = _L._REMOVE-FROM-LAYOUT}

        ASSIGN h_self:VISIBLE = TRUE NO-ERROR.
        IF NOT h_self:VISIBLE
        THEN RUN adeuib/_onframe.p (h_self:FRAME,
                                    h_self,
                                    _L._REMOVE-FROM-LAYOUT).

        ASSIGN _L._HEIGHT = _L._HEIGHT / _L._ROW-MULT
               _L._WIDTH  = _L._WIDTH / _L._COL-MULT.
      END.  /* IF buttons have changed */
      IF _F._INITIAL-DATA NE "":U AND _F._INITIAL-DATA NE ? THEN DO:
        ASSIGN _F._INITIAL-DATA    = TRIM(_F._INITIAL-DATA).
        IF _F._DATA-TYPE = "CHARACTER":U THEN 
                h_self:SCREEN-VALUE = "~"":U + _F._INITIAL-DATA + "~"":U.
      END.  /* If non-trivial initial value */
    END.  /* If haven't found an error yet */
  END.  /* If _U._TYPE = "Radio-set" */

  ELSE IF _U._TYPE = "SLIDER":U THEN DO:
    IF sav-l-s  NE _F._LARGE-TO-SMALL   THEN h_self:LARGE-TO-SMALL   = _F._LARGE-TO-SMALL.
    IF sav-freq NE _F._FREQUENCY        THEN h_self:FREQUENCY        = _F._FREQUENCY.
  END.
  
  ELSE IF _U._TYPE = "BUTTON":U AND _L._NO-FOCUS THEN _U._TAB-ORDER = 0.
  
  IF l_error_on_go THEN RETURN NO-APPLY.
END.  /* ON GO of the FRAME */

IF SESSION:WIDTH-PIXELS = 640 AND SESSION:PIXELS-PER-COLUMN = 8 THEN
ASSIGN FRAME prop_sht:X = 0 - CURRENT-WINDOW:X 
       FRAME prop_sht:Y = 0 - CURRENT-WINDOW:Y.

RUN sensitize.

RUN adecomm/_setcurs.p ("").


WAIT-FOR "GO" OF FRAME prop_sht.
/* Turn status messages back on. (They were turned off at the top of the block */
STATUS INPUT.

RUN complete_the_transaction.

/* Update the custom Super procedure for Dynamics */
IF VALID-HANDLE(h_custom-super-proc) AND h_custom-super-proc:MODIFIED THEN
DO:
   FIND B_U WHERE RECID(B_U) = _P._u-recid.
   FIND B_C WHERE RECID(B_C) = B_U._x-recid.
   FIND X_U WHERE X_U._parent-recid = RECID(_U) AND 
       X_U._TYPE = "BROWSE":U NO-ERROR.
   IF AVAILABLE X_U THEN
     FIND X_C WHERE RECID(X_C) = X_U._x-recid NO-ERROR.
   cCustom_super_proc = SEARCH(h_custom-super-proc:SCREEN-VALUE) NO-ERROR.
   IF cCustom_super_proc > "" THEN
   DO:
      ASSIGN B_C._CUSTOM-SUPER-PROC = h_custom-super-proc:SCREEN-VALUE
              _C._CUSTOM-SUPER-PROC = h_custom-super-proc:SCREEN-VALUE.
      IF AVAILABLE X_C THEN X_C._CUSTOM-SUPER-PROC = h_custom-super-proc:SCREEN-VALUE.
   END.
   ELSE DO:
      ASSIGN B_C._CUSTOM-SUPER-PROC = ?
             _C._CUSTOM-SUPER-PROC = ?.
      IF AVAILABLE X_C THEN X_C._CUSTOM-SUPER-PROC = ?.
   END.
END.

IF h_format NE ? THEN DO: /* Redisplay incase format, initial-data or data-type chg */
  IF _F._DATA-TYPE = "DATE":U AND
    (_F._INITIAL-DATA = ? OR _F._INITIAL-DATA = "") THEN LEAVE BIG-TRANS-BLK.

  IF NOT _L._WIN-TYPE AND NOT CAN-DO("CHARACTER,DATE",_F._DATA-TYPE) THEN
    RUN adeuib/_sim_lbl.p (INPUT h_self).
    
  ELSE IF _U._TYPE NE "COMBO-BOX":U THEN DO:
    
    IF CAN-DO("DECIMAL,INTEGER":U,_F._DATA-TYPE) AND 
       h_format:SCREEN-VALUE NE "?" AND 
       h_format:SCREEN-VALUE NE "" AND notAmerican THEN
    DO:
      RUN adecomm/_convert.p ("N-TO-A", h_format:SCREEN-VALUE, 
                              _numeric_separator, _numeric_decimal, 
                              OUTPUT conv_fmt).
      IF h_self:FORMAT NE conv_fmt AND 
            h_self:SCREEN-VALUE NE "?" AND h_self:SCREEN-VALUE NE ? 
        THEN h_self:FORMAT = conv_fmt.
    END.                
    ELSE IF h_format:SCREEN-VALUE NE "?" AND h_format:SCREEN-VALUE NE "" AND
            h_self:SCREEN-VALUE NE "?" AND h_self:SCREEN-VALUE NE ? AND
            NOT (_F._DATA-TYPE EQ "CHARACTER" AND h_format:SCREEN-VALUE BEGINS "9" AND
                 NOT _L._WIN-TYPE) THEN
      ASSIGN h_self:FORMAT = h_format:SCREEN-VALUE.

    IF sav-dt eq _F._DATA-TYPE THEN /* Not if data-type has changed */
      ASSIGN h_self:SCREEN-VALUE = IF _F._INITIAL-DATA = "?" THEN ? ELSE
                                   _F._INITIAL-DATA.
  END.
  IF NOT _L._WIN-TYPE AND _U._SUBTYPE NE "TEXT":U THEN
    h_self:SCREEN-VALUE = REPLACE(TRIM(h_self:SCREEN-VALUE)," ", "_") +
                          FILL("_",INTEGER(_L._WIDTH) -
                                   LENGTH(TRIM(h_self:SCREEN-VALUE),"CHARACTER":U)). 
END.
IF AVAILABLE _P THEN
  ret-msg = DYNAMIC-FUNCTION("shutdown-proc" IN _h_func_lib, _P._data-object).        
END.  /* BIG-TRANS-BLK */

HIDE FRAME prop_sht.
DELETE WIDGET-POOL.


/* See what needs to be recreated */
recreate-self = FALSE.

/* First see if entire window should be recreated                                 */
IF CAN-DO("WINDOW",_U._TYPE) THEN DO:  
  IF sav-3d NE ?   AND sav-3d  NE _L._3-D                THEN recreate-self = TRUE.
  IF sav-msg NE ?  AND sav-msg NE _C._MESSAGE-AREA       THEN recreate-self = TRUE.  
  IF sav-stsa NE ? AND sav-stsa NE _C._STATUS-AREA       THEN recreate-self = TRUE.
  IF sav_v-height NE _L._VIRTUAL-HEIGHT OR sav_v-width NE _L._VIRTUAL-WIDTH OR
     sav_height   NE _L._HEIGHT         OR sav_width   NE _L._WIDTH THEN
   recreate-self = TRUE. 
END.

/* Under MOTIF Redraw a button if it is no-longer the default button or has 
   become the default button                                                      */ 
&IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  IF _L._WIN-TYPE AND sav-dflt ne ? AND (sav-dflt ne _F._DEFAULT) THEN
    recreate-self = TRUE.
&ENDIF

/* Redraw a widget that has a new data-type, the format will probably have changed */ 
IF sav-dt NE ? AND sav-dt NE _F._DATA-TYPE THEN recreate-self = TRUE.

/* Redraw a widget if its scrollbars have changed                                  */
IF sav-sh NE ? AND 
  (sav-sh NE _F._SCROLLBAR-H OR sav-sv NE _U._SCROLLBAR-V) THEN recreate-self = TRUE.

IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN DO:
  /* Redraw a frame if BOX, NO-LABELS, 3D, TITLE or TITLE-BAR has changed          */
  IF (sav-box NE ? OR _U._TYPE = "DIALOG-BOX") AND
    (sav-box NE _L._NO-BOX OR sav-ttl NE _C._TITLE OR sav-3d NE _L._3-D OR
     sav-lbl NE _L._NO-LABELS) THEN recreate-self = TRUE.
  IF sav_v-height NE _L._VIRTUAL-HEIGHT OR sav_v-width NE _L._VIRTUAL-WIDTH OR
     sav_height   NE _L._HEIGHT         OR sav_width   NE _L._WIDTH THEN
   recreate-self = TRUE. 
END.

/* Redraw a widget whose label string attrs has changed                            */
IF sav-lbla NE _U._LABEL-ATTR THEN recreate-self = TRUE.

/* Redraw frame or window if it scrollable has changed                             */
IF sav-scr NE ? THEN DO:
  IF _U._TYPE = "WINDOW"  AND sav-scr NE _C._SCROLL-BARS THEN recreate-self = TRUE.
  IF _U._TYPE NE "WINDOW" AND sav-scr NE _C._SCROLLABLE  THEN recreate-self = TRUE.
END.

/* Redraw a fill-in or combo-box if NO-LABEL has changed                           */
IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND sav-lbl NE _L._NO-LABELS THEN 
  recreate-self = TRUE.

/* Redraw a combo-box if lists have changed                                          */
IF _U._TYPE = "COMBO-BOX":U THEN DO:
  IF sav-rb NE _F._LIST-ITEMS OR sav-lp NE _F._LIST-ITEM-PAIRS 
    THEN recreate-self = TRUE.
  IF sav-sub NE _U._SUBTYPE THEN recreate-self = TRUE.
  IF sav-hgt NE _L._HEIGHT THEN recreate-self = TRUE.
END.  /* if combo-box */

/* Refraw if LIST-ITEMS and LIST-ITEM-PAIRS were switched */
IF switchlist THEN recreate-self = TRUE.

/* Redraw a fill-in if view-as -text has changed                                   */
IF _U._TYPE = "FILL-IN" AND sav-vat NE _U._SUBTYPE THEN recreate-self = TRUE.

/* Redraw slider or radio-set if orientation has changed                           */
IF (sav-hor NE ? AND sav-hor NE _F._HORIZONTAL) OR
   (sav-exp NE ? AND sav-exp NE _F._EXPAND) THEN recreate-self = TRUE.

/* Redraw radio-set if buttons have changed */
IF _U._TYPE = "RADIO-SET":U AND new_btns THEN recreate-self = TRUE.

/* Redraw a button or image if sav-iu has changed */
IF CAN-DO("BUTTON,IMAGE",_U._TYPE) THEN DO:
  IF _L._WIN-TYPE  AND sav-iu NE _F._IMAGE-FILE THEN recreate-self = TRUE.
  IF _U._TYPE = "BUTTON" THEN DO:
    IF _F._IMAGE-FILE = "" AND (_F._IMAGE-DOWN-FILE NE "" OR 
                                _F._IMAGE-INSENSITIVE-FILE NE "") THEN
        MESSAGE "Buttons will not show DOWN or INSENSITIVE images unless"
                "an UP image is defined." VIEW-AS ALERT-BOX WARNING.        
  END.
END.

/* Redraw field if initial-data has changed */
IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER,TOGGLE-BOX",
  _U._TYPE) AND sav-init NE _F._INITIAL-DATA THEN recreate-self = TRUE.
  
/* Force Comb-box to have no value if no items are defined */
IF _U._TYPE = "COMBO-BOX" AND TRIM(_F._LIST-ITEMS) = "" THEN recreate-self = TRUE.

/* Redraw slider if max or min value has changed                                   */
IF sav-max NE ? AND (sav-max  NE _F._MAX-VALUE OR 
                     sav-min  NE _F._MIN-VALUE )   THEN DO:
  IF _F._MIN-VALUE >= _F._MAX-VALUE THEN DO:
    MESSAGE "You have specified an invalid set of minimum/maximum values." SKIP
            "Default values have been set." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ASSIGN _F._MIN-VALUE            = 0
           _F._MAX-VALUE            = 100.
  END.
  recreate-self = TRUE.
END.

IF _U._TYPE = "SLIDER":U AND 
  (sav-tic NE _F._TIC-MARKS OR sav-ncv NE _F._NO-CURRENT-VALUE) THEN
  recreate-self = TRUE.

/* Always redraw a BROWSE */
IF _U._TYPE = "BROWSE":U THEN 
  recreate-self = TRUE.

/* If the NO-BOX has changed on an Editor, redraw it */
IF _U._TYPE = "EDITOR":U AND sav-box NE _L._NO-BOX THEN 
  recreate-self = TRUE.

/* If the TEXT widget text has changed, redraw it */
IF _U._TYPE = "TEXT":U THEN DO: /* dma */
  IF h_self:SCREEN-VALUE <> _F._INITIAL-DATA THEN
    recreate-self = TRUE.
  h_self:SCREEN-VALUE = _F._INITIAL-DATA.
END.

IF recreate-self THEN DO:
  RUN adeuib/_recreat.p (RECID(_U)).
  h_self = _U._HANDLE. /* New instance has a new handle */
END.

IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN DO:
  /* Change label visualization of a frame if SIDE-LABELS has changed                */
  IF _U._TYPE = "FRAME" AND sav-slab NE _C._SIDE-LABELS THEN DO:
    ASSIGN fg_h    = h_self:FIRST-CHILD  /* This is the field group                  */
           tmp_hdl = fg_h:FIRST-CHILD.   /* First field level widget                 */
         
    IF NOT sav-slab THEN DO:   /* We are going from column labels to side-labels     */
      /* 1) Find out how much to move things up and hide fill-in & combo-box labels  */
      /* 2) Remove bar                                                               */
      /* 3) Move widget and show side-labels                                         */
      ASSIGN y-move                = IF _C._FRAME-BAR:VISIBLE THEN _C._FRAME-BAR:Y + 2
                                                              ELSE 0
             _C._FRAME-BAR:VISIBLE = FALSE.
           
      DO WHILE tmp_hdl <> ?:
        IF tmp_hdl NE _C._FRAME-BAR THEN DO:     /* Move widgets and show the labels */
          FIND x_U WHERE x_U._HANDLE = tmp_hdl.
          FOR EACH x_L WHERE x_L._u-recid = RECID(x_U):
            ASSIGN tmp_hdl:Y  = MAX(tmp_hdl:Y - y-move, 0)
                   x_L._ROW   = ((tmp_hdl:ROW - 1) / x_L._ROW-MULT) + 1
                   x_L._COL   = ((tmp_hdl:COL - 1) / x_L._COL-MULT) + 1
                   /* Set alignment to "L"eft */
                   x_U._ALIGN = "L".
          END.  /* FOR EACH LAYOUT */
          IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER",tmp_hdl:TYPE) THEN
            RUN adeuib/_showlbl.p (tmp_hdl).
        END. /* If not a label or the frame bar */
        tmp_hdl = tmp_hdl:NEXT-SIBLING.
      END. /* DO while we have a good tmp_handle */
    END.  /* Going from column labels to side-labels */
  
    ELSE DO:  /* We are going from side-labels to column-labels                      */
      /* Make the frame bar the correct size */
      ASSIGN _C._FRAME-BAR:WIDTH = h_self:VIRTUAL-WIDTH - 
                                   (h_self:BORDER-LEFT + h_self:BORDER-RIGHT)
             _C._FRAME-BAR:Y     = 1
             _C._ITERATION-POS   = 0.
      IF NOT _L._NO-LABELS THEN DO:  /* There are labels */
        /* Make the labels column labels */
        FOR EACH x_L WHERE x_L._u-recid = RECID(_U):
          x_L._NO-UNDERLINE = FALSE.
        END.
        RUN adeuib/_adjclbl.p (INPUT h_self, INPUT TRUE).  /* Abort if error */
        IF RETURN-VALUE = "WONT-FIT" THEN DO:
          ASSIGN _C._FRAME-BAR:VISIBLE = FALSE
                 _C._SIDE-LABELS       = TRUE.
          MESSAGE "There isn't enough room in frame" _U._NAME SKIP
                  "for the header and body with COLUMN LABELS." SKIP (1)
                  "Reverting to SIDE-LABELS."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END.  /* If won't fit */
      END.  /* If there are labels */
    END.  /* ELSE Going from side-labels to column labels */
  END.  /* Have changed the label type */
END.  /* IF a frame or dialog */

/* Update the popup menu if necessary */
IF update_menu THEN DO:
  RUN adeuib/_updmenu.p (delete_menu, popup_recid, OUTPUT h_menu).
  _U._popup-recid = IF delete_menu THEN ? ELSE popup_recid.
  IF h_self:TYPE NE "TEXT" THEN
    IF h_menu <> h_self:POPUP-MENU THEN h_self:POPUP-MENU = h_menu.
END.
  
/* Update the Menu-bar if necessary */
IF update_menu-bar THEN DO:
  RUN adeuib/_updmenu.p (delete_menu-bar, menu-bar_recid, OUTPUT h_menu-bar).
  _C._menu-recid = IF delete_menu-bar THEN ? ELSE menu-bar_recid.
  IF h_menu-bar NE h_self:MENUBAR THEN h_self:MENUBAR = h_menu-bar.
END. 

/* ***************** PERSISTENT TRIGGERS FOR DYNAMIC WIDGETS  **************** */

PROCEDURE alignment_change:
  RUN compute_lbl_wdth.
  _U._ALIGN = SELF:SCREEN-VALUE.
        
   CASE _U._ALIGN:
     WHEN "R"  THEN xpos = _L._COL - 1 + _L._WIDTH.
     WHEN "C"  THEN xpos = _L._COL - 2.
     OTHERWISE
       xpos = IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND parent_C._SIDE-LABELS THEN
                   /* SIDE-LABELS */  (_L._COL - lbl_wdth)
              ELSE IF parent_U._TYPE = "FRAME" AND NOT parent_C._SIDE-LABELS AND
                   NOT parent_L._NO-LABELS THEN
                   /* COLUMN LABELS */ (_L._COL - MAX(0, lbl_wdth - _L._WIDTH))
              ELSE _L._COL.
    END.  /* Case */
    ASSIGN  h_col:SCREEN-VALUE = STRING(xpos).
END PROCEDURE.

PROCEDURE row_change.
  low-limit = IF CAN-DO ("WINDOW,DIALOG-BOX", _U._TYPE) THEN 1 - DECIMAL(h_hgt:SCREEN-VALUE)
                                         ELSE 1.
  IF DECIMAL(SELF:SCREEN-VALUE) < low-limit THEN DO:
    MESSAGE "Row must be greater than or equal to" STRING(low-limit) + "."
            VIEW-AS ALERT-BOX INFORMATION.
    SELF:SCREEN-VALUE = STRING(low-limit).
    RETURN ERROR.
  END.
  upr-limit = IF CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) THEN
                SESSION:HEIGHT-CHARS
              ELSE IF _U._TYPE = "FRAME" THEN
                1 + v-hgt - DECIMAL(h_hgt:SCREEN-VALUE)
              ELSE (1 + (v-hgt - parent_U._HANDLE:BORDER-TOP -
                      parent_U._HANDLE:BORDER-BOTTOM -  DECIMAL(h_hgt:SCREEN-VALUE)) /
                      IF parent_C._SIDE-LABEL THEN 1 ELSE 2).
  IF DECIMAL(SELF:SCREEN-VALUE) > upr-limit THEN DO:
    MESSAGE "Row must be less than or equal to" STRING(upr-limit) + "."
            VIEW-AS ALERT-BOX INFORMATION.
    SELF:SCREEN-VALUE = STRING(upr-limit).
    RETURN ERROR.
  END.                                                      
  
  /* Windows and dialog boxes cannot have positions in the range (-1,1) not inclusive
   * since PPUs are 1-based.  Negative values are legitimate */
  IF CAN-DO("WINDOW,DIALOG-BOX", _U._TYPE) AND 
     DECIMAL(SELF:SCREEN-VALUE) > -1 AND 
     DECIMAL(SELF:SCREEN-VALUE) < 1 THEN DO:
       MESSAGE "A" _U._TYPE "may not have an explicit position in the range -1 to 1."
               VIEW-AS ALERT-BOX INFORMATION.
       SELF:SCREEN-VALUE = (IF DECIMAL(SELF:SCREEN-VALUE) < 0 THEN STRING("-1") ELSE STRING ("1")).
       RETURN ERROR.
  END.
            
  ASSIGN _L._ROW = DECIMAL(SELF:SCREEN-VALUE) + col-lbl-adj.
END.

PROCEDURE column_change.
  RUN compute_lbl_wdth.
  ASSIGN xpos = DECIMAL(SELF:SCREEN-VALUE).
 
  IF NOT CAN-DO("WINDOW,DIALOG-BOX,FRAME",_U._TYPE) THEN DO:
    CASE _U._ALIGN:
      WHEN "R" THEN
         ASSIGN low-limit = DECIMAL(h_wdth:SCREEN-VALUE) + lbl_wdth
                upr-limit = v-wdth - parent_U._HANDLE:BORDER-LEFT -
                                     parent_U._HANDLE:BORDER-RIGHT.
      WHEN "C" THEN
         ASSIGN low-limit = lbl_wdth - 1
                upr-limit = v-wdth - parent_U._HANDLE:BORDER-LEFT -
                                     parent_U._HANDLE:BORDER-RIGHT - 
                                     DECIMAL(h_wdth:SCREEN-VALUE) - 1.
      OTHERWISE
         ASSIGN low-limit = 1
                upr-limit = v-wdth - parent_U._HANDLE:BORDER-LEFT -
                                     parent_U._HANDLE:BORDER-RIGHT - 
                                     DECIMAL(h_wdth:SCREEN-VALUE) - lbl_wdth + 1.
    END CASE.
  END.  /* If not a window or dialog or frame */
  ELSE IF _U._TYPE EQ "FRAME" THEN
    ASSIGN low-limit = 1
           upr-limit = 1 + v-wdth - DECIMAL(h_wdth:SCREEN-VALUE). 
  ELSE 
    ASSIGN low-limit = 1 - DECIMAL(h_wdth:SCREEN-VALUE) 
           upr-limit = SESSION:WIDTH-CHARS.
           
  IF xpos < low-limit THEN DO:
    MESSAGE "Column must be greater than or equal to" STRING(low-limit) + "."
             VIEW-AS ALERT-BOX INFORMATION.
    SELF:SCREEN-VALUE = STRING(low-limit).
    RETURN ERROR.
  END.
  IF xpos > upr-limit THEN DO:
    MESSAGE "Column must be less than or equal to" STRING(upr-limit) + "."
            VIEW-AS ALERT-BOX INFORMATION.
    SELF:SCREEN-VALUE = STRING(upr-limit).
    RETURN ERROR.                                    
  END.

  /* Windows and dialog boxes cannot have positions in the range (-1,1) not inclusive
   * since PPUs are 1-based.  Negative values are legitimate */
  IF CAN-DO("WINDOW,DIALOG-BOX", _U._TYPE) AND 
     DECIMAL(SELF:SCREEN-VALUE) > -1 AND 
     DECIMAL(SELF:SCREEN-VALUE) < 1 THEN DO:
       MESSAGE "A" _U._TYPE "may not have an explicit position in the range -1 to 1."
               VIEW-AS ALERT-BOX INFORMATION.
       SELF:SCREEN-VALUE = (IF DECIMAL(SELF:SCREEN-VALUE) < 0 THEN STRING("-1") ELSE STRING ("1")).
       RETURN ERROR.
  END.
            
  CASE _U._ALIGN:
    WHEN "R" THEN  _L._COL = xpos + 1 - DECIMAL(h_wdth:SCREEN-VALUE).
    WHEN "C" THEN  _L._COL = xpos + 2.
    OTHERWISE      _L._COL = IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND
                                parent_C._SIDE-LABELS THEN
                             /* SIDE-LABELS */  (xpos + lbl_wdth)
                             ELSE IF parent_U._TYPE = "FRAME" AND
                                     NOT parent_C._SIDE-LABELS AND
                                     NOT parent_L._NO-LABELS THEN
                             /* COLUMN LABELS */ (xpos + MAX(0, lbl_wdth - _L._WIDTH))
                             ELSE xpos.
  END.  /* Case */   
END PROCEDURE.

PROCEDURE combo_subtype_change:
  CASE SELF:SCREEN-VALUE:
    WHEN "SI" THEN DO:
      ASSIGN _U._SUBTYPE                 = "SIMPLE"                   
             h_hgt:SENSITIVE             = TRUE
             h_AUTO-COMPLETION:SENSITIVE = TRUE
             h_max-chars:SENSITIVE       = TRUE
             h_data-type:SENSITIVE       = FALSE
             h_data-type:SCREEN-VALUE    = "CHARACTER".
      APPLY "VALUE-CHANGED":U TO h_data-type.
      ASSIGN h_format:SENSITIVE          = FALSE
             h_format:SCREEN-VALUE       = _F._FORMAT
             h_btn_fmt:SENSITIVE         = FALSE.
      APPLY "LEAVE":U TO h_format.
    END.  /* when simple */
    WHEN "DD" THEN DO:
      ASSIGN _U._SUBTYPE                 = "DROP-DOWN"
             h_hgt:SENSITIVE             = FALSE
             h_hgt:SCREEN-VALUE          = STRING(_L._ROW-MULT)
             h_AUTO-COMPLETION:SENSITIVE = TRUE
             h_max-chars:SENSITIVE       = TRUE
             h_data-type:SENSITIVE       = FALSE
             h_data-type:SCREEN-VALUE    = "CHARACTER".
      APPLY "VALUE-CHANGED":U TO h_data-type.
      ASSIGN h_format:SENSITIVE          = FALSE
             h_format:SCREEN-VALUE       = _F._FORMAT
             h_btn_fmt:SENSITIVE         = FALSE.
      APPLY "LEAVE":U TO h_format.
    END.  /* when drop-down */
    WHEN "DL" THEN DO: 
      ASSIGN _U._SUBTYPE                 = "DROP-DOWN-LIST"
             h_hgt:SENSITIVE             = FALSE
             h_hgt:SCREEN-VALUE          = STRING(_L._ROW-MULT)
             h_AUTO-COMPLETION:SENSITIVE = FALSE
             h_AUTO-COMPLETION:CHECKED   = FALSE
             h_UNIQUE-MATCH:SENSITIVE    = FALSE
             h_UNIQUE-MATCH:CHECKED      = FALSE
             h_max-chars:SENSITIVE       = FALSE
             h_max-chars:SCREEN-VALUE    = STRING(0)
             h_data-type:SENSITIVE       = IF _U._TABLE NE ? THEN FALSE ELSE TRUE
             h_format:SENSITIVE          = IF _F._FORMAT-SOURCE = "D" THEN FALSE ELSE TRUE
             h_btn_fmt:SENSITIVE         = IF _F._FORMAT-SOURCE = "D" THEN FALSE ELSE TRUE.
      APPLY "VALUE-CHANGED":U to h_AUTO-COMPLETION.
      APPLY "VALUE-CHANGED":U TO h_UNIQUE-MATCH.
      APPLY "VALUE-CHANGED":U to h_max-chars.
      APPLY "VALUE-CHANGED":U to h_data-type.
    END.  /* when drop down list */           
  END CASE.

END PROCEDURE.  /* combo_subtype_change */

PROCEDURE complete_the_transaction:
  DO WITH FRAME prop_sht:
    IF h_format NE ? AND CAN-DO("INTEGER,DECIMAL":U,_F._DATA-TYPE) THEN DO:
      /* Assuming that Progress was invoked in non-American numeric format, make sure that 
         the value is stored in the American format */
      IF _F._FORMAT-SOURCE = "E" THEN DO:
        IF notAmerican THEN DO:
          RUN adecomm/_convert.p ("N-TO-A", h_format:SCREEN-VALUE, 
                                  _numeric_separator, _numeric_decimal, 
                                  OUTPUT conv_fmt).
          _F._FORMAT = conv_fmt.
        END.  /* if not American numeric format */
        ELSE _F._FORMAT = h_format:SCREEN-VALUE.
      END.  /* if format-source "E" */
    END.
      
    RUN adeuib/_winsave.p (_U._WINDOW-HANDLE, FALSE).
    
    /* If a dialog-box and the dimensions have changed, need to adjust both the */
    /* window and the frame                                                     */
    IF _U._TYPE = "DIALOG-BOX" AND
      (h_self:WIDTH NE (_L._WIDTH * _L._COL-MULT) OR
       h_self:HEIGHT NE (_L._HEIGHT * _L._ROW-MULT)) THEN DO:
       
      /* DIALOG BOX WIDTH adjustment                                            */
      IF h_self:WIDTH < (_L._WIDTH * _L._COL-MULT) THEN
        ASSIGN _U._PARENT:WIDTH  = (_L._WIDTH * _L._COL-MULT)
               h_self:WIDTH      = _U._PARENT:WIDTH.
      ELSE IF h_self:WIDTH > (_L._WIDTH * _L._COL-MULT) THEN
        ASSIGN h_self:WIDTH     = (_L._WIDTH * _L._COL-MULT)
               _U._PARENT:WIDTH = h_self:WIDTH.
        
      /* DIALOG BOX HEIGHT adjustment                                           */
      IF h_self:HEIGHT < (_L._HEIGHT * _L._ROW-MULT) THEN
        ASSIGN _U._PARENT:HEIGHT  = (_L._HEIGHT * _L._ROW-MULT) 
               h_self:HEIGHT      = _U._PARENT:HEIGHT.
      ELSE IF h_self:HEIGHT > (_L._HEIGHT * _L._ROW-MULT) THEN
        ASSIGN h_self:HEIGHT     = (_L._HEIGHT * _L._ROW-MULT) 
               _U._PARENT:HEIGHT = h_self:HEIGHT.
    END.
    /* In a SIZE-TO-PARENT frame, resize the parent window. */
    ELSE IF _U._TYPE eq "FRAME":U AND _U._size-to-parent THEN DO:
      IF _L._WIDTH ne parent_L._WIDTH THEN ASSIGN
        parent_U._HANDLE:WIDTH  = _L._WIDTH * parent_L._COL-MULT
        parent_L._WIDTH         = parent_U._HANDLE:WIDTH / parent_L._COL-MULT NO-ERROR.
      IF _L._HEIGHT ne parent_L._HEIGHT THEN ASSIGN
        parent_U._HANDLE:HEIGHT  = _L._HEIGHT * parent_L._ROW-MULT
        parent_L._HEIGHT         = parent_U._HANDLE:HEIGHT / parent_L._ROW-MULT NO-ERROR.
    END.
    
    ASSIGN h_self:FGCOLOR = IF _L._WIN-TYPE THEN _L._FGCOLOR ELSE _tty_fgcolor
                         /* The BGColor is forced for fill-ins to be white (15) (unless viewed as text) 
                            if its color is default since fill-ins are now read-only and displayed using 
                            default background color */
           h_self:BGCOLOR = IF _L._WIN-TYPE 
                            THEN (IF _U._TYPE = "FILL-IN":U AND _U._SUBTYPE <> "TEXT":U AND _L._BGCOLOR = ?
                                  THEN 15 
                                  ELSE _L._BGCOLOR )
                            ELSE _tty_bgcolor.
              
    
    /* Update dimension and position.  Must be careful in the case that        */
    /*   both were changed.  The order of Row & Height changes is important!   */
    /* Adjust the Width & Col combination: If new column is less than          */
    /*   old then set col first, otherwise set width first                     */
    /*   new-rc-value is the new row or col value in the _L rec                */
    DEFINE VARIABLE new-rc-value AS DECIMAL DECIMALS 2.
    new-rc-value = IF _U._TYPE = "WINDOW" THEN       /* Don't scale row/col for*/
                   _L._COL ELSE                      /*    windows, dlgs taken */
                   (_L._COL - 1) * _L._COL-MULT + 1. /*    care of elsewhere.  */
                    
    IF h_self:COLUMN  > new-rc-value THEN DO:
      IF _L._COL NE ? AND _U._TYPE NE "DIALOG-BOX" THEN 
        h_self:COLUMN = new-rc-value.
      h_self:WIDTH = _L._WIDTH * _L._COL-MULT NO-ERROR.
    END.
    ELSE DO: /* Width then column */
      h_self:WIDTH = _L._WIDTH * _L._COL-MULT NO-ERROR.
      IF _L._COL NE ? AND _U._TYPE NE "DIALOG-BOX" THEN 
        h_self:COLUMN = new-rc-value.
    END.
    
    /* Adjust the Height & Row combination:  If new row is less than old      */
    /*   then set row first, otherwise set height first                       */
    new-rc-value = IF _U._TYPE = "WINDOW" THEN
                   _L._ROW ELSE
                   (_L._ROW - 1) * _L._ROW-MULT + 1.
    IF h_self:ROW > new-rc-value THEN DO:
      IF _L._ROW NE ? AND _U._TYPE NE "DIALOG-BOX" THEN
        h_self:ROW = new-rc-value.
      IF _U._TYPE NE "COMBO-BOX" THEN 
        h_self:HEIGHT = _L._HEIGHT * _L._ROW-MULT.
    END.
    ELSE DO: /* Height then row */
      IF _U._TYPE NE "COMBO-BOX" THEN 
        h_self:HEIGHT = _L._HEIGHT * _L._ROW-MULT.
      IF _L._ROW NE ? AND _U._TYPE NE "DIALOG-BOX" THEN
        h_self:ROW = new-rc-value.
    END.  

    /* Don't save the name for text widgets.  For db fields, don't save
     * the name because we added the (database.table) reference to it. */     
    IF _U._TYPE NE "TEXT" AND _U._DBNAME EQ ? THEN 
      _U._NAME =  name:SCREEN-VALUE IN FRAME prop_sht.
    
    IF _U._TYPE NE "COMBO-BOX" THEN
      h_self:HEIGHT = _L._HEIGHT * _L._ROW-MULT.

    IF h_REMOVE-FROM-LAYOUT NE ? THEN DO:
      IF h_REMOVE-FROM-LAYOUT:CHECKED THEN h_self:HIDDEN = TRUE. 
    END.

    /*  Don't worry about FONT on TTY layouts. */
    IF h_btn_font NE ? AND _L._WIN-TYPE THEN DO:
      IF h_self:FONT NE _L._FONT AND _U._TYPE NE "BROWSE"
      THEN h_self:FONT = _L._FONT.
    END.
    
    IF h_btn_ttl_clr NE ? AND NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN
      ASSIGN h_self:TITLE-BGCOLOR = _L._TITLE-BGCOLOR
             h_self:TITLE-FGCOLOR = _L._TITLE-FGCOLOR.
    
    IF _U._TYPE = "RECTANGLE" THEN
      ASSIGN h_self:EDGE-PIXELS = _L._EDGE-PIXELS
             h_self:FILLED      = _L._FILLED.
      
    IF _U._TYPE = "WINDOW" AND sav-iu NE _C._ICON THEN
      stupid = h_self:LOAD-ICON(_C._ICON).
    
    IF _U._TYPE = "WINDOW" AND sav-iu2 NE _C._SMALL-ICON THEN
      stupid = h_self:LOAD-SMALL-ICON(_C._SMALL-ICON).
    
    IF _U._TYPE = "IMAGE":U THEN DO:
      h_self:STRETCH-TO-FIT = _F._STRETCH-TO-FIT.
      IF _F._STRETCH-TO-FIT THEN
        h_self:RETAIN-SHAPE = _F._RETAIN-SHAPE.
    END.

      
    IF h_label NE ? THEN DO:
      IF CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) THEN DO:
        DEFINE VARIABLE h_window AS WIDGET-HANDLE NO-UNDO.
        DEFINE VARIABLE OldTitle AS CHARACTER     NO-UNDO.
    
        ASSIGN h_window = IF _U._TYPE = "DIALOG-BOX" THEN _U._PARENT ELSE h_self
               OldTitle = h_window:TITLE.
        RUN adeuib/_wintitl.p (h_window,
                               _U._LABEL,
                               _U._LABEL-ATTR,
                               _P._SAVE-AS-FILE).
        /* Change the active window title on the Window menu. */
        IF (h_window:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr)
        THEN RUN WinMenuChangeName IN _h_WinMenuMgr
                 (INPUT _h_WindowMenu ,
                  INPUT OldTitle , INPUT h_window:TITLE).
    
      END.
      
      ELSE IF _U._TYPE = "FRAME" THEN DO:
        /* If any of the sav- stuff has been changed, we recreate the frame later    */
        IF sav-box = _L._NO-BOX AND sav-ttl = _C._TITLE AND sav-slab = _C._SIDE-LABELS AND
           sav-lbl = _L._NO-LABELS AND sav-3d = _L._3-D THEN DO:
           IF NOT _L._NO-BOX AND _C._TITLE THEN h_self:TITLE = h_label:SCREEN-VALUE.
        END.
      END.
        
      ELSE IF NOT _L._WIN-TYPE AND CAN-DO("BUTTON,TOGGLE-BOX",_U._TYPE) THEN
        RUN adeuib/_sim_lbl.p (h_self).
    
      ELSE IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER",_U._TYPE) THEN DO:
        IF _L._REMOVE-FROM-LAYOUT = NO THEN RUN adeuib/_showlbl.p (h_self).
        ELSE DO:
          FIND label_U WHERE RECID(label_U) = _U._l-recid.
          ASSIGN label_U._HANDLE:HIDDEN = _L._REMOVE-FROM-LAYOUT
                 h_self:HIDDEN          = _L._REMOVE-FROM-LAYOUT.
        END.
      END.  
            
      ELSE IF _U._TYPE NE "BROWSE" AND _U._TYPE NE "{&WT-CONTROL}" THEN
        h_self:LABEL = _U._LABEL.  /* BROWSEs always get recreated */
    END.
    
    IF _L._LO-NAME = "Master Layout" THEN DO:  /* Update other layouts */
      FOR EACH sync_L WHERE sync_L._u-recid = _L._u-recid AND
                            sync_L._LO-NAME NE _L._LO-NAME:
        IF NOT sync_L._CUSTOM-POSITION THEN
          ASSIGN sync_L._ROW            = _L._ROW
                 sync_L._COL            = _L._COL.
        IF NOT sync_L._CUSTOM-SIZE THEN
          ASSIGN sync_L._WIDTH          = _L._WIDTH
                 sync_L._HEIGHT         = _L._HEIGHT
                 sync_L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT
                 sync_L._VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH.
      END.
    END.
    ELSE DO:  /* Not the master layout */
      IF sav_row NE _L._ROW OR sav_col NE _L._COL THEN _L._CUSTOM-POSITION = TRUE.
          
      IF sav_width    NE _L._WIDTH          OR sav_height   NE _L._HEIGHT OR
         sav_v-height NE _L._VIRTUAL-HEIGHT OR sav_v-width  NE _L._VIRTUAL-WIDTH THEN
        _L._CUSTOM-SIZE = TRUE.
    END.

    IF AVAILABLE(_F) AND _F._DISPOSITION = "LIKE":U AND
       (sav_height NE _L._HEIGHT OR sav_width NE _L._WIDTH) THEN
      _F._SIZE-SOURCE = "E":U.

  END.  /* DO WITH FRAME prop_sht */
END.  /* Complete the transaction */

PROCEDURE data-type_change.
  IF change-data-type(_U._HANDLE,SELF:SCREEN-VALUE) THEN DO:
    IF _F._FORMAT-SOURCE eq "E" AND VALID-HANDLE(h_format) THEN DO:
      IF notAmerican AND
        LOOKUP(_F._DATA-TYPE,"INTEGER,DECIMAL":U) > 0 THEN DO:
        RUN adecomm/_convert.p ("A-TO-N", _F._FORMAT, 
                                _numeric_separator, _numeric_decimal,
                                OUTPUT conv_fmt).
        h_format:SCREEN-VALUE = conv_fmt.
      END.  /* If non-American format */            
      ELSE conv_fmt = _F._FORMAT.
      h_format:SCREEN-VALUE = conv_fmt.
    END.
    
    IF _U._TYPE = "RADIO-SET":U THEN
      ASSIGN h_query:SCREEN-VALUE  = _F._LIST-ITEMS.
    ELSE IF _U._TYPE = "COMBO-BOX":U THEN DO:
      IF h_ListType:SCREEN-VALUE = "I":U THEN
        ASSIGN h_query:SCREEN-VALUE  = _F._LIST-ITEMS.
      ELSE
        ASSIGN h_query:SCREEN-VALUE  = _F._LIST-ITEM-PAIRS.
      h_subtype:SENSITIVE = (SELF:SCREEN-VALUE = "CHARACTER":U).
     
    END. /* Else if a combo-box */
      
     /* Save entry number (1 or 2) of logical fill-in/combo-box initial value */
    IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND _F._DATA-TYPE EQ "LOGICAL" THEN DO:
      sav-ldef = LOOKUP (_F._INITIAL-DATA,_F._FORMAT,"/":U).
      IF sav-ldef = 0 THEN sav-ldef = 2. /* Just to be safe. */
    END.

    /* data-type affects the show-popup attribute because it is only for numeric and date fields*/
    IF CAN-DO("DATE,DECIMAL,INTEGER":u, _F._DATA-TYPE) AND isDynView THEN DO:
      IF VALID-HANDLE(h_show-popup) THEN
        ASSIGN h_show-popup:SENSITIVE = TRUE.
    END.
    ELSE DO:
      IF VALID-HANDLE(h_show-popup) THEN DO:
        ASSIGN h_show-popup:SENSITIVE = FALSE
               h_show-popup:CHECKED   = FALSE.
        APPLY "VALUE-CHANGED":U TO h_show-popup.
      END.  /* If h_show-popup is valid */
    END. /* Else do */

    IF _U._TYPE = "EDITOR" THEN
      RUN setEditorLarge.
  END.  /* If the data type was successfully changed in the underlying
           _U and _F records */
END. /* Procedure data-type_change */

PROCEDURE context_help_change.
  _C._CONTEXT-HELP = SELF:CHECKED.
  IF _C._CONTEXT-HELP THEN DO:
    IF _U._TYPE = "WINDOW":U THEN DO:  
      
      IF h_SMALL-TITLE:CHECKED THEN DO:
          h_SMALL-TITLE:CHECKED = FALSE.
          APPLY "VALUE-CHANGED":U TO h_SMALL-TITLE.
      END.  /* if small title checked */

      IF NOT h_CONTROL-BOX:CHECKED THEN DO:
          h_CONTROL-BOX:CHECKED = TRUE.
          APPLY "VALUE-CHANGED":U TO h_CONTROL-BOX.
      END.  /* if control box not checked */
      
      IF h_MIN-BUTTON:CHECKED THEN DO:
          h_MIN-BUTTON:CHECKED = FALSE.
          APPLY "VALUE-CHANGED":U TO h_MIN-BUTTON.
      END.  /* if min button checked */

      IF h_MAX-BUTTON:CHECKED THEN DO:
          h_MAX-BUTTON:CHECKED = FALSE.
          APPLY "VALUE-CHANGED":U TO h_MAX-BUTTON.
      END.  /* if max button checked */
      
    END.  /* if window */
    ASSIGN h_context-help-file:SENSITIVE = TRUE
           h_context-help-btn:SENSITIVE  = TRUE.
  END.  /* if checked */
END PROCEDURE.  /* context_help_change */

PROCEDURE context_help_file_change.
  _C._CONTEXT-HELP-FILE = SELF:SCREEN-VALUE.
END PROCEDURE.  /* context_help_file_change */

PROCEDURE context_help_id_change.
  _U._CONTEXT-HELP-ID = INTEGER(SELF:SCREEN-VALUE).
END PROCEDURE.  /* context_help_id_change */

PROCEDURE context_help_btn_choose.
  DEFINE VARIABLE cfname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK    AS LOGICAL   NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE cfname UPDATE lOK 
    FILTERS "Help Files (*.hlp)" "*.hlp", "All Files" "*.*"
    RETURN-TO-START-DIR TITLE "Choose Help File".
  
  IF lOK THEN DO:
    ASSIGN h_context-help-file:SCREEN-VALUE = cfname.
    APPLY "VALUE-CHANGED":U TO h_context-help-file.
  END.  /* if lOK */
END.

PROCEDURE db_field_selection.
  DEFINE VAR ans           AS LOGICAL              NO-UNDO.
  DEFINE VAR a-line        AS CHARACTER EXTENT 100 NO-UNDO.
  DEFINE VAR a-out         AS CHARACTER            NO-UNDO.
  DEFINE VAR dbf_temp_file AS CHARACTER            NO-UNDO.
  DEFINE VAR done          AS LOGICAL              NO-UNDO.
  DEFINE VAR use_Prefix    AS INTEGER              NO-UNDO.
  DEFINE VAR def_var       AS CHAR                 NO-UNDO  INITIAL
             "CHARACTER,DATE,DECIMAL,LOGICAL,INTEGER,RECID".              
  DEFINE VAR pressed_ok    AS LOGICAL              NO-UNDO.
  DEFINE VAR fld_name      AS CHAR                 NO-UNDO.
  DEFINE VAR fld_save      AS CHAR                 NO-UNDO.
  DEFINE VAR fmt           AS CHAR                 NO-UNDO.
  DEFINE VAR db_name       AS CHAR                 NO-UNDO.
  DEFINE VAR tbl_name      AS CHAR                 NO-UNDO.
  DEFINE VAR tbl_list      AS CHAR                 NO-UNDO.
  DEFINE VAR fld_type      AS CHAR                 NO-UNDO.
  DEFINE VAR fld_help      AS CHAR                 NO-UNDO.
  DEFINE VAR fld_help_sa   AS CHAR                 NO-UNDO.
  DEFINE VAR fld_label     AS CHAR                 NO-UNDO.
  DEFINE VAR fld_label_sa  AS CHAR                 NO-UNDO.
  DEFINE VAR fld_format    AS CHAR                 NO-UNDO.
  DEFINE VAR fld_format_sa AS CHAR                 NO-UNDO.
  DEFINE VAR fld_extent    AS INTEGER              NO-UNDO.
  DEFINE VAR fld_index     AS INTEGER              NO-UNDO.
  DEFINE VAR num_ent       AS INTEGER              NO-UNDO.
  DEFINE VAR num_count     AS INTEGER              NO-UNDO.
  DEFINE VAR must-be-like  AS LOGICAL              NO-UNDO.
  DEFINE VAR fld_initial   AS CHARACTER            NO-UNDO.
  DEFINE VAR old-dt        AS CHARACTER            NO-UNDO.
  DEFINE VAR old-nm        AS CHARACTER            NO-UNDO.
  DEFINE VAR p_index       AS INTEGER              NO-UNDO.
  DEFINE VAR show_items    AS CHARACTER            NO-UNDO.
  DEFINE VAR size-and-type AS LOGICAL              NO-UNDO.
  DEFINE VAR tmp-name      AS CHARACTER            NO-UNDO.
  DEFINE VAR tt-info       AS CHARACTER            NO-UNDO.

  DEFINE VAR fld_description AS CHARACTER          NO-UNDO.
  DEFINE VAR fld_valexp      AS CHARACTER          NO-UNDO.
  DEFINE VAR fld_valmsg      AS CHARACTER          NO-UNDO.
  DEFINE VAR fld_valmsg-sa   AS CHARACTER          NO-UNDO.
  DEFINE VAR fld_mandatory   AS LOGICAL            NO-UNDO.
  DEFINE VAR i               AS INTEGER            NO-UNDO.
  DEFINE VAR include-name    AS CHARACTER          NO-UNDO.
  DEFINE VAR hRepDesignMgr   AS HANDLE             NO-UNDO.
  DEFINE VAR cDataSourceType AS CHARACTER          NO-UNDO.
  DEFINE VAR cObjectName     AS CHARACTER          NO-UNDO.
  DEFINE VAR cCalculatedCols AS CHARACTER          NO-UNDO.
  DEFINE VAR cTable          AS CHARACTER          NO-UNDO.
  DEFINE VAR cLikeButton     AS CHARACTER          NO-UNDO.
  DEFINE VAR iNum            AS INTEGER            NO-UNDO.
  DEFINE VAR cLocalField     AS CHARACTER          NO-UNDO.
  
  DEFINE BUFFER ip_U FOR _U.
  DEFINE BUFFER f_U  FOR _U.

  ASSIGN def_var = IF _U._TYPE = "SELECTION-LIST" THEN "CHARACTER"
                   ELSE IF _U._TYPE = "SLIDER"         THEN "INTEGER"
                   ELSE IF _U._TYPE = "TOGGLE-BOX"     THEN "LOGICAL"
                   ELSE def_var
         old-dt  = _F._DATA-TYPE
         old-nm  = _U._NAME
         must-be-like = FALSE.

  IF _U._DBNAME = ? THEN DO: /* Select a DB field for this varaible */
    IF UsesDataObject = NO THEN DO:      
      /* Report Error -- no databases */
      IF NUM-DBS > 0 THEN ans = yes.
      ELSE RUN adecomm/_dbcnnct.p
              (INPUT  "You must have at least one connected database to select a field.",
               OUTPUT ans).
      IF ans THEN DO:
        FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
        IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)) THEN DO:
          FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
            tt-info = tt-info + ",":U + _TT._LIKE-DB + ".":U +
                      _TT._LIKE-TABLE + "|":U +
                      (IF _TT._NAME = ? THEN "?":U ELSE _TT._NAME).
          END.  /* For each _TT */
          tt-info = LEFT-TRIM(tt-info,",":U).
        END.  /* IF can-find a _TT record */
        ELSE tt-info = ?.
          
        ASSIGN fld_name = _U._NAME
               db_name  = _U._DBNAME
               tbl_name = _U._TABLE
               use_Prefix = ?.
        RUN adecomm/_fldsel.p (FALSE,
                              IF NUM-ENTRIES(def_var) > 1 THEN ? ELSE def_var,
                              INPUT tt-info,
                              INPUT-OUTPUT use_Prefix,
                              INPUT-OUTPUT db_name,
                              INPUT-OUTPUT tbl_name,
                              INPUT-OUTPUT fld_name,
                              OUTPUT pressed_ok).
      END.  /* IF ans (there is at least one DB connected */
    END.  /* IF UsesDataObject = NO */

    ELSE DO:  /* UsesDataObject */
      ASSIGN db_name = "Temp-Tables":U.
      /* Build the temp-table info to pass to the field picker. */
      tbl_name = "".
      IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)) THEN DO:
        FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
          tt-info = tt-info + ",":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                    "|":U + (IF _TT._NAME = ? THEN "?":U ELSE _TT._NAME).
          tbl_name = tbl_name + (IF _TT._NAME = ? THEN _TT._LIKE-TABLE ELSE _TT._NAME) + ",".
        END.  /* For each  _TT */
        tt-info = LEFT-TRIM(tt-info,",":U).
        tbl_name = TRIM(tbl_name, ",":U).
      END.  /* Is there a temp-table associated with this _P? */
      ELSE tt-info = ?.
    
      IF tbl_name = "" OR tbl_name = ? THEN DO:
        MESSAGE "Unable to determine data souce information."
               VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN.
      END.
        
      ASSIGN num_ent  = NUM-ENTRIES(tbl_name)
             tbl_list = tbl_name.
      IF num_ent > 0 THEN DO:
        /* Get a list of "database.table,database.table" */
        DO num_count = 1 TO num_ent:
          ENTRY(num_count, tbl_list) = db_name + "." + ENTRY(num_count, tbl_name).
        END.
        /* If user does not have any temp-tables defined other than RowObject,
           display only the field name. Otherwise, display table.field.  jep-code */
        ASSIGN show_items = (IF NUM-ENTRIES(tbl_list) <= 1 THEN "1":U
                                                           ELSE "2":U).
        /* Remove fields that are already taken */
        FOR EACH f_U WHERE f_U._PARENT-RECID = RECID(PARENT_U) AND
                           f_U._STATUS = "NORMAL":U:
          /* Add field name to fld_name */
          fld_name = fld_name + ",":U + f_U._NAME.
        END.
        fld_name = LEFT-TRIM(fld_name,",":U).

        RUN adecomm/_fldseld.p
            (INPUT tbl_list, 
             INPUT hDataObject , 
             INPUT tt-info, 
             INPUT show_items, 
             INPUT ",",
             INPUT IF NUM-ENTRIES(def_var) > 1 THEN ? ELSE def_var /* data-type */,
             INPUT-OUTPUT fld_name).
        num_ent = NUM-ENTRIES(fld_name).
        ASSIGN pressed_ok = (RETURN-VALUE <> "CANCEL":U) AND (num_ent > 0).
        /* At this point, fld_name is in the form Temp-Tables.RowObject.Fieldname.
           Strip out what we need. jep-code */
        IF pressed_OK THEN
            ASSIGN tbl_name = ENTRY(2, fld_name, ".":U) 
                   fld_name = ENTRY(3, fld_name, ".":U) NO-ERROR.
      END. /* If we have at least 1 entry in the tbl_name list */
    END.  /* Else UsesDataObject */

    IF pressed_ok AND LENGTH(fld_name,"RAW":U) > 0 THEN DO:  /* have a db field */
      /* Viewer fields are validated, BLOBs cannot be mapped to any visual objects
         and CLOBs can only be mapped to EDITOR objects.  CLOB fields must have
         unique names in the viewer and are renamed if they clash with a field
         already on the viewer.  */
      IF usesDataObject THEN
      DO:
        IF VALID-HANDLE(hDataObject) THEN
        DO:
          fld_type = DYNAMIC-FUNC("columnDataType" IN hDataObject, fld_name) NO-ERROR.
          IF fld_type = "BLOB":U THEN
          DO:
            MESSAGE fld_name " is a BLOB field and cannot be mapped to a visual object."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN.
          END.
          IF fld_type = "CLOB":U AND _U._TYPE NE "EDITOR":U THEN
          DO:
            MESSAGE fld_name " is a CLOB field and can only be mapped to an editor object."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN.
          END.
          /* Rename the local field if there is already a field on the viewer 
           with the same name. */
          ELSE IF fld_type = "CLOB":U AND _U._TYPE = "EDITOR":U THEN
          DO:
            ASSIGN
              cLocalField = fld_name
              iNum        = 0.
            /* First check for other fields */
            NameCheck:
            DO WHILE TRUE:
              FIND FIRST x_U WHERE x_U._NAME EQ cLocalField 
                     AND x_U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
                     AND x_U._STATUS NE "DELETED":U NO-ERROR.
              IF AVAILABLE x_U THEN 
              DO:
                IF iNum > 0 THEN
                  cLocalField = SUBSTRING(cLocalField, 1, INDEX(cLocalField, "-":U) - 1).
                iNum = iNum + 1.
                cLocalField = cLocalField + "-":U + STRING(iNum).
              END.  /* if available x_U */
              ELSE LEAVE NameCheck.
            END.  /* do while true */
            /* Second check for other CLOB fields that may already have the same name
               local name */
            LocalNameCheck:
            DO WHILE TRUE:
              FIND FIRST x_U WHERE x_U._LOCAL-NAME EQ cLocalField 
                     AND x_U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
                     AND x_U._STATUS NE "DELETED":U NO-ERROR.
              IF AVAILABLE x_U THEN
              DO:
                IF iNum > 0 THEN
                  cLocalField = SUBSTRING(cLocalField, 1, INDEX(cLocalField, "-":U) - 1).
                iNum = iNum + 1.
                cLocalField = cLocalField + "-":U + STRING(iNum).
              END.  /* if avail x_U */
              ELSE LEAVE LocalNameCheck.
            END.  /* do while true */
            ASSIGN 
              _F._SOURCE-DATA-TYPE = "CLOB":U
              _U._LOCAL-NAME       = cLocalField.
          END.  /* if clob and type = editor */
        END.  /* if valid dataobject handle */
        ELSE DO:
          MESSAGE "Unable to start data object " _P._DATA-OBJECT "."
                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
          RETURN.
        END.
      END.  /* if uses data object */

      /* Verify that this field is not already in the same frame */
      FIND ip_U WHERE ip_U._HANDLE ne h_self
                  AND ip_U._STATUS ne "DELETED":U
                  AND ip_U._DBNAME eq db_name
                  AND ip_U._TABLE  eq tbl_name
                  AND ip_U._NAME   eq fld_name
                  AND ip_U._PARENT eq _U._PARENT NO-ERROR.
      IF AVAILABLE ip_U AND
         CAN-FIND(_F WHERE RECID(_F) EQ ip_U._x-recid AND
                           _F._DISPOSITION NE "LIKE":U) THEN
        /* This DB field is already there, the user MUST mean this to 
           be a variable "LIKE" this field.                         */
        ASSIGN must-be-like = TRUE.
      ELSE DO:  /* This field is not already in the frame */
        /* Did the user return an array element? If so, parse it for the
           variable (fld_save) and the array index (fld_index). */
        IF (fld_name MATCHES ("*[*]"))
          THEN ASSIGN fld_save  = SUBSTRING (fld_name, INDEX (fld_name, "[") + 1,
                                         -1,"CHARACTER":U)
                      fld_index = INTEGER (REPLACE (fld_save, "]", ""))
                      fld_save  = SUBSTRING (fld_name, 1, INDEX (fld_name, "[") - 1,
                                            "CHARACTER":U)
                      fld_label = fld_name.
          ELSE ASSIGN fld_save  = fld_name
                      fld_index = ?.

        ASSIGN _U._NAME         = fld_name
               _U._DBNAME       = db_name
               _U._TABLE        = tbl_name
               _U._BUFFER       = tbl_name
               _F._DICT-VIEW-AS = _suppress_dict_view-as.
        /* Determine the class of the selected field */       
        IF _DynamicsIsRunning and isDynView THEN
        DO:
          hRepDesignMgr = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
          IF VALID-HANDLE(hDataObject) THEN
          DO:
            cDataSourceType = DYNAMIC-FUNCTION('getObjectType':U IN hDataObject).
            cCalculatedCols = DYNAMIC-FUNCTION('getCalculatedColumns':U IN hDataObject).
            IF cDataSourceType = 'SmartBusinessObject':U AND NUM-ENTRIES(fld_name, '.':U) > 1 THEN
               ASSIGN cTable = ENTRY(1, fld_name, '.':U).    
            ELSE 
               ASSIGN cTable = DYNAMIC-FUNCTION('ColumnPhysicalTable':U IN hDataObject,  fld_name) NO-ERROR.

            cObjectName = IF LOOKUP(fld_name, cCalculatedCols) > 0 
                          THEN fld_name
                          ELSE DYNAMIC-FUNCTION('ColumnPhysicalColumn':U IN hDataObject, fld_name).
          END.
          ELSE ASSIGN cObjectName     = tbl_Name + "." + fld_name
                      cDataSourceType = 'SmartDataObject'.
                      
          ASSIGN cObjectName = REPLACE(cObjectName,"[","")
                 cObjectName = REPLACE(cObjectName,"]","").
                   
          /* Retrieve the master datafield from the repository */
          RUN retrieveDesignObject IN hRepDesignMgr
                  ( INPUT  cObjectName,
                    INPUT  "",  /* Get default result Code */
                    OUTPUT TABLE ttObject ,
                    OUTPUT TABLE ttPage,
                    OUTPUT TABLE ttLink,
                    OUTPUT TABLE ttUiEvent,
                    OUTPUT TABLE ttObjectAttribute ) NO-ERROR.                                                    
           /* Get the Master datafield */
          FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = cObjectName NO-ERROR.
           
          IF AVAILABLE ttObject THEN
             ASSIGN _U._CLASS-NAME  = ttObject.tClassName
                    _U._OBJECT-NAME = cObjectName 
                    _U._TABLE       = IF cTable = "" then tbl_Name ELSE cTable
                    _U._BUFFER      = IF cDataSourceType = 'SmartDataObject':U 
                                      THEN 'RowObject':U  ELSE  _U._TABLE.
        
        END. /* End if dynamics is running */
        IF db_name = "Temp-Tables" THEN DO:
          FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                               _TT._NAME    = tbl_name NO-ERROR.
          IF NOT AVAILABLE _TT THEN
            FIND FIRST _TT WHERE _TT._p-recid    = RECID(_P) AND
                                 _TT._LIKE-TABLE = tbl_name NO-ERROR.
          IF NOT AVAILABLE _TT THEN
            FIND FIRST _TT WHERE _TT._p-recid    = RECID(_P) AND
                                 _TT._TABLE-TYPE = "D":U NO-ERROR.
          IF _TT._TABLE-TYPE <> "D":U THEN
            ASSIGN db_name  = _TT._LIKE-DB
                   tbl_name = _TT._LIKE-TABLE.
        END.  /* Have choosen a temp-tables field */

        /* IF temp-table type "D", were are working with a SmartData object. jep-code */
        IF db_name = "Temp-Tables":U AND (_TT._TABLE-TYPE = "D") THEN DO:
          IF UsesDataObject AND NOT VALID-HANDLE(hDataObject) THEN DO:
            MESSAGE "Unable to start data object " _P._DATA-OBJECT "."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            RETURN.
          END.
         
          fld_label   = DYNAMIC-FUNC("columnLabel" IN hDataObject, fld_save ) NO-ERROR.
          fld_format  = DYNAMIC-FUNC("columnFormat" IN hDataObject, fld_save ) NO-ERROR.
          fld_help    = DYNAMIC-FUNC("columnHelp" IN hDataObject, fld_save ) NO-ERROR.
          fld_type    = DYNAMIC-FUNC("columnDataType" IN hDataObject, fld_save ) NO-ERROR.
          fld_initial = DYNAMIC-FUNC("columnInitial" IN hDataObject, fld_save ) NO-ERROR.
          IF isDynview THEN
            ASSIGN _U._TABLE    = DYNAMIC-FUNC("columnTable":U IN hDataObject, fld_save) NO-ERROR.
        END.  /* Working with a SmartDataObject */
        ELSE RUN adeuib/_fldinfo.p (db_name, tbl_name, fld_save,
                                 OUTPUT fld_label,  OUTPUT fld_label_sa,
                                 OUTPUT fld_format, OUTPUT fld_format_sa, OUTPUT fld_type,
                                 OUTPUT fld_help,   OUTPUT fld_help_sa,   OUTPUT fld_extent,
                                 OUTPUT fld_initial,
                                 OUTPUT fld_description,
                                 OUTPUT fld_valexp,
                                 OUTPUT fld_valmsg,
                                 OUTPUT fld_valmsg-sa,
                                 OUTPUT fld_mandatory ).


        ASSIGN _F._SUBSCRIPT     = fld_index
               _U._LABEL         = fld_label
               _U._LABEL-ATTR    = fld_label_sa
               _U._HELP          = fld_help
               _U._HELP-ATTR     = fld_help_sa
               _F._DATA-TYPE     = IF (fld_type = "CLOB":U AND _U._TYPE = "EDITOR":U) 
                                   THEN "LONGCHAR":U
                                   ELSE CAPS(fld_type)
               _F._FORMAT        = fld_format
               _F._FORMAT-ATTR   = fld_format_sa
               _U._LABEL-SOURCE  = IF isDynView THEN "E":U ELSE "D"
               _F._FORMAT-SOURCE = "D"
               _U._HELP-SOURCE   = "D"
               _F._INITIAL-DATA  = fld_initial.

        IF _F._DATA-TYPE NE old-dt AND VALID-HANDLE(h_data-type) THEN DO:
          /* Some widget types don't have a data-type field (i.e. Editors) */
          h_data-type:SCREEN-VALUE = _F._DATA-TYPE.
          APPLY "VALUE-CHANGED" TO h_data-type.
        END.

        /* Add the Index to the Label */
        IF fld_index NE ? THEN
          ASSIGN _U._LABEL = _U._LABEL + 
                             "[":U + LEFT-TRIM(STRING(fld_index,">>>>>>>9")) + "]":U.
        /* Remove unknown values */
        IF _F._FORMAT-ATTR EQ ? THEN _F._FORMAT-ATTR = "".
        IF _U._LABEL-ATTR EQ ?  THEN _U._LABEL-ATTR = "".
        IF _U._HELP-ATTR EQ ?   THEN _U._HELP-ATTR = "".
        IF h_data-type NE ?     THEN h_data-type:SCREEN-VALUE = _F._DATA-TYPE.
        IF h_inner-lines NE ?   THEN h_inner-lines:SCREEN-VALUE  =
                                                  STRING(_F._INNER-LINES,">>>,>>>,>>9").
        ASSIGN h_label:SENSITIVE     = FALSE WHEN VALID-HANDLE(h_label)
               h_format:SENSITIVE    = FALSE WHEN VALID-HANDLE(h_format)
               h_btn_fmt:SENSITIVE   = FALSE WHEN VALID-HANDLE(h_btn_fmt)
               h_data-type:SENSITIVE = FALSE WHEN VALID-HANDLE(h_data-type)
               name:SENSITIVE IN FRAME prop_sht = FALSE.
      END.  /* Else not all ready in the frame */
    END.  /* pressed OK and have a field with a valid length */
  END.  /* IF _U._DBNAME = ? */

  IF _U._DBNAME NE ? THEN DO:  /* We have a DB field here, have the use specify
                                  what is explicit and what is implicit        */
    DEFINE VARIABLE db-var  AS CHARACTER VIEW-AS RADIO-SET VERTICAL
        RADIO-BUTTONS 
            "&Database Field", "Field",
            "Local &Variable", "Local",
            "L&ike",           "Like"
         SIZE 45 BY 2.5 NO-UNDO.
    DEFINE VARIABLE def_format  AS LOGICAL
           VIEW-AS TOGGLE-BOX LABEL "&Format String"    NO-UNDO.
    DEFINE VARIABLE def_help    AS LOGICAL
           VIEW-AS TOGGLE-BOX LABEL "H&elp String"      NO-UNDO.
    DEFINE VARIABLE def_label   AS LOGICAL
           VIEW-AS TOGGLE-BOX LABEL "&Label"            NO-UNDO.
    DEFINE VARIABLE def_view-as AS LOGICAL
           VIEW-AS TOGGLE-BOX LABEL "View-&As Phrase"   NO-UNDO.
    DEFINE VARIABLE viewas      AS CHARACTER            NO-UNDO.

    /* standard button rectangle */

    /* Buttons for the bottom of the screen                                      */
    DEFINE BUTTON btn_OK      LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
    DEFINE BUTTON btn_cancel  LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
    DEFINE BUTTON btn_help    LABEL "&Help":C12  {&STDPH_OKBTN}.

    &SCOPED-DEFINE OK     btn_OK
    &SCOPED-DEFINE CANCEL btn_cancel
    &SCOPED-DEFINE HELP   btn_help
    
    DEFINE FRAME db-defaults SKIP ({&VM_WIDG})
        "Control Type:" AT 5
        db-var     AT 10 NO-LABEL SKIP ({&VM_WIDG})
        "Default to data source specifications for:" AT 5 SKIP ({&VM_WID})
        def_label   AT 10 SKIP ({&VM_WID})
        def_format  AT 10 SKIP ({&VM_WID})
        def_help    AT 10 SKIP ({&VM_WID})
        def_view-as AT 10 SKIP ({&VM_WIDG})
        {adecomm/okform.i}
      WITH VIEW-AS DIALOG-BOX TITLE "Data Field Defaults" DEFAULT-BUTTON btn_OK
           THREE-D.

    ASSIGN FRAME db-defaults:PARENT = ACTIVE-WINDOW.
    IF _U._DBNAME NE ? THEN
      RUN adecomm/_s-schem.p(_U._DBNAME, _U._TABLE,
                             IF CAN-DO("LIKE,FIELD",_F._DISPOSITION) AND
                               _F._LIKE-FIELD NE "" THEN _F._LIKE-FIELD ELSE _U._NAME,
                             "FIELD:VIEW-AS":U,
                             OUTPUT viewas).
 
    {adecomm/okrun.i &FRAME = "FRAME db-defaults"} 

    ASSIGN def_label  = (_U._LABEL-SOURCE = "D")
           def_format = (_F._FORMAT-SOURCE = "D")
           def_help   = (_U._HELP-SOURCE = "D")
           def_view-as:CHECKED = viewas NE ? AND _F._DICT-VIEW-AS
           db-var:RADIO-BUTTONS IN FRAME db-defaults =
                  (IF _U._DBNAME NE "Temp-Tables" THEN "&Database Field"
                                                  ELSE "&Data Source Field") +
                   ",FIELD,Local &Variable,Local,L&ike " + _U._TABLE + "." + 
                   (IF _F._DISPOSITION = "LIKE":U AND _F._LIKE-FIELD NE ""
                    THEN _F._LIKE-FIELD ELSE _U._NAME) + ",Like"
           db-var:SCREEN-VALUE = IF _F._DISPOSITION = "LIKE" OR must-be-like
                                   THEN "LIKE" ELSE "FIELD".

    ON CHOOSE OF btn_help IN FRAME db-defaults OR HELP OF FRAME db-defaults DO:
      RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Dict_Defauts_Dlg_Box}, ? ).
    END.
   
    ON CHOOSE OF btn_OK IN FRAME db-defaults DO:
      ASSIGN def_label def_format def_help def_view-as db-var
             _U._LABEL-SOURCE      = IF def_label  THEN "D" ELSE "E"
             _F._FORMAT-SOURCE     = IF def_format THEN "D" ELSE "E"
             _U._HELP-SOURCE       = IF def_help   THEN "D" ELSE "E"
             _F._DICT-VIEW-AS      = def_view-as
             _F._DISPOSITION       = db-var.
      IF VALID-HANDLE(h_label) THEN
            h_label:SENSITIVE = IF _U._LABEL-SOURCE = "D" THEN FALSE ELSE TRUE.
      IF VALID-HANDLE(h_format) THEN
            h_format:SENSITIVE = IF _F._FORMAT-SOURCE = "D" OR (_U._TYPE = "COMBO-BOX" AND
                                    _U._SUBTYPE NE "DROP-DOWN-LIST") THEN FALSE ELSE TRUE.
      IF VALID-HANDLE(h_btn_fmt) THEN
            h_btn_fmt:SENSITIVE = IF _F._FORMAT-SOURCE = "D" OR (_U._TYPE = "COMBO-BOX" AND
                                     _U._SUBTYPE NE "DROP-DOWN-LIST") THEN FALSE ELSE TRUE.
      IF VALID-HANDLE(h_data-type) THEN
            h_data-type:SENSITIVE = IF _U._TABLE NE ? OR (_U._TYPE = "COMBO-BOX" AND
                                       _U._SUBTYPE NE "DROP-DOWN-LIST") THEN FALSE ELSE TRUE.
      IF db-var EQ "Local" THEN DO:
        ASSIGN  _U._DBNAME                       = ?
                _U._TABLE                        = ?
                _F._SUBSCRIPT                    = ?
                _U._NAME                         = (IF _U._NAME NE _F._LIKE-FIELD AND
                                                       _F._LIKE-FIELD NE "" AND _U._NAME NE ""
                                                       THEN _U._NAME ELSE _U._TYPE + "_" + _U._NAME)
                _U._LOCAL-NAME                   = ""
                _U._LABEL-SOURCE                 = "E"
                _F._FORMAT-SOURCE                = "E"
                _U._HELP-SOURCE                  = "E"
                _F._SIZE-SOURCE                  = "E"
                _F._SOURCE-DATA-TYPE             = ?
                name:SENSITIVE IN FRAME prop_sht = TRUE.
        IF VALID-HANDLE(h_label)     THEN
          ASSIGN h_label:SENSITIVE     = TRUE
                 h_label:SCREEN-VALUE  = _U._LABEL.
        IF VALID-HANDLE(h_format)    THEN DO:
          fmt = _F._FORMAT.
          IF notAmerican THEN
            RUN adecomm/_convert.p ("A-TO-N", _F._FORMAT, 
                                    _numeric_separator, _numeric_decimal, 
                                    OUTPUT fmt).
                                    
          ASSIGN h_format:SENSITIVE    = IF (_U._TYPE = "COMBO-BOX":U AND _U._SUBTYPE NE "DROP-DOWN-LIST":U) 
                                           THEN FALSE ELSE TRUE
                 h_format:SCREEN-VALUE = IF def_format THEN
                                  (IF _F._DATA-TYPE BEGINS "C" THEN "X(8)" ELSE
                                   IF _F._DATA-TYPE BEGINS "DA" THEN "99/99/99" ELSE
                                   IF _F._DATA-TYPE BEGINS "L"  THEN "yes/no" ELSE
                                   IF _F._DATA-TYPE BEGINS "DE" THEN
                                     (IF notAmerican THEN "->>":U + _numeric_separator + ">>9":U + _numeric_decimal + "99":U
                                      ELSE "->>,>>9.99":U) ELSE
                                   IF _F._DATA-TYPE BEGINS "I"  THEN 
                                     (IF notAmerican THEN "->":U + _numeric_separator + ">>>":U + _numeric_separator + ">>9":U
                                      ELSE "->,>>>,>>9":U) ELSE
                                   ">>>>>>>") ELSE fmt.
        END.  /* IF there is a format */
        IF VALID-HANDLE(h_btn_fmt)   THEN h_btn_fmt:SENSITIVE   = 
          IF _U._TYPE = "COMBO-BOX":U AND _U._SUBTYPE NE "DROP-DOWN-LIST":U THEN FALSE ELSE TRUE.
        IF VALID-HANDLE(h_data-type) THEN h_data-type:SENSITIVE = 
          IF _U._TYPE = "COMBO-BOX":U AND _U._SUBTYPE NE "DROP-DOWN-LIST":U THEN FALSE ELSE TRUE.   
        
        IF _U._TYPE = "COMBO-BOX":U AND _U._SUBTYPE NE "DROP-DOWN-LIST":U THEN h_format:SCREEN-VALUE = "".             
            
        DISPLAY _U._NAME @ name WITH FRAME prop_sht.
      END. /* If db-var is local */

      ELSE IF db-var = "LIKE":U THEN DO:
        ASSIGN _F._SIZE-SOURCE = "D":U
               _F._UNDO        = NO
               sav_height      = _L._HEIGHT
               sav_width       = _L._WIDTH.
        IF _U._NAME NE old-nm THEN
          ASSIGN _F._LIKE-FIELD  = _U._NAME
                 _U._NAME        = old-nm
                 size-and-type   = TRUE.
        DISPLAY _U._NAME @ name WITH FRAME prop_sht.
      END.  /* If db-var is LIKE" and name has changed */

      ELSE IF db-var NE "LIKE":U THEN DO:  /* Attaching to a db-field */
        /* Tack on the table and db name to the end of the widget name */
        ASSIGN name            = _U._NAME + "  (" +
                                   db-tbl-name(_U._DBNAME + "." + _U._TABLE) + ")"
               _F._SIZE-SOURCE = "E":U
               size-and-type   = viewas NE ? AND _F._DICT-VIEW-AS.

        /* Now redisplay all the information about the variable. This
           should show the new NAME, LABEL, FORMAT and disable all these
           fields accordingly. */
        DISPLAY name WITH FRAME prop_sht.
      END.  /* Else attaching to a db-field */
      IF size-and-type THEN DO:
        /* Write out db field to determine new size and type */
        RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_DBFIELD}, {&STD_EXT_UIB} ,
                                OUTPUT dbf_temp_file).
        ASSIGN a-out = ENTRY(1,dbf_temp_file,".") + ".a"
               done  = FALSE.
        SESSION:NUMERIC-FORMAT = "AMERICAN".
        OUTPUT STREAM temp_stream TO VALUE(dbf_temp_file) {&NO-MAP}.
        IF _U._DBNAME = "Temp-Tables":U AND _U._TABLE = "RowObject":U
          AND _P._data-object NE "" THEN
        DO:
          /* Must generate the "RowObject" temp-table definition (tomn 1/7/2000) */
          ASSIGN i            = R-INDEX(_P._data-object,".")
                 include-name = IF i > 0 THEN SUBSTRING(_P._data-object, 1, i) + "i" 
                                         ELSE _P._data-object + ".i"
                 include-name = '"' + REPLACE(include-name, "~\", "~/") + '"'.
          IF SEARCH(include-name) = ? AND 
             _P.OBJECT_path NE "":U AND 
             NOT include-name BEGINS _P.OBJECT_path THEN
              include-name = _P.OBJECT_path + "~/":U + include-name.

          PUT STREAM temp_stream UNFORMATTED
            "DEFINE TEMP-TABLE RowObject ~{":U + include-name + "~}.":U SKIP(1).
        END.
        PUT STREAM temp_stream UNFORMATTED "DEFINE FRAME xx" SKIP "  " +
                             (IF _U._DBNAME = "Temp-Tables" THEN "" ELSE _U._DBNAME + ".") +
                             _U._TABLE + "." + 
                             (IF _F._LIKE-FIELD NE "" THEN _F._LIKE-FIELD ELSE _U._NAME) +
                             (IF _F._LIKE-FIELD NE "" AND _U._TYPE NE "FILL-IN" THEN
                             " VIEW-AS " + _U._TYPE ELSE "")
                             SKIP
                             "  WITH SIDE-LABELS." SKIP .
        OUTPUT STREAM temp_stream CLOSE.
        IF SEARCH(include-name) NE ? OR _P._data-object EQ "":U THEN DO:
          ANALYZE VALUE(dbf_temp_file) VALUE(a-out).
          INPUT STREAM temp_stream FROM VALUE(a-out).
          REPEAT WHILE NOT done:
            IMPORT STREAM temp_stream a-line.
            IF a-line[1] = "FR" AND a-line[2] = "xx" THEN DO:
              IMPORT STREAM temp_stream a-line.  /* Read over the frame */
              IMPORT STREAM temp_stream a-line.  /* Get the TYPE */
              _U._TYPE = IF a-line[1] = "FF" THEN "FILL-IN" ELSE
                         IF a-line[1] = "TB" THEN "TOGGLE-BOX" ELSE
                         IF a-line[1] = "SE" THEN "SELECTION-LIST" ELSE
                         IF a-line[1] = "CB" THEN "COMBO-BOX" ELSE
                         IF a-line[1] = "RS" THEN "RADIO-SET" ELSE
                         IF a-line[1] = "ED" THEN "EDITOR" ELSE
                         IF a-line[1] = "SL" THEN "SLIDER" ELSE
                         "FILL-IN".
              IF _U._ALIGN = "C":U AND CAN-DO("SELECTION-LIST,RADIO-SET,EDITOR,SLIDER":U,_U._TYPE)
                THEN _U._ALIGN = "L":U.           
              IMPORT STREAM temp_stream a-line.  /* Get the size */
              ASSIGN _L._WIDTH           = DECIMAL(a-line[5])
                     h_wdth:SCREEN-VALUE = STRING (_L._WIDTH)
                     _L._HEIGHT          = DECIMAL(a-line[6])
                     h_hgt:SCREEN-VALUE  = STRING (_L._HEIGHT)
                     done = TRUE.
              IF _U._TYPE = "EDITOR" THEN
                ASSIGN _F._WORD-WRAP   = a-line[30] NE "y"
                       _F._SCROLLBAR-H = a-line[23] EQ "y"
                       _U._SCROLLBAR-V = a-line[24] EQ "y"
                       _L._NO-BOX      = a-line[32] EQ "y".
              INPUT STREAM temp_stream CLOSE.
            END.  /* Found the frame */
          END. /* REPEAT UNTIL done */
        END.  /* Can find the include file */
        OS-DELETE VALUE (a-out).
        OS-DELETE VALUE (dbf_temp_file).
        SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).      
      END.  /* if we need to get the size and type */

    END.  /* Choose of btn_ok */
   
    ON VALUE-CHANGED OF db-var IN FRAME db-defaults DO:
      IF SELF:SCREEN-VALUE = "LOCAL" THEN
        ASSIGN def_label:CHECKED IN FRAME db-defaults     = FALSE
               def_label:SENSITIVE IN FRAME db-defaults   = FALSE
               def_format:CHECKED IN FRAME db-defaults    = FALSE
               def_format:SENSITIVE IN FRAME db-defaults  = FALSE
               def_help:CHECKED IN FRAME db-defaults      = FALSE
               def_help:SENSITIVE IN FRAME db-defaults    = FALSE
               def_view-as:CHECKED IN FRAME db-defaults   = FALSE
               def_view-as:SENSITIVE IN FRAME db-defaults = FALSE.
      ELSE  /* Changed to either a Dictionary field or Like a dictionary field */
        ASSIGN def_label:CHECKED IN FRAME db-defaults     =
                      IF def_label:SENSITIVE THEN def_label:CHECKED ELSE TRUE
               def_label:SENSITIVE IN FRAME db-defaults   =
                         CAN-DO("BUTTON,COMBO-BOX,FILL-IN,TOGGLE-BOX", _U._TYPE)
               def_format:CHECKED IN FRAME db-defaults    =
                      IF def_format:SENSITIVE THEN def_format:CHECKED ELSE TRUE
               def_format:SENSITIVE IN FRAME db-defaults  =
                         CAN-DO("COMBO-BOX,FILL-IN",_U._TYPE)
               def_help:CHECKED IN FRAME db-defaults      =
                      IF def_help:SENSITIVE THEN def_help:CHECKED ELSE TRUE
               def_help:SENSITIVE IN FRAME db-defaults    = TRUE
               def_view-as:CHECKED IN FRAME db-defaults   = FALSE
               def_view-as:SENSITIVE IN FRAME db-defaults = viewas NE ?.
    END.  /* On value-changed of radio-set db-var (disposition) */

    DISPLAY def_label def_format def_help db-var WITH FRAME db-defaults.
    ASSIGN db-var:SENSITIVE IN FRAME db-defaults     = NOT must-be-like
           def_label:SENSITIVE IN FRAME db-defaults  =
                     CAN-DO("BUTTON,COMBO-BOX,FILL-IN,TOGGLE-BOX", _U._TYPE)
           def_format:SENSITIVE IN FRAME db-defaults =
                     CAN-DO("COMBO-BOX,FILL-IN",_U._TYPE)
           def_help:SENSITIVE IN FRAME db-defaults   = TRUE
           def_view-as:SENSITIVE IN FRAME db-defaults = viewas NE ? AND
                                 db-var:SCREEN-VALUE IN FRAME db-defaults NE "LOCAL".
    IF _F._SOURCE-DATA-TYPE = "CLOB":U THEN 
    DO:
      cLikeButton = ENTRY(5, db-var:RADIO-BUTTONS).
      db-var:DISABLE(cLikeButton).
    END.
    UPDATE btn_OK btn_cancel btn_help WITH FRAME db-defaults.
          
  END. /* IF _U._DBNAME NE ? THEN DO */

  IF _U._DBNAME = ? THEN DO:
    IF h_NO-UNDO  NE ? THEN ASSIGN h_NO-UNDO:SENSITIVE = TRUE.
    IF h_SHARED   NE ? THEN ASSIGN h_SHARED:SENSITIVE  = TRUE.
  END.  /* We don't have a DBNAME */
  ELSE DO:
    IF h_NO-UNDO  NE ? THEN ASSIGN h_NO-UNDO:SENSITIVE = FALSE
                                   h_NO-UNDO:CHECKED   = IF _F._DISPOSITION NE "LIKE" THEN FALSE
                                                         ELSE NOT _F._UNDO.
    IF h_SHARED   NE ? THEN ASSIGN h_SHARED:SENSITIVE  = FALSE
                                   h_SHARED:CHECKED    = FALSE.

    IF _U._LABEL-SOURCE = "D" OR _F._FORMAT-SOURCE = "D" OR
       _U._HELP-SOURCE = "D" THEN DO:
      /* Need to call _fldinfo to get db info */
      ASSIGN tmp-name = IF _F._LIKE-FIELD NE "" THEN
                          (IF INDEX(_F._LIKE-FIELD,"[") > 0 THEN
                              ENTRY(1,_F._LIKE-FIELD,"[") ELSE _F._LIKE-FIELD)
                        ELSE IF _F._DISPOSITION NE "LIKE":U THEN
                          (IF INDEX(_U._NAME,"[") > 0 THEN ENTRY(1,_U._NAME,"[")
                                                      ELSE _U._NAME)
                        ELSE IF _F._DISPOSITION EQ "LIKE" AND 
                          NUM-ENTRIES(_U._NAME,".":U) = 1 THEN _U._NAME
                        ELSE ""
             db_name  = _U._DBNAME
             tbl_name = _U._TABLE.

      IF db_name = "Temp-Tables" THEN DO:
        FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                             _TT._NAME    = tbl_name NO-ERROR.
        IF NOT AVAILABLE _TT THEN
          FIND FIRST _TT WHERE _TT._p-recid    = RECID(_P) AND
                               _TT._LIKE-TABLE = tbl_name NO-ERROR.
        IF NOT AVAILABLE _TT THEN
          FIND FIRST _TT WHERE _TT._p-recid    = RECID(_P) AND
                               _TT._TABLE-TYPE = "D":U NO-ERROR.
        IF _TT._TABLE-TYPE <> "D":U THEN
          ASSIGN db_name  = _TT._LIKE-DB
                 tbl_name = _TT._LIKE-TABLE.
      END. /* IF db_name is a Temp-Table */

      /* IF temp-table type "D", were are working with a SmartData object. jep-code */
      IF db_name = "Temp-Tables":U AND (_TT._TABLE-TYPE = "D") THEN DO:
        IF UsesDataObject AND NOT VALID-HANDLE(hDataObject) THEN DO:
            MESSAGE "Unable to start data object " _P._DATA-OBJECT "."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            RETURN.
        END.  /* If we think we are using a SDO but don't have a valid handle */
        IF tmp-name = "" THEN tmp-name = _U._NAME.
        fld_label   = DYNAMIC-FUNC("columnLabel" IN hDataObject, tmp-name ) NO-ERROR.
        fld_format  = DYNAMIC-FUNC("columnFormat" IN hDataObject, tmp-name ) NO-ERROR.
        fld_help    = DYNAMIC-FUNC("columnHelp" IN hDataObject, tmp-name ) NO-ERROR.
        fld_type    = DYNAMIC-FUNC("columnDataType" IN hDataObject, tmp-name ) NO-ERROR.
        fld_initial = DYNAMIC-FUNC("columnIntial" IN hDataObject, tmp-name ) NO-ERROR.
        /* If this object is already in the repository we have to delete it and recreate it
           because the object type is being changed.  Here we delete it, we will recreate it
           in rygendynp.p  from the _U.  */
        IF _U._object-obj NE 0 THEN DO:
          /* Note the fact that _U._object-obj is non zero means the Dynamics is running */
          IF NOT VALID-HANDLE(hDevManager) THEN
            ASSIGN hDevManager = DYNAMIC-FUNCTION("getManagerHandle":U, 
                                        INPUT "RepositoryDesignManager":U).
          RUN removeInstances IN hDevManager ( INPUT _U._object-obj) .
          _U._object-obj = 0.0.
        END.  /* If this is already in the repository */
      END. /* If db_name = Temp-tables and type is "D" (a SDO) */
      ELSE IF tmp-name NE "" THEN DO:
        RUN adeuib/_fldinfo.p (db_name, tbl_name, tmp-name,
                               OUTPUT fld_label,  OUTPUT fld_label_sa,
                               OUTPUT fld_format, OUTPUT fld_format_sa, OUTPUT fld_type,
                               OUTPUT fld_help,   OUTPUT fld_help_sa,   OUTPUT fld_extent,
                               OUTPUT fld_initial,
                               OUTPUT fld_description,
                               OUTPUT fld_valexp,
                               OUTPUT fld_valmsg,
                               OUTPUT fld_valmsg-sa,
                               OUTPUT fld_mandatory).
                                 
      END.  /* If we looked it up in the dictionary/data source */

      IF _U._LABEL-SOURCE = "D" THEN
        ASSIGN _U._LABEL        = fld_label
               _U._LABEL-ATTR   = fld_label_sa.
      IF _U._HELP-SOURCE = "D" THEN
        ASSIGN _U._HELP         = fld_help
               _U._HELP-ATTR    = fld_help_sa.
      IF _F._FORMAT-SOURCE = "D" THEN
        ASSIGN _F._FORMAT       = fld_format
               _F._FORMAT-ATTR  = fld_format_sa.
    END.  /* If something id default ("D") */
    
    IF VALID-HANDLE(h_label) THEN
      h_label:SCREEN-VALUE  = _U._LABEL.
    IF VALID-HANDLE(h_format) THEN DO:
      fmt = _F._FORMAT.
      IF notAmerican THEN
      RUN adecomm/_convert.p ("A-TO-N", _F._FORMAT, 
                              _numeric_separator, _numeric_decimal,
                              OUTPUT fmt).
      h_format:SCREEN-VALUE = IF _U._TYPE = "COMBO-BOX":U AND _U._SUBTYPE NE "DROP-DOWN-LIST":U 
                                THEN "" ELSE fmt.
    END.
    /* Put this field in the query definition */
    IF _F._DISPOSITION NE "LIKE":U THEN
     RUN adeuib/_vrfyqry.p (INPUT _h_frame,
                             INPUT "ADD-FIELDS":U,
                             INPUT _U._DBNAME + "." + _U._TABLE + "." + _U._NAME).
  END.
  h_NO-UNDO:SENSITIVE = _F._DISPOSITION NE "FIELD".  
END PROCEDURE.
           

PROCEDURE edge_pixels_change.
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "EDGE-PIXELS"
                     &NEW-VALUE1 = "INTEGER(SELF:SCREEN-VALUE)"}
  ASSIGN _L._EDGE-PIXELS        = INTEGER(SELF:SCREEN-VALUE)
         h_GRAPHIC-EDGE:CHECKED = _L._EDGE-PIXELS > 0 AND _L._EDGE-PIXELS < 8
         _L._GRAPHIC-EDGE       = h_GRAPHIC-EDGE:CHECKED.
END.

PROCEDURE field_edit.
  DEFINE VARIABLE ctblname    AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER           NO-UNDO.
  DEFINE VARIABLE table-list  AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE tmp-name    AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE xtbls       AS CHARACTER         NO-UNDO.

  RUN adeuib/_tbllist.p (INPUT RECID(_U), INPUT FALSE, OUTPUT xtbls).

  ASSIGN table-list   = (IF xtbls NE "" THEN xtbls ELSE "").
  
  /* Add in _Q._TblList table not already in table-list */
  IF _Q._TblList NE "" THEN DO:
    DO i = 1 TO NUM-ENTRIES(_Q._TblList):
      IF NOT CAN-DO(table-list, ENTRY(i,_Q._TblList)) THEN
        table-list = table-list + "," + ENTRY(i,_Q._TblList).
    END. /* For each table in _Q._TblList */
    /* Trim off any leading or trailing commas */
    table-list = TRIM(table-list,",":U).
  END.

  _query-u-rec = RECID(_U).
  DO i = 1 TO NUM-ENTRIES (table-list):
    ASSIGN ENTRY(i,table-list) = ENTRY(1, ENTRY(i,table-list), " ":U)
           tmp-name            = ENTRY(i,table-list).
    IF NUM-ENTRIES(tmp-name,".":U) = 1 THEN ctblname = tmp-name.  /* May be a buffer */
    ELSE ctblname = ENTRY(2,tmp-name,".":U).
    FIND FIRST _TT WHERE _TT._p-recid = RECID(_P)
                     AND _TT._NAME = ctblname NO-ERROR.
    IF AVAILABLE _TT THEN
      ENTRY(i,table-list) = "Temp-Tables":U + "." + ctblname.
  END.
  /* Send the table list or a handle to the SmartData */
  RUN adeuib/_coledit.p (INPUT table-list, INPUT ?).
END.

PROCEDURE font_edit.
  DEFINE VARIABLE parent_font AS INTEGER INITIAL ? NO-UNDO.
  DEFINE VARIABLE l_ok        AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE sav_font    AS INTEGER           NO-UNDO.

  IF _U._TYPE = "BROWSE" AND _U._LAYOUT-NAME NE "Master Layout" THEN DO:
    MESSAGE "The font of a browse may not be changed between layouts."
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
  END.  
  sav_font = _L._FONT.

  IF NOT CAN-DO("WINDOW,FRAME,DIALOG-BOX",_U._TYPE) THEN DO:
    ASSIGN parent_font = parent_L._FONT.
  END.
  RUN adecomm/_chsfont.p  ("Choose Font",
                           parent_font,
                           INPUT-OUTPUT _L._FONT,
                           OUTPUT l_ok).
  IF _U._TYPE = "COMBO-BOX":U THEN
    ASSIGN _U._HANDLE:FONT    = _L._FONT
           h_hgt:SCREEN-VALUE = STRING(_U._HANDLE:HEIGHT,">>>.99")
           _U._HANDLE:FONT    = sav_font.
  IF _L._LO-NAME = "Master Layout" THEN DO:  /* Update other layouts */
    FOR EACH sync_L WHERE sync_L._u-recid = _L._u-recid AND
                          sync_L._LO-NAME NE _L._LO-NAME AND
                          synC_L._FONT    = sav_font:
      sync_L._FONT = _L._FONT.
    END.
  END.
END. /* font_edit */

PROCEDURE format_change.
  DEFINE VARIABLE cTestFile  AS CHARACTER  NO-UNDO.

  /* Validate format string */
  run adecomm/_tmpfile.p (INPUT "", INPUT ".AB", OUTPUT cTestFile).
  OUTPUT TO VALUE(cTestFile).
  PUT UNFORMATTED "DEF VAR X AS " + _F._DATA-TYPE + " FORMAT '":U + SELF:SCREEN-VALUE + "'.":U SKIP.
  OUTPUT CLOSE.
  COMPILE VALUE(cTestFile) NO-ERROR.
  OS-DELETE VALUE(cTestFile).
  IF COMPILER:ERROR THEN DO:
    MESSAGE "Illegal format mask specification."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.

  IF _F._FORMAT NE SELF:SCREEN-VALUE THEN _F._FORMAT-SOURCE = "E":U.
  ASSIGN _F._FORMAT          = SELF:SCREEN-VALUE.

END.

PROCEDURE format_professor.
  DEF VAR fmt     AS CHAR CASE-SENSITIVE NO-UNDO.
  fmt = h_format:SCREEN-VALUE.

  /*
  IF _F._FORMAT-SOURCE eq "E" THEN ASSIGN _F._FORMAT = h_format:SCREEN-VALUE.
  fmt = _F._FORMAT .
  */
  CASE _F._DATA-TYPE:
    WHEN "CHARACTER":U   THEN RUN adecomm/_y-build.p (1, INPUT-OUTPUT fmt).
    WHEN "DATE":U        THEN RUN adecomm/_y-build.p (2, INPUT-OUTPUT fmt).
    WHEN "DATETIME":U    THEN RUN adecomm/_y-build.p (34, INPUT-OUTPUT fmt).
    WHEN "DATETIME-TZ":U THEN RUN adecomm/_y-build.p (40, INPUT-OUTPUT fmt).
    WHEN "LOGICAL":U     THEN RUN adecomm/_y-build.p (3, INPUT-OUTPUT fmt).
    WHEN "DECIMAL":U     THEN RUN adecomm/_y-build.p (5, INPUT-OUTPUT fmt). 
    WHEN "RECID":U       THEN RUN adecomm/_y-build.p (7, INPUT-OUTPUT fmt).
    OTHERWISE                 RUN adecomm/_y-build.p (4, INPUT-OUTPUT fmt).
  END CASE.
  
  /* Convert the output value, if necessary, back into American format */
  /* and display this as the format's screen-value; however, store the */
  /* American value separately.                                        */
  IF notAmerican AND (_F._DATA-TYPE = "Integer" OR
    _F._DATA-TYPE = "Decimal") THEN 
       RUN adecomm/_convert.p ("N-TO-A",fmt, 
                               _numeric_separator, _numeric_decimal, 
                               OUTPUT conv_fmt).
    ELSE
       conv_fmt = fmt.

  /* Update value */
  IF _F._FORMAT NE fmt THEN DO:
    ASSIGN h_format:SCREEN-VALUE = fmt
           _F._FORMAT            = conv_fmt
           _F._FORMAT-SOURCE     = "E".
  END.
END PROCEDURE.

PROCEDURE icon_change.
  DEF VAR Absolute_Name AS CHAR    NO-UNDO.
  DEF VAR cnt           AS INTEGER NO-UNDO.
  DEF VAR TestExt       AS CHAR    NO-UNDO.
  
  image-formats = "Icons (*.ico)|*.ico|All Files|*.*":U.
  RUN adecomm/_fndfile.p (INPUT "Image",               /* pTitle             */
                          INPUT "IMAGE",               /* pMode              */
                 &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                          INPUT image-formats,         /* pFilters           */
                 &ELSE
                          INPUT "*.xbm,*.xpm|*.*":U,   /* pFilters           */
                 &ENDIF
                          INPUT-OUTPUT {&ICON-DIRS},   /* pDirList           */
                          INPUT-OUTPUT _C._ICON,       /* pFileName          */
                          OUTPUT Absolute_Name,        /* pAbsoluteFileMName */
                          OUTPUT IF_OK).               /* pOK                */
  IF IF_OK THEN DO:
    ASSIGN stupid = SELF:LOAD-IMAGE(_C._ICON)
           h_fn_txt:SCREEN-VALUE = 
                    IF _C._ICON eq "" THEN ""
                    ELSE ENTRY(NUM-ENTRIES(_C._ICON,"/"),_C._ICON,"/").
    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
    /* Get the file extension and make sure it is "ICO" in MS-Windows. 
       (Assuming that there is a file chosen.) */
    IF _C._ICON ne "" THEN DO:
      ASSIGN cnt     = NUM-ENTRIES(Absolute_Name,".":U)
             TestExt = IF cnt > 1 THEN ENTRY(cnt,Absolute_Name,".":U) ELSE ""
             .      
      IF TestExt <> "ICO" THEN
         MESSAGE "Windows can only be minimized with true ~".ico~" files."
            VIEW-AS ALERT-BOX WARNING BUTTONS OK. 
    END. /* IF...icon ne "" */ 
  &ENDIF  
  END. /*...IF_OK...*/
END PROCEDURE.

PROCEDURE sicon_change.
  DEF VAR Absolute_Name AS CHAR    NO-UNDO.
  DEF VAR cnt           AS INTEGER NO-UNDO.
  DEF VAR TestExt       AS CHAR    NO-UNDO.
  
  image-formats = "Icons (*.ico)|*.ico|All Files|*.*":U.
  RUN adecomm/_fndfile.p (INPUT "Image",               /* pTitle             */
                          INPUT "IMAGE",               /* pMode              */
                 &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                          INPUT image-formats,         /* pFilters           */
                 &ELSE
                          INPUT "*.xbm,*.xpm|*.*":U,   /* pFilters           */
                 &ENDIF
                          INPUT-OUTPUT {&ICON-DIRS},   /* pDirList           */
                          INPUT-OUTPUT _C._SMALL-ICON, /* pFileName          */
                          OUTPUT Absolute_Name,        /* pAbsoluteFileMName */
                          OUTPUT IF_OK).               /* pOK                */
  IF IF_OK THEN DO:
    ASSIGN stupid = SELF:LOAD-IMAGE(_C._SMALL-ICON)
           h_sicon_txt:SCREEN-VALUE = {&sicon_txt}.
    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
    /* Get the file extension and make sure it is "ICO" in MS-Windows. 
       (Assuming that there is a file chosen.) */
    IF _C._SMALL-ICON ne "" THEN DO:
      ASSIGN cnt     = NUM-ENTRIES(Absolute_Name,".":U)
             TestExt = IF cnt > 1 THEN ENTRY(cnt,Absolute_Name,".":U) ELSE ""
             .      
      IF TestExt <> "ICO" THEN
         MESSAGE "Windows can only be minimized with true ~".ico~" files."
            VIEW-AS ALERT-BOX WARNING BUTTONS OK. 
    END. /* IF...icon ne "" */ 
  &ENDIF  
  END. /*...IF_OK...*/
END PROCEDURE.

PROCEDURE image_down_change.
  DEF VAR Absolute_Name AS CHAR NO-UNDO.
  
  image-formats = "All Picture Files|*.bmp,*.dib,*.ico,*.gif,*.jpg,*.cal,*.cut,*.dcx,*.eps,*.ica,*.iff,*.img," +
    "*.lv,*.mac,*.msp,*.pcd,*.pct,*.pcx,*.psd,*.ras,*.im,*.im1,*.im8,*.tga,*.tif,*.xbm,*.bm,*.xpm,*.wmf,*.wpg" +
    "|Bitmaps (*.bmp,*.dib)|*.bmp,*.dib|Icons (*.ico)|*.ico|GIF (*.gif)|*.gif|JPEG (*.jpg)|*.jpg" +
    "|CALS (*.cal)|*.cal|Halo CUT (*.cut)|*.cut|Intel FAX (*.dcx)|*.dcx|EPS (*.eps)|*.eps|IOCA (*.ica)|*.ica" +
    "|Amiga IFF (*.iff)|*.iff|GEM IMG (*.img)|*.img|LaserView (*.lv)|*.lv|MacPaint (*.mac)|*.mac" +
    "|Microsoft Paint (*.msp)|*.msp|Photo CD (*.pcd)|*.pcd|PICT (*.pct)|*.pct|PC Paintbrush (*.pcx)|*.pcx" +
    "|Adobe Photoshop (*.psd)|*.psd|Sun Raster (*.ras,*.im,*.im1,*.im8)|*.ras,*.im,*.im1,*.im8|TARGA (*.tga)|*.tga" +
    "|TIFF (*.tif)|*.tif|Pixmap (*.xpm)|*.xpm|Metafiles (*.wmf)|*.wmf|WordPerfect graphics (*.wpg)|*.wpg|" +
    "Xbitmap (*.xbm,*.bm)|*.xbm,*.bm|All Files|*.*":U.
    
  RUN adecomm/_fndfile.p (INPUT "Image",               /* pTitle            */
                          INPUT "IMAGE",               /* pMode             */
      &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                          INPUT image-formats,         /* pFilters          */
      &ELSE
                          INPUT "*.xbm,*.xpm|*.*":U,   /* pFilters          */
      &ENDIF
                          INPUT-OUTPUT {&ICON-DIRS},   /* pDirList          */
                          INPUT-OUTPUT _F._IMAGE-DOWN-FILE, 
                          OUTPUT Absolute_Name,        /* pAbsoluteFileName */
                          OUTPUT IF_OK).               /* pOK               */
 IF IF_OK THEN
   ASSIGN stupid                    = SELF:LOAD-IMAGE(_F._IMAGE-DOWN-FILE)
          h_fn_dwn_txt:SCREEN-VALUE = IF _F._IMAGE-DOWN-FILE = ""
             THEN ""
             ELSE ENTRY(NUM-ENTRIES(_F._IMAGE-DOWN-FILE,dir-del),
                                    _F._IMAGE-DOWN-FILE,dir-del).
END PROCEDURE.

PROCEDURE image_insen_change.
  DEF VAR Absolute_Name AS CHAR NO-UNDO.
  
  image-formats = "All Picture Files|*.bmp,*.dib,*.ico,*.gif,*.jpg,*.cal,*.cut,*.dcx,*.eps,*.ica,*.iff,*.img," +
    "*.lv,*.mac,*.msp,*.pcd,*.pct,*.pcx,*.psd,*.ras,*.im,*.im1,*.im8,*.tga,*.tif,*.xbm,*.bm,*.xpm,*.wmf,*.wpg" +
    "|Bitmaps (*.bmp,*.dib)|*.bmp,*.dib|Icons (*.ico)|*.ico|GIF (*.gif)|*.gif|JPEG (*.jpg)|*.jpg" +
    "|CALS (*.cal)|*.cal|Halo CUT (*.cut)|*.cut|Intel FAX (*.dcx)|*.dcx|EPS (*.eps)|*.eps|IOCA (*.ica)|*.ica" +
    "|Amiga IFF (*.iff)|*.iff|GEM IMG (*.img)|*.img|LaserView (*.lv)|*.lv|MacPaint (*.mac)|*.mac" +
    "|Microsoft Paint (*.msp)|*.msp|Photo CD (*.pcd)|*.pcd|PICT (*.pct)|*.pct|PC Paintbrush (*.pcx)|*.pcx" +
    "|Adobe Photoshop (*.psd)|*.psd|Sun Raster (*.ras,*.im,*.im1,*.im8)|*.ras,*.im,*.im1,*.im8|TARGA (*.tga)|*.tga" +
    "|TIFF (*.tif)|*.tif|Pixmap (*.xpm)|*.xpm|Metafiles (*.wmf)|*.wmf|WordPerfect graphics (*.wpg)|*.wpg|" +
    "Xbitmap (*.xbm,*.bm)|*.xbm,*.bm|All Files|*.*":U.
  
  RUN adecomm/_fndfile.p (INPUT "Image",               /* pTitle         */
                          INPUT "IMAGE",               /* pMode          */
     &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                          INPUT image-formats,         /* pFilters       */
     &ELSE
                          INPUT "*.xbm,*.xpm|*.*":U,   /* pFilters       */
     &ENDIF
                          INPUT-OUTPUT {&ICON-DIRS},   /* pDirList       */
                          INPUT-OUTPUT _F._IMAGE-INSENSITIVE-FILE, 
                          OUTPUT Absolute_Name,        /* pAbsolute_Name */
                          OUTPUT IF_OK).               /* pOK            */
  IF IF_OK THEN
    ASSIGN stupid       = SELF:LOAD-IMAGE(_F._IMAGE-INSENSITIVE-FILE)
           h_fn_ins_txt:SCREEN-VALUE = IF _F._IMAGE-INSENSITIVE-FILE = ""
             THEN ""
             ELSE ENTRY(NUM-ENTRIES(_F._IMAGE-INSENSITIVE-FILE,dir-del),
                                    _F._IMAGE-INSENSITIVE-FILE,dir-del).
END PROCEDURE.

PROCEDURE image_up_change.
  DEF VAR Absolute_Name AS CHAR NO-UNDO.
  DEF VAR tmp-name      AS CHAR NO-UNDO.
  
  IF _F._IMAGE-FILE = "adeicon/blank":U THEN
    ASSIGN tmp-name       = _F._IMAGE-FILE
           _F._IMAGE-FILE = "":U.

  image-formats = "All Picture Files|*.bmp,*.dib,*.ico,*.gif,*.jpg,*.cal,*.cut,*.dcx,*.eps,*.ica,*.iff,*.img," +
    "*.lv,*.mac,*.msp,*.pcd,*.pct,*.pcx,*.psd,*.ras,*.im,*.im1,*.im8,*.tga,*.tif,*.xbm,*.bm,*.xpm,*.wmf,*.wpg" +
    "|Bitmaps (*.bmp,*.dib)|*.bmp,*.dib|Icons (*.ico)|*.ico|GIF (*.gif)|*.gif|JPEG (*.jpg)|*.jpg" +
    "|CALS (*.cal)|*.cal|Halo CUT (*.cut)|*.cut|Intel FAX (*.dcx)|*.dcx|EPS (*.eps)|*.eps|IOCA (*.ica)|*.ica" +
    "|Amiga IFF (*.iff)|*.iff|GEM IMG (*.img)|*.img|LaserView (*.lv)|*.lv|MacPaint (*.mac)|*.mac" +
    "|Microsoft Paint (*.msp)|*.msp|Photo CD (*.pcd)|*.pcd|PICT (*.pct)|*.pct|PC Paintbrush (*.pcx)|*.pcx" +
    "|Adobe Photoshop (*.psd)|*.psd|Sun Raster (*.ras,*.im,*.im1,*.im8)|*.ras,*.im,*.im1,*.im8|TARGA (*.tga)|*.tga" +
    "|TIFF (*.tif)|*.tif|Pixmap (*.xpm)|*.xpm|Metafiles (*.wmf)|*.wmf|WordPerfect graphics (*.wpg)|*.wpg|" +
    "Xbitmap (*.xbm,*.bm)|*.xbm,*.bm|All Files|*.*":U.

  RUN adecomm/_fndfile.p (INPUT "Image",               /* pTitle            */
                          INPUT "IMAGE",               /* pMode             */
     &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                          INPUT image-formats,         /* pFilters          */
     &ELSE
                          INPUT "*.xbm,*.xpm|*.*":U,   /* pFilters          */
     &ENDIF
                          INPUT-OUTPUT {&ICON-DIRS},   /* pDirList          */
                          INPUT-OUTPUT _F._IMAGE-FILE, /* pFileName         */
                          OUTPUT Absolute_Name,        /* pAbsoluteFileName */
                          OUTPUT IF_OK).               /* pOK               */

  IF _F._IMAGE-FILE = "":U AND tmp-name <> "":U THEN
    ASSIGN _F._IMAGE-FILE = tmp-name.
 
  IF IF_OK THEN
    ASSIGN stupid               = SELF:LOAD-IMAGE(_F._IMAGE-FILE)
           h_fn_txt:SCREEN-VALUE = IF _F._IMAGE-FILE = ""
                     THEN ""
                     ELSE ENTRY(NUM-ENTRIES(_F._IMAGE-FILE,dir-del),
                                _F._IMAGE-FILE,dir-del).
END PROCEDURE.

PROCEDURE inner_lines_change.
  _F._INNER-LINES = INTEGER(SELF:SCREEN-VALUE).
END.


PROCEDURE label_change.
  ASSIGN _U._LABEL  = SELF:SCREEN-VALUE.
END.

PROCEDURE lock_columns_change.
  _C._NUM-LOCKED-COLUMNS = INTEGER(SELF:SCREEN-VALUE).
END.

PROCEDURE max_chars_change.
  _F._MAX-CHARS = INTEGER(SELF:SCREEN-VALUE).
END.

PROCEDURE max_data_guess_change.
  _C._MAX-DATA-GUESS = INTEGER(SELF:SCREEN-VALUE).
END.

PROCEDURE max_value_change.
  RUN frequency_validation (OUTPUT lFreqValidate).
  IF NOT lFreqValidate THEN RETURN ERROR.
  ELSE DO:
    _F._MAX-VALUE = INTEGER(SELF:SCREEN-VALUE).
    IF _F._MAX-VALUE > 2147483648 THEN 
      ASSIGN _F._MAX-VALUE = 2147483648
             SELF:SCREEN-VALUE = STRING(_F._MAX-VALUE,"->,>>>,>>>,>>9").
    ELSE IF _F._MAX-VALUE < -2147483647 THEN 
      ASSIGN _F._MAX-VALUE = -2147483647
             SELF:SCREEN-VALUE = STRING(_F._MAX-VALUE,"->,>>>,>>>,>>9").
  END.  /* else do - frequency validation passed */
END.

PROCEDURE menu_bar_change.
  DEF VAR pressed_ok as logical no-undo.
  DEF VAR empty_menu as logical no-undo.
  DEF VAR lOk        AS LOGICAL NO-UNDO.

  RUN adecomm/_setcurs.p ("WAIT").
  
  /* Avoid conflict with SmartToolbar menu */
  RUN toolbar_check(OUTPUT lok).
  
  IF NOT lok THEN 
    RETURN.

         
  /* Update the Menu-bar if necessary */
  IF update_menu-bar THEN DO:
    RUN adeuib/_updmenu.p (delete_menu-bar, menu-bar_recid, OUTPUT h_menu-bar).
    _C._menu-recid = IF delete_menu-bar THEN ? ELSE menu-bar_recid.
    IF h_menu-bar NE h_self:MENUBAR THEN h_self:MENUBAR = h_menu-bar.
    ASSIGN update_menu-bar = no
           delete_menu-bar = no.
  END. 
  
  menu-bar_recid = _C._menu-recid.
  RUN adeuib/_edtmenu.p (INPUT RECID(_U), 
                         INPUT "MENUBAR",
                         INPUT ?,
                         INPUT-OUTPUT menu-bar_recid,
                         OUTPUT pressed_ok,
                         OUTPUT empty_menu).
  IF pressed_ok THEN ASSIGN update_menu-bar = pressed_ok
                            delete_menu-bar = empty_menu.
  IF delete_menu-bar THEN
    ASSIGN h_btn_menu-bar:TOOLTIP = "Menu Bar".
  ELSE 
    ASSIGN h_btn_menu-bar:TOOLTIP = "Menu Bar (defined)".  
END PROCEDURE.

PROCEDURE min_value_change:
  RUN frequency_validation (OUTPUT lFreqValidate).
  IF NOT lFreqValidate THEN RETURN ERROR.
  ELSE DO:
    _F._MIN-VALUE = INTEGER(SELF:SCREEN-VALUE).
    IF _F._MIN-VALUE < -2147483647 THEN 
      ASSIGN _F._MIN-VALUE = -2147483647
             SELF:SCREEN-VALUE = STRING(_F._MIN-VALUE,"->,>>>,>>>,>>9").
    ELSE IF _F._MIN-VALUE > 2147483648 THEN 
      ASSIGN _F._MIN-VALUE = 2147483648
             SELF:SCREEN-VALUE = STRING(_F._MIN-VALUE,"->,>>>,>>>,>>9").
  END.  /* else do - frequency validation passed */
END.

PROCEDURE no_label_change:
  _L._NO-LABELS = SELF:CHECKED.
  /* If we are going to have a default label for a DB field, fetch it          */
  IF _U._DBNAME ne ? AND _U._LABEL-SOURCE eq "D" THEN DO:
    IF _U._DBNAME NE "Temp-Tables":U THEN
      RUN adeuib/_fldlbl.p (_U._DBNAME, _U._TABLE, _U._NAME, parent_C._SIDE-LABELS,
                            OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).
    ELSE DO:  /* Dealing with a temp-table or sdo field here */
      FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                           _TT._NAME = _U._TABLE NO-ERROR.
      IF NOT AVAILABLE _TT THEN
        FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                             _TT._LIKE-TABLE = _U._TABLE NO-ERROR.
      IF NOT AVAILABLE _TT THEN
        FIND FIRST _TT WHERE _TT._p-recid    = RECID(_P) AND
                             _TT._TABLE-TYPE = "D":U NO-ERROR.
      /* Temp-table field type is never "D". */
      IF _TT._TABLE-TYPE <> "D":U THEN
      RUN adeuib/_fldlbl.p (_TT._LIKE-DB, _TT._LIKE-TABLE, _U._NAME,
                            parent_C._SIDE-LABELS,
                            OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).
      ELSE IF VALID-HANDLE(hDataObject) THEN /* Must be sdo field */
        _U._LABEL = DYNAMIC-FUNC("columnLabel" IN hDataObject, _U._NAME ) NO-ERROR.
    END.
    ASSIGN h_label:SCREEN-VALUE = _U._LABEL.
  END.
  IF _L._LO-NAME = "Master Layout" THEN DO:  /* Update other layouts */
    FOR EACH sync_L WHERE sync_L._u-recid = _L._u-recid AND
                          sync_L._LO-NAME NE _L._LO-NAME AND
                          sync_L._NO-LABELS = sav-lbl:
      sync_L._NO-LABELS = _L._NO-LABELS.
    END.
  END.
END.

PROCEDURE popup_menu_change:
  DEF VAR pressed_ok as logical no-undo.
  DEF VAR empty_menu as logical no-undo.
                
  RUN adecomm/_setcurs.p ("WAIT":U).

  /* Update the popup menu if necessary */ 
  IF update_menu THEN DO:
     RUN adeuib/_updmenu.p (delete_menu, popup_recid, OUTPUT h_menu).
     _U._popup-recid = IF delete_menu THEN ? ELSE popup_recid.
     IF h_menu <> h_self:POPUP-MENU THEN h_self:POPUP-MENU = h_menu.
     ASSIGN update_menu = no
            delete_menu = no.
  END.
 
  popup_recid = _U._popup-recid.
  RUN adeuib/_edtmenu.p (RECID(_U), "POPUP-MENU", ?,
                         INPUT-OUTPUT popup_recid,
                         OUTPUT pressed_ok,
                         OUTPUT empty_menu).
  IF pressed_ok THEN ASSIGN update_menu = pressed_ok
                            delete_menu = empty_menu.
  h_btn_popup:TOOLTIP = "Popup" + (IF delete_menu THEN " Menu" ELSE " Menu (Defined)").
END.

PROCEDURE query_edit:
  IF AVAILABLE _F THEN DO:
    IF CAN-DO("SELECTION-LIST,COMBO-BOX",_U._TYPE) THEN DO:
      IF h_listType:SCREEN-VALUE = "P":U THEN /* LIST-ITEM-PAIRS */
        ASSIGN _F._LIST-ITEM-PAIRS = REPLACE(RIGHT-TRIM(SELF:SCREEN-VALUE),CHR(13),"")
               _F._LIST-ITEMS = ?.    
      ELSE /* LIST-ITEMS */
        ASSIGN _F._LIST-ITEMS = REPLACE(RIGHT-TRIM(SELF:SCREEN-VALUE),CHR(13),"")
               _F._LIST-ITEM-PAIRS = ?.
    END.
    ELSE /* RADIO-SET */
      ASSIGN _F._LIST-ITEMS = REPLACE(RIGHT-TRIM(SELF:SCREEN-VALUE),CHR(13),"").
  END.
END.

PROCEDURE query_modify:
  DEFINE VARIABLE dbconnected AS LOGICAL  NO-UNDO.
  IF NUM-DBS = 0 THEN DO:
    RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to modify a query." ,
      OUTPUT dbconnected).
    if dbconnected eq no THEN RETURN.
  END.

  DO ON QUIT, LEAVE:
    IF _U._TYPE eq "BROWSE":U
    THEN RUN adeuib/_callqry.p ("_U":U, RECID(_U), "NORMAL":U).
    ELSE RUN adeuib/_callqry.p ("_U":U, RECID(_U), "QUERY-ONLY":U).
    FIND _TRG WHERE _TRG._wRECID = RECID(_U) AND
                    _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
    IF AVAILABLE _TRG THEN RUN freeform_setup.
    ELSE ASSIGN  h_query:SCREEN-VALUE = TRIM (_Q._4GLQury).

    IF VALID-HANDLE(h_btn_flds) THEN
      h_btn_flds:SENSITIVE = h_btn_mdfy:SENSITIVE AND _Q._4GLQury NE "".
  END.
END.

PROCEDURE row-height_change:
  DEFINE VARIABLE minbrw-height AS DECIMAL NO-UNDO.
  DEFINE VARIABLE new-height    AS DECIMAL NO-UNDO.

  new-height = DECIMAL(SELF:SCREEN-VALUE).
  
  /* Browse height may not big enough to handle this new row-height, so 
    we need to try to assign it with no-error and if there is an error we
    need to determine what the minimum height of the browse is for this
    row-height and then resize the browse
    the * 3 + 2 calculation is trying to make the browse big enough to 
    avoid an error so that we can assign the new row-height and determine
    what the min height of the browse needs to be to accommodate this 
    new row height */
  h_self:ROW-HEIGHT = new-height NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      ASSIGN h_self:HEIGHT     = new-height * 3 + 2
             h_self:ROW-HEIGHT = new-height
             minbrw-height     = h_self:MIN-HEIGHT-CHARS.
      MESSAGE _U._NAME "must be at least" minbrw-height
          "characters high.  Resizing..." VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      ASSIGN h_self:HEIGHT      = minbrw-height
             h_hgt:SCREEN-VALUE = STRING(minbrw-height).
      APPLY "LEAVE":U TO h_hgt.
  END.  /* if error */
  _C._ROW-HEIGHT = new-height.
END.

PROCEDURE switchList:
/* 
 * Called from the RADIO-SET for List-Items/List-Item-Pairs attribute when it's
 * value has changed. If we have changed from Pairs to Items, we retain only the
 * left-hand values. If we have changed from Items to Pairs, we replicate the list-item
 * in the case of the character variable (selection-list or char Radio-Set) to create
 * the pair, otherwise we substitute a value for that datatype for the second value.
 */
  DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tmpString AS CHARACTER NO-UNDO.
  
  ASSIGN switchlist           = TRUE
         h_query:SCREEN-VALUE = RIGHT-TRIM(h_query:SCREEN-VALUE).
  IF h_query:SCREEN-VALUE NE "" THEN DO:
    /* Try to convert current contents */
    IF SELF:SCREEN-VALUE = "I" /* LIST-ITEMS */ THEN DO:
      DO i = 1 TO NUM-ENTRIES(h_query:SCREEN-VALUE,CHR(10)):
        tmpString = (IF tmpString NE "" THEN tmpString + CHR(10) ELSE tmpString) + 
                     ENTRY(1,ENTRY(i,h_query:SCREEN-VALUE,CHR(10)),_F._DELIMITER).
      END.
      ASSIGN h_query:SCREEN-VALUE = RIGHT-TRIM(tmpString)
            _F._LIST-ITEMS        = h_query:SCREEN-VALUE.
            _F._LIST-ITEM-PAIRS   = ?.

    END.
    ELSE DO: /* LIST-ITEM-PAIRS */
      DO i = 1 TO NUM-ENTRIES(h_query:SCREEN-VALUE,CHR(10)):
        ASSIGN tmpString = (IF tmpString NE "" THEN tmpString + CHR(10) ELSE tmpString) + 
                           ENTRY(i,h_query:SCREEN-VALUE,CHR(10)) + _F._DELIMITER.
        CASE _F._DATA-TYPE: /* Figure out which value to display based on data type */
          WHEN "CHARACTER":U THEN tmpString = tmpString + ENTRY(i,h_query:SCREEN-VALUE,CHR(10)).
          WHEN "INTEGER":U   THEN tmpString = tmpString + STRING(i,_F._FORMAT).
          WHEN "LOGICAL":U   THEN tmpString = tmpString + STRING(no,_F._FORMAT).
          WHEN "DECIMAL":U   THEN tmpString = tmpString + STRING(i,_F._FORMAT).
          WHEN "DATE":U      THEN tmpString = tmpString + STRING(TODAY,_F._FORMAT).
        END.
        ASSIGN tmpString = tmpString + (IF i <> NUM-ENTRIES(h_query:SCREEN-VALUE,CHR(10)) THEN _F._DELIMITER ELSE "").
      END.
      ASSIGN h_query:SCREEN-VALUE = RIGHT-TRIM(tmpString)
             _F._LIST-ITEM-PAIRS  = h_query:SCREEN-VALUE
             _F._LIST-ITEMS       = ?.
    END.
  END.
END PROCEDURE.

PROCEDURE toolbar_check:
  DEFINE OUTPUT PARAMETER plOk AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER b_u FOR  _U.
  DEFINE BUFFER b_s FOR  _S.
  
  DEFINE VARIABLE lMenu AS LOGICAL    NO-UNDO.
  
  FOR EACH b_U WHERE b_u._window-handle = _P._window-handle
               AND   b_u._subtype       = 'toolbar':U,
      EACH b_S WHERE RECID(b_s)         = b_u._x-recid:

     lMenu = DYNAMIC-FUNCTION('getMenu':U IN b_s._handle) NO-ERROR.
     
     IF lMenu THEN 
       LEAVE.
  END.
  
  IF lMenu THEN  
  DO:
    MESSAGE 
     "This window has at least one SmartToolbar with a menu.   " SKIP
     "The SmartToolbar must be removed or its menu option turned off" SKIP 
     "before a menubar can be created with this tool."  
       VIEW-AS ALERT-BOX INFORMATION.
  END. /* if valid-handle h_self:menu-bar */
  
  plOk = NOT lMenu.

END.

PROCEDURE ttl_color_change:
  DEF VAR sav_bgc AS INT NO-UNDO.
  DEF VAR sav_fgc AS INT NO-UNDO.
  DEF VAR sep_fgc AS INT NO-UNDO.
  
  ASSIGN sav_bgc = _L._TITLE-BGCOLOR
         sav_fgc = _L._TITLE-FGCOLOR.
               
  RUN adecomm/_chscolr.p (INPUT "Choose Title Color",
                          INPUT (IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U
                          THEN "Frame Title Color not supported under Windows."
                          ELSE ""),
                          INPUT FALSE,
                          INPUT ?, 
                          INPUT ?,  
                          INPUT ?,
                       INPUT-OUTPUT _L._TITLE-BGCOLOR,
                          INPUT-OUTPUT _L._TITLE-FGCOLOR,
                          INPUT-OUTPUT sep_fgc,
                          OUTPUT stupid).
                          
  IF _L._LO-NAME = "Master Layout" THEN DO:
    FOR EACH sync_L WHERE sync_L._u-recid = _L._u-recid AND
                          sync_L._LO-NAME NE _L._LO-NAME:
      IF sync_L._TITLE-BGCOLOR = sav_bgc THEN sync_L._TITLE-BGCOLOR = _L._TITLE-BGCOLOR.
      IF sync_L._TITLE-FGCOLOR = sav_fgc THEN sync_L._TITLE-FGCOLOR = _L._TITLE-FGCOLOR.
    END.
  END.                          
END PROCEDURE.

/* VIRTUAL DIMENSION CHANGE */
/*     Only Windows, dialog-boxes, and *scrollable* frame have virtual dimensions */
PROCEDURE vir_height_change.
  DEFINE VARIABLE new-height AS DECIMAL DECIMALS 2.
  DEFINE VARIABLE toosmall   AS LOGICAL            INITIAL FALSE.
  DEFINE VARIABLE err-msg    AS CHAR               INITIAL ?.
  
  new-height = DECIMAL(SELF:SCREEN-VALUE).

  IF new-height < 1 THEN /* This msg will get overwritten if height_check fails */
    ASSIGN
       new-height = 1 
       err-msg    = "Minimum VIRTUAL-HEIGHT of a " + _U._TYPE + " is 1.".  
       
  /* Check against Progress maximum of 320 */
  IF new-height > 320 THEN
    ASSIGN 
      new-height = 320
      err-msg    = "Maximum VIRTUAL-HEIGHT is 320.".

  /* Check Minima */  
  /* SHOULD THIS PROC ONLY BE RUN ON FRAMES? */
  RUN height_check (INPUT        _U._HANDLE,      /* Returns new-height as minimum if its too small */
                    INPUT        _L._ROW-MULT,
                    INPUT-OUTPUT new-height,
                    OUTPUT       toosmall).
  IF toosmall THEN                         /* Check results of height_check */
    err-msg = "The VIRTUAL-HEIGHT of a " + _U._TYPE + " may not be smaller than~n" +
              "its contents.  Minimum VIRTUAL-HEIGHT is " + STRING(new-height) + ".".

       
  /* Update all fields and screen values */                                     
  ASSIGN
     _L._VIRTUAL-HEIGHT = new-height        
     SELF:SCREEN-VALUE  = STRING(new-height)            
     /* Phys Height must be adjusted if V-height is smaller */
     _L._HEIGHT         = MIN (_L._HEIGHT, new-height)  
     h_hgt:SCREEN-VALUE = STRING (_L._HEIGHT).

  /* Display the error message */
  IF err-msg NE ? THEN DO:
    MESSAGE err-msg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN ERROR.
  END.
     
END PROCEDURE. /* vir_height_change */

PROCEDURE vir_width_change.
  DEFINE VARIABLE new-width AS DECIMAL DECIMALS 2.
  DEFINE VARIABLE toosmall  AS LOGICAL            INIT FALSE.
  DEFINE VARIABLE err-msg   AS CHAR               INIT ?.

  new-width = DECIMAL (SELF:SCREEN-VALUE).
                         
  /* Windows and dialog-boxes can't be narrower than 12 (see height_change) */
  IF CAN-DO ("WINDOW,DIALOG-BOX", _U._TYPE) AND new-width < 12 THEN 
    ASSIGN
       new-width = 12 
       err-msg    = "Minimum VIRTUAL-WIDTH of a " + _U._TYPE + " is 12.".
  ELSE IF new-width < 1 THEN /* Frames must be > 1 wide */
    ASSIGN
       new-width = 1
       err-msg    = "Minimum VIRTUAL-WIDTH of a " + _U._TYPE + " is 1.".
       
  /* Check against Progress maximum of 320 */
  IF new-width > 320 THEN
    ASSIGN new-width = 320
           err-msg   = "Maximum VIRTUAL-WIDTH is 320.".
                                                       
  /* Check against child widget width constraints */
  RUN width_check (INPUT _U._HANDLE, 
                   INPUT _L._COL-MULT,
                   INPUT-OUTPUT new-width,
                   OUTPUT toosmall).
  IF toosmall THEN
    err-msg = "The VIRTUAL-WIDTH of a " + _U._TYPE + " may not be smaller than~n" +
              "its contents.  Minimum VIRTUAL-WIDTH is " + STRING(new-width) + ".".

  /* Update all fields and screen values */                                     
  ASSIGN
     _L._VIRTUAL-WIDTH = new-width
     SELF:SCREEN-VALUE = STRING(new-width)            
     /* Phys width must be adjusted if V-width is smaller */
     _L._WIDTH           = MIN (_L._WIDTH, new-width)  
     h_wdth:SCREEN-VALUE = STRING (_L._WIDTH).
     
  /* Display the error message */
  IF err-msg NE ? THEN DO:
    MESSAGE err-msg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN ERROR.
  END.
     
END PROCEDURE. /* vir_width_change */

/* PHYSICAL DIMENSION CHANGE */

PROCEDURE height_change.     
  DEFINE VARIABLE new-height AS DECIMAL DECIMALS 2.
  DEFINE VARIABLE upr-limit  AS DECIMAL DECIMALS 2.
  DEFINE VARIABLE toosmall   AS LOGICAL            INIT FALSE.
  DEFINE VARIABLE err-msg    AS CHAR               INIT ?.
  
  new-height = DECIMAL(SELF:SCREEN-VALUE).
  
  /* Must be greater than 0 */
  IF new-height <= 0 THEN 
    ASSIGN 
      new-height = 1
      err-msg    = "Height of a " + _U._TYPE + " must be greater than 0.".
 
  /* Window/dialog-boxes can't be physically smaller than 1 high.                    */
  IF CAN-DO ("WINDOW,DIALOG-BOX", _U._TYPE) AND new-height < 1 THEN 
    ASSIGN
      new-height = 1      
      err-msg = "Height of a " + _U._TYPE + " must be 1 or greater.".
  
  /* non-scrollable frames and dialog-boxes must have height check against child widget requirements. */
  IF (_U._TYPE = "FRAME" AND AVAILABLE _C AND NOT _C._SCROLLABLE) OR
           _U._TYPE = "DIALOG-BOX" THEN DO:
      RUN height_check (INPUT        _U._HANDLE, 
                        INPUT        _L._ROW-MULT, 
                        INPUT-OUTPUT new-height,
                        OUTPUT       toosmall).    
      IF toosmall THEN DO:
        err-msg = "The HEIGHT of a " + _U._TYPE + " may not be smaller than~n" +
                  "its contents. Minimum HEIGHT is " + STRING(new-height) + ".".
      END.
    END.

  /* Check maxima */ 
  IF NOT CAN-DO("WINDOW,DIALOG-BOX,FRAME",_U._TYPE) THEN 
    upr-limit = 1 + v-hgt - DECIMAL(h_row:SCREEN-VALUE).
  ELSE IF _U._TYPE EQ "FRAME" AND NOT _U._size-to-parent THEN
    upr-limit = 1 + v-hgt - (IF DECIMAL(h_row:SCREEN-VALUE) NE ?  /* v-hgt = PARENT'S virtual-width */
                             THEN DECIMAL(h_row:SCREEN-VALUE)
                             ELSE 1).
  ELSE /* Window/dialog Box or SIZE-TO-PARENT frames */
    upr-limit = 320.
            
  IF new-height > upr-limit THEN 
    ASSIGN
      new-height = upr-limit
      err-msg    = "Height must be less than or equal to " + STRING(upr-limit) + ".".

  /* Update the virtual if necessary */
  IF AVAILABLE _C AND h_v-hgt NE ? THEN
    ASSIGN _L._VIRTUAL-HEIGHT   = IF _U._TYPE = "FRAME" AND NOT _C._SCROLLABLE THEN
                                    new-height ELSE MAX (new-height, _L._VIRTUAL-HEIGHT)
           h_v-hgt:SCREEN-VALUE = STRING (_L._VIRTUAL-HEIGHT).
           
  /* TTY minimums */
  IF _U._TYPE = "SLIDER" AND NOT _L._WIN-TYPE AND new-height < 2 THEN
    ASSIGN new-height = 2
           err-msg = "Character mode sliders are 2 characters high.":U.
                     
  IF _U._TYPE = "BROWSE":U THEN do:
    IF new-height < h_self:MIN-HEIGHT-CHARS THEN DO:
      MESSAGE _U._NAME "must be at least" h_self:MIN-HEIGHT-CHARS
         "characters high.  Resizing..." VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      ASSIGN new-height    = h_self:MIN-HEIGHT-CHARS
             h_self:HEIGHT = new-height.
    END.  /* if new height less than min height */
    ELSE h_self:HEIGHT = new-height.
  END.  /* if Browse and new height less than min height */

  /* Update the height field and fill-in */
  ASSIGN
    _L._HEIGHT        = new-height
    SELF:SCREEN-VALUE = STRING (new-height).
  
  /* Display an error message if there is one */
  IF err-msg NE ? THEN DO:
    MESSAGE err-msg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN ERROR.
  END.
    
END PROCEDURE. /* height_change */

PROCEDURE width_change.
  DEFINE VARIABLE minbrw-height AS DECIMAL.
  DEFINE VARIABLE new-width     AS DECIMAL DECIMALS 2.
  DEFINE VARIABLE upr-limit     AS DECIMAL DECIMALS 2.
  DEFINE VARIABLE toosmall      AS LOGICAL            INIT FALSE.
  DEFINE VARIABLE err-msg       AS CHAR               INIT ?.

  new-width = DECIMAL (SELF:SCREEN-VALUE).
          
  /* Widgets can't be smaller than 0 width. */
  IF new-width <= 0 THEN /* This msg will be overwritten if other tests fail. */
    ASSIGN 
      new-width = 1
      err-msg   = "Width of a " + _U._TYPE + " must be greater than 0.".
      
  /* Window/dlg-boxes can't be smaller than 12 width. */
  IF CAN-DO ("WINDOW,DIALOG-BOX", _U._TYPE) AND new-width < 12 THEN
     ASSIGN
        err-msg   = "Width of a " + _U._TYPE + " must be 12 or greater."
        new-width = 12.

  /* non-scrollable frames AND dialog-boxes must have width check against child widget requirements. */
  IF (_U._TYPE = "FRAME" AND AVAILABLE _C AND NOT _C._SCROLLABLE) OR
           _U._TYPE = "DIALOG-BOX" THEN DO:
      RUN width_check (INPUT         _U._HANDLE, 
                        INPUT        _L._COL-MULT, 
                        INPUT-OUTPUT new-width,
                        OUTPUT       toosmall).    
      IF toosmall THEN DO:
        err-msg = "The WIDTH of a " + _U._TYPE + " may not be smaller than~n" +
                  "its contents. Minimum WIDTH is " + STRING(new-width) + ".".
      END.
    END.
  
  /* Check against maxima */
  IF NOT CAN-DO("WINDOW,DIALOG-BOX,FRAME",_U._TYPE) THEN DO:
    RUN compute_lbl_wdth.
    CASE _U._ALIGN:
      WHEN "R" THEN upr-limit = v-wdth - parent_U._HANDLE:BORDER-LEFT -      /* v-wdth is PARENT'S virtual-width */
                                parent_U._HANDLE:BORDER-RIGHT -
                                DECIMAL(h_col:SCREEN-VALUE) + _L._WIDTH.
      WHEN "C" THEN upr-limit = v-wdth - parent_U._HANDLE:BORDER-LEFT -
                                parent_U._HANDLE:BORDER-RIGHT - 
                                DECIMAL(h_col:SCREEN-VALUE) - 1.
      OTHERWISE     upr-limit = v-wdth - parent_U._HANDLE:BORDER-LEFT -
                                parent_U._HANDLE:BORDER-RIGHT - 
                                DECIMAL(h_col:SCREEN-VALUE) - lbl_wdth + 1.
    END CASE.
  END.
  ELSE IF _U._TYPE EQ "FRAME" AND NOT _U._size-to-parent THEN
     upr-limit = 1 + v-wdth - (IF DECIMAL(h_col:SCREEN-VALUE) NE ?
                               THEN DECIMAL(h_col:SCREEN-VALUE)
                               ELSE 1).
  ELSE /* Window, Dialog-Box, or SIZE-TO-PARENT frame*/
     upr-limit = 320.
  
  IF new-width > upr-limit THEN 
    ASSIGN 
       new-width = upr-limit
       err-msg   = "Width must be less than or equal to " + STRING(upr-limit) + ".".

  /* Adjust virtual if necessary.  Width may have increased, so virt may need to, too*/
  IF AVAILABLE _C AND h_v-wdth NE ? THEN
    ASSIGN _L._VIRTUAL-WIDTH     = IF _U._TYPE = "FRAME" AND NOT _C._SCROLLABLE THEN
                                     new-width ELSE MAX (new-width, _L._VIRTUAL-WIDTH)
           h_v-wdth:SCREEN-VALUE = STRING(_L._VIRTUAL-WIDTH).

  /* TTY minimums */
  /* TTY sliders must be 9 wide for the [ ] and the slider and surrounding spaces. */
  IF _U._TYPE = "SLIDER" AND NOT _L._WIN-TYPE AND NOT _F._HORIZONTAL AND
     new-width < 9 THEN
    ASSIGN new-width = 9
           err-msg = "Character mode vertical sliders are 9 characters wide.":U.
  /* TTY toggles must be at least 3 wide, for the '[ ]' */
  ELSE IF _U._TYPE = "TOGGLE-BOX" AND NOT _L._WIN-TYPE AND
     new-width < 3 THEN
     ASSIGN new-width = 3
            err-msg   = "Character mode toggle boxes must be 3 or more characters wide.":U.
            
 /* Browse height may not big enough to handle this new width (changing 
    width may cause a horizonal scrollbar to appear), so we need to try to 
    assign it with no-error and if there is an error we need to determine what 
    the minimum height of the browse is for this width and then resize the browse
    the + 1 calculation is trying to make the browse big enough to 
    avoid an error so that we can assign the new width and determine
    what the min height of the browse needs to be to accommodate this 
    new width */
  IF _U._TYPE = "BROWSE":U THEN DO:
      ASSIGN h_self:WIDTH = new-width NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          ASSIGN h_self:HEIGHT = h_self:HEIGHT + 1
                 h_self:WIDTH  = new-width
                 minbrw-height = h_self:MIN-HEIGHT-CHARS.
          MESSAGE _U._NAME "must be at least" minbrw-height
              "characters high.  Resizing..." VIEW-AS ALERT-BOX WARNING BUTTONS OK.
          ASSIGN h_self:HEIGHT      = minbrw-height
                 h_hgt:SCREEN-VALUE = STRING(minbrw-height).
          APPLY "LEAVE":U TO h_hgt.
      END.  /* if error */
  END.  /* if browse */

  /* Update width field and fill-in */
  ASSIGN
    _L._WIDTH         = new-width
    SELF:SCREEN-VALUE = STRING(new-width).

  /* Display the error message, if we got one */
  IF err-msg NE ? THEN DO:
    MESSAGE err-msg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN ERROR.
  END.
END PROCEDURE. /* width_change */


/* PHYSICAL DIMENSION MINIMUM CHECK */

/* Procedure to check that the height of an object is large enough for its contents */
PROCEDURE height_check.
  DEFINE INPUT        PARAMETER obj-handle AS WIDGET-HANDLE            NO-UNDO.
  DEFINE INPUT        PARAMETER row-mult   AS DECIMAL       DECIMALS 2 NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER hgt        AS DECIMAL       DECIMALS 2 NO-UNDO.
  DEFINE OUTPUT       PARAMETER changed    AS LOGICAL                  NO-UNDO INITIAL FALSE.

  DEFINE VARIABLE min-height               AS DECIMAL       DECIMALS 2 NO-UNDO INIT ?.
  DEFINE VARIABLE dlg-brdr                 AS DECIMAL       DECIMALS 2 NO-UNDO.
  
  child_handle = obj-handle:FIRST-CHILD.

  IF obj-handle:TYPE = "FRAME" THEN  /* Skip the field group 'widget' */
    child_handle = child_handle:FIRST-CHILD.
  
  DO WHILE VALID-HANDLE(child_handle):
    IF child_handle:TYPE NE "DIALOG-BOX" AND child_handle:TYPE NE "WINDOW" AND 
       child_handle:HEIGHT + child_handle:ROW - 1 > ROUND (hgt * row-mult, 2)
       /* This ROUND can be taken out when ALL uib decimals vars are DECIMALS 2'd */
    THEN DO:
      hgt = (child_handle:HEIGHT + child_handle:ROW - 1) / row-mult.
      
      IF min-height EQ ? THEN
         min-height = hgt.
      ELSE IF hgt > min-height THEN
         min-height = hgt.
    END. 
    
    child_handle = child_handle:NEXT-SIBLING.       
  END.

  IF min-height NE ? THEN 
    ASSIGN 
      hgt               = min-height
      changed           = TRUE.

END PROCEDURE. /* height_check */

/* Procedure to check that the width of an object is large enough for its contents */
PROCEDURE width_check.
  DEFINE INPUT        PARAMETER obj-handle AS WIDGET-HANDLE            NO-UNDO.
  DEFINE INPUT        PARAMETER col-mult   AS DECIMAL       DECIMALS 2 NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER wdth       AS DECIMAL       DECIMALS 2 NO-UNDO.
  DEFINE OUTPUT       PARAMETER changed    AS LOGICAL                  NO-UNDO INITIAL FALSE.

  DEFINE VARIABLE     frame-rect           AS WIDGET-HANDLE            NO-UNDO.
  DEFINE VARIABLE     min-width            AS DECIMAL       DECIMALS 2 NO-UNDO INITIAL ?.
      
  child_handle = obj-handle:FIRST-CHILD.

  IF obj-handle:TYPE = "FRAME" THEN
    child_handle = child_handle:FIRST-CHILD.   /* Skip field group 'widget' */

  DO WHILE VALID-HANDLE(child_handle):
    IF child_handle:TYPE NE "DIALOG-BOX" AND child_handle:TYPE NE "WINDOW" AND 
       child_handle:WIDTH + child_handle:COLUMN - 1 > ROUND (wdth * col-mult, 2)
    THEN DO:
      
      IF child_handle:TYPE = "RECTANGLE" AND obj-handle:TYPE = "FRAME" AND
         child_handle      = _C._FRAME-BAR THEN
        ASSIGN frame-rect              = child_handle
               frame-rect:WIDTH-PIXELS = 1.        
      ELSE DO:
        wdth = (child_handle:WIDTH + child_handle:COLUMN - 1) / col-mult.

        IF min-width EQ ? THEN   /* Keep track of the largest necessary value */
           min-width = wdth.
        ELSE IF wdth > min-width THEN
           min-width = wdth.
      END. 
    END.
    child_handle = child_handle:NEXT-SIBLING.     
  END.
  
  IF min-width NE ? THEN
     ASSIGN
        wdth    = min-width
        changed = TRUE.

  IF VALID-HANDLE(frame-rect) THEN 
     frame-rect:WIDTH = wdth.
  
END PROCEDURE. /* Width_check */

PROCEDURE adjust_frame.
  ASSIGN FRAME prop_sht:HIDDEN     = TRUE 
         FRAME prop_sht:PARENT     = ACTIVE-WINDOW
         FRAME prop_sht:TITLE      = "Property Sheet - " + _U._NAME + 
                                      IF _L._LO-NAME NE "Master Layout" THEN
                                      " - Layout: " + _U._LAYOUT-NAME ELSE ""
         txt_geom:SCREEN-VALUE IN FRAME prop_sht  = " Geometry":L38
         txt_attrs:SCREEN-VALUE IN FRAME prop_sht = " Other Settings":L38
         last-tab                  = name:HANDLE IN FRAME prop_sht
         name:SENSITIVE IN FRAME prop_sht = TRUE
         name:SCREEN-VALUE         = IF _U._TYPE = "TEXT" THEN _F._INITIAL-DATA
                                                          ELSE _U._NAME
         btn_adv:SENSITIVE         = TRUE
         cur-row                   = name:ROW + 1.1.

  /* If its a database field, add the table name, and optionally the database name to
   * the widget name field */
  IF _U._DBNAME NE ? AND _F._DISPOSITION NE "LIKE":U THEN                     
      name:SCREEN-VALUE = name:SCREEN-VALUE + " (" +
                            db-tbl-name(_U._DBNAME + "." + _U._TABLE) + ")".
END PROCEDURE.  /* adjust_frame */ 

/* Generate the non-toggle attribute widgets           */
PROCEDURE create_top_stuff.
DEFINE VARIABLE hRepDesManager AS HANDLE     NO-UNDO.


TOP-STUFF:
FOR EACH _PROP WHERE _PROP._CLASS NE 1 AND
                     CAN-DO(_PROP._WIDGETS,_U._TYPE) BY _PROP._DISP-SEQ:                
  CASE _PROP._NAME:

    WHEN "LABEL" THEN DO:
      CREATE TEXT    h_label_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE. 
      CREATE FILL-IN h_label
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = name:COLUMN IN FRAME prop_sht
                  WIDTH             = 45.45
                  FORMAT            = "X(80)"
                  SIDE-LABEL-HANDLE = h_label_lbl
                  SCREEN-VALUE      = IF _U._TYPE = "{&WT-CONTROL}" THEN
                                        _U._SUBTYPE + "   (In: ":U +
                                                      _F._IMAGE-FILE + ")":U
                                      ELSE _U._LABEL
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  LABEL             = IF CAN-DO("WINDOW,FRAME,BROWSE,DIALOG-BOX",
                                        _U._TYPE)
                                        THEN "Title:":U
                                      ELSE IF _U._TYPE = "{&WT-CONTROL}"
                                        THEN "OCX:":U
                                      ELSE "Label:":U
             TRIGGERS:
               ON LEAVE PERSISTENT RUN label_change.
             END TRIGGERS.
             
      ASSIGN stupid              = h_label:MOVE-AFTER(last-tab)
             last-tab            = h_label
             h_label_lbl:HEIGHT  = 1
             h_label_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                        h_label:LABEL + " ")
             h_label_lbl:ROW     = h_label:ROW
             h_label_lbl:COLUMN  = h_label:COLUMN - h_label_lbl:WIDTH
             h_label:SENSITIVE   = _U._TYPE NE "{&WT-CONTROL}".
      IF _U._TYPE = "{&WT-CONTROL}" THEN _U._LABEL-SOURCE = "D":U.
             
      IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN DO:
        RUN compute_lbl_wdth.
        CREATE TOGGLE-BOX h_nolbl
             ASSIGN FRAME        = FRAME prop_sht:HANDLE
                    ROW          = cur-row
                    COLUMN       = 59.78
                    HEIGHT       = 1
                    WIDTH        = 14
                    LABEL        = "No-Label"
                    CHECKED      = _L._NO-LABELS
                    SENSITIVE    = TRUE
               TRIGGERS:
                 ON VALUE-CHANGED PERSISTENT RUN no_label_change.
               END TRIGGERS.
        ASSIGN stupid   = h_nolbl:MOVE-AFTER(last-tab)
               last-tab = h_nolbl.
      END. /* If not a window */
      ELSE h_label:WIDTH = name:WIDTH IN FRAME prop_sht.
      
      cur-row  = cur-row + 1.1.
    END.  /* Has a LABEL or TITLE */

    WHEN "QUERY" OR WHEN "LIST-ITEMS" THEN DO:
      IF _U._TYPE = "COMBO-BOX" OR _U._TYPE = "SELECTION-LIST" THEN DO:
        CREATE RADIO-SET h_listType
             ASSIGN FRAME         = FRAME prop_sht:HANDLE
                    ROW           = cur-row
                    HORIZONTAL    = TRUE
                    RADIO-BUTTONS = "List-Items,I,List-Item-Pairs,P"
                    COLUMN        = name:COLUMN IN FRAME prop_sht
                    SENSITIVE     = TRUE
             TRIGGERS:
               ON VALUE-CHANGED PERSISTENT RUN switchList.
             END TRIGGERS.
        /* Which do we have to display? */
        IF _F._LIST-ITEM-PAIRS NE ? AND _F._LIST-ITEM-PAIRS NE "" THEN 
          ASSIGN h_listType:SCREEN-VALUE = "P":U.
        ELSE
          ASSIGN h_listType:SCREEN-VALUE = "I":U.
   
        ASSIGN cur-row  = cur-row + 1
               stupid   = h_listType:MOVE-AFTER(last-tab)
               last-tab = h_listType.
      END.
      CREATE TEXT h_qry_lbl
             ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(12)".
      CREATE EDITOR h_query
           ASSIGN FRAME                = FRAME prop_sht:HANDLE
                  ROW                  = cur-row 
                  COLUMN               = name:COLUMN IN FRAME prop_sht
                  SCROLLBAR-VERTICAL   = TRUE
                  SCROLLBAR-HORIZONTAL = TRUE
                  RETURN-INSERTED      = TRUE
                  WIDTH                = IF _PROP._NAME = "QUERY" OR
                                          _U._TYPE = "COMBO-BOX" THEN 45 ELSE
                                          (name:WIDTH - .5)
                  FONT                 = editor_font
                  INNER-LINES          = IF SESSION:HEIGHT-PIXELS > 500 THEN 4
                                                                        ELSE 2
                  SCREEN-VALUE         = IF _PROP._NAME = "QUERY" 
                                           THEN _Q._4GLQURY 
                                           ELSE IF _U._TYPE = "RADIO-SET" THEN
                                           _F._LIST-ITEMS ELSE ""
                  SIDE-LABEL-HANDLE    = h_qry_lbl
                  LABEL                = IF _PROP._NAME = "QUERY" THEN "Query:"
                                         ELSE IF _U._TYPE = "RADIO-SET"
                                         THEN "Buttons:"
                                         ELSE IF _PROP._NAME = "LIST-ITEMS" THEN ""
                                         ELSE ""
           TRIGGERS:                            
             ON LEAVE PERSISTENT RUN query_edit.
           END TRIGGERS.
      
      IF _PROP._NAME = "LIST-ITEMS" THEN
        ASSIGN h_query:BGCOLOR = std_fillin_bgcolor
               h_query:FGCOLOR = std_fillin_fgcolor.
      ELSE ASSIGN h_query:BGCOLOR = {&READ-ONLY_BGC}.
      
      IF _U._TYPE = "COMBO-BOX" OR _U._TYPE = "SELECTION-LIST" THEN DO:
        IF  h_listType:SCREEN-VALUE = "P" THEN 
          h_query:SCREEN-VALUE = _F._LIST-ITEM-PAIRS.
        ELSE 
          h_query:SCREEN-VALUE = _F._LIST-ITEMS.
      END.
               
      ASSIGN stupid            = h_query:MOVE-AFTER(last-tab)
             last-tab          = h_query
             sav-qry           = IF _PROP._NAME = "QUERY" THEN _Q._4GLQURY
                                 ELSE _F._LIST-ITEMS
             h_qry_lbl:HEIGHT  = 1
             h_qry_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_query:LABEL + " ")
             h_qry_lbl:ROW     = h_query:ROW
             h_qry_lbl:COLUMN  = h_query:COLUMN - h_qry_lbl:WIDTH
             h_query:SENSITIVE = TRUE
             h_query:READ-ONLY = (_PROP._NAME = "QUERY").

      IF _PROP._NAME = "QUERY" THEN DO:
        CREATE BUTTON h_btn_mdfy
             ASSIGN FRAME             = FRAME prop_sht:HANDLE
                    ROW               = cur-row
                    COLUMN            = 59
                    WIDTH             = 15
                    HEIGHT            = 1.125
                    LABEL             = IF _PROP._NAME = "QUERY":U
                                          THEN "Query..." ELSE "Modify..."
                    SENSITIVE         = NOT CAN-FIND(_TRG
                                            WHERE _TRG._wRECID = RECID(_U) AND
                                                  _TRG._tEVENT = "OPEN_QUERY":U)
          TRIGGERS:
            ON CHOOSE PERSISTENT RUN query_modify.
          END TRIGGERS.
        
        ASSIGN stupid            = h_btn_mdfy:MOVE-AFTER(last-tab)
               last-tab          = h_btn_mdfy.

        IF _U._TYPE = "BROWSE":U THEN DO:
          CREATE BUTTON h_btn_flds
               ASSIGN FRAME             = FRAME prop_sht:HANDLE
                      ROW               = cur-row + 1.2
                      COLUMN            = h_btn_mdfy:COLUMN
                      WIDTH             = h_btn_mdfy:WIDTH
                      HEIGHT            = 1.125
                      LABEL             = "Fields..."
                      SENSITIVE         = h_btn_mdfy:SENSITIVE
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN field_edit.
            END TRIGGERS.
        
          ASSIGN stupid            = h_btn_flds:MOVE-AFTER(last-tab)
                 last-tab          = h_btn_flds.
        END.
      END.
      ASSIGN cur-row  = cur-row + h_query:HEIGHT + .1.
      IF CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(_U) AND
                             _TRG._tEVENT = "OPEN_QUERY":U) THEN
         RUN freeform_setup.                    
    END.  /* Has a QUERY or LIST-ITEMS */

    WHEN "INNER-LINES" THEN DO:
      CREATE TEXT h_innr-lns_lbl
             ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(12)".
      CREATE FILL-IN h_inner-lines
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = h_query:ROW + h_innr-lns_lbl:HEIGHT
                  COLUMN            = h_nolbl:COLUMN
                  WIDTH             = 11
                  DATA-TYPE         = "INTEGER"
                  FORMAT            = ">>>,>>>,>>9"
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(_F._INNER-LINES,">>>,>>>,>>9")
                  SIDE-LABEL-HANDLE = h_innr-lns_lbl
                  LABEL             = "Inner Lines:"
          TRIGGERS:
             ON LEAVE PERSISTENT RUN  inner_lines_change.
           END TRIGGERS.
          
      ASSIGN stupid                  = h_inner-lines:MOVE-AFTER(last-tab)
             last-tab                = h_inner-lines
             h_innr-lns_lbl:WIDTH    = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                         h_inner-lines:LABEL)
             h_innr-lns_lbl:ROW      = h_query:ROW
             h_innr-lns_lbl:COLUMN   = h_nolbl:COLUMN
             h_inner-lines:SENSITIVE = TRUE.
    END.
    
    WHEN "SUBTYPE" THEN DO:
      CREATE RADIO-SET h_subtype
        ASSIGN FRAME         = FRAME prop_sht:HANDLE
               ROW           = cur-row
               HORIZONTAL    = TRUE
               RADIO-BUTTONS = "Simple,SI,Drop-Down,DD,Drop-Down-List,DL"
               COLUMN        = name:COLUMN IN FRAME prop_sht
               SENSITIVE     = TRUE
          TRIGGERS:
            ON VALUE-CHANGED PERSISTENT RUN combo_subtype_change.      
          END TRIGGERS.
      
      CASE _U._SUBTYPE:
        WHEN "SIMPLE"         THEN h_subtype:SCREEN-VALUE = "SI".
        WHEN "DROP-DOWN"      THEN h_subtype:SCREEN-VALUE = "DD".
        WHEN "DROP-DOWN-LIST" THEN h_subtype:SCREEN-VALUE = "DL".
      END CASE.
      
      ASSIGN stupid                  = h_subtype:MOVE-AFTER(last-tab)
             last-tab                = h_subtype
             cur-row                 = cur-row + 1.1.
      IF _F._DATA-TYPE NE "CHARACTER":U THEN h_subtype:SENSITIVE = FALSE.
    END.  /* when subtype */
     
    WHEN "DATA-TYPE" THEN DO:
      /* sets valid list items for data type combo box base on widget type */
      CASE _U._TYPE:
          WHEN "EDITOR":U THEN valid-list = valid-data-tp-editor.
          WHEN "FILL-IN":U THEN valid-list = valid-data-tp-fill-in.
          OTHERWISE valid-list = valid-data-tp.
      END CASE.
      CREATE TEXT h_dt_lbl
             ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(10)".
      CREATE COMBO-BOX h_data-type
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = name:COLUMN IN FRAME prop_sht
                  WIDTH             = 20
                  INNER-LINES       = 6
                  FORMAT            = "X(18)"
                  SIDE-LABEL-HANDLE = h_dt_lbl
                  FGCOLOR           = std_fillin_fgcolor
                  LIST-ITEMS        = valid-list
                  SCREEN-VALUE      = _F._DATA-TYPE
                  LABEL             = "Define As:"
           TRIGGERS:
              ON VALUE-CHANGED PERSISTENT RUN data-type_change.
           END TRIGGERS.
      ASSIGN stupid                = h_data-type:MOVE-AFTER(last-tab)
             last-tab              = h_data-type
             sav-dt                = _F._DATA-TYPE
             h_dt_lbl:HEIGHT       = 1
             h_dt_lbl:WIDTH        = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_data-type:LABEL
                                        + " ")
             h_dt_lbl:ROW          = h_data-type:ROW
             h_dt_lbl:COLUMN       = h_data-type:COLUMN - h_dt_lbl:WIDTH
             h_data-type:SENSITIVE = TRUE.
                 
      IF CAN-DO("RADIO-SET,SELECTION-LIST",_U._TYPE) THEN cur-row = cur-row + 1.1.
    END.  /* Has a DATA-TYPE */

    WHEN "FORMAT" THEN DO:
      IF notAmerican AND (_F._DATA-TYPE = "Integer" OR
        _F._DATA-TYPE = "Decimal") THEN 
        RUN adecomm/_convert.p ("A-TO-N",_F._FORMAT, 
                                _numeric_separator, _numeric_decimal, 
                                OUTPUT conv_fmt).
      ELSE
        conv_fmt = _F._FORMAT.

      CREATE TEXT h_fmt_lbl
             ASSIGN FRAME = FRAME prop_sht:HANDLE.
      cur-row = cur-row + 1.1.
      CREATE FILL-IN h_format
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 13
                  WIDTH             = 45
                  HEIGHT            = 1
                  FORMAT            = "X(255)"
                  SIDE-LABEL-HANDLE = h_fmt_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = IF _U._TYPE = "COMBO-BOX" AND _U._SUBTYPE NE "DROP-DOWN-LIST" THEN ""
                                      ELSE conv_fmt
                  LABEL             = "Format:"
           TRIGGERS:
             ON LEAVE PERSISTENT RUN format_change.
           END TRIGGERS.
      ASSIGN stupid             = h_format:MOVE-AFTER(last-tab)
             last-tab           = h_format
             h_fmt_lbl:HEIGHT   = 1
             h_fmt_lbl:WIDTH    = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_format:LABEL + " ")
             h_fmt_lbl:ROW      = h_format:ROW
             h_fmt_lbl:COLUMN   = h_format:COLUMN - h_fmt_lbl:WIDTH
             h_format:SENSITIVE = TRUE.

      CREATE BUTTON h_btn_fmt
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row - .1
                  COLUMN            = 59
                  WIDTH             = 15
                  HEIGHT            = 1.125
                  LABEL             = "Format..."
                  SENSITIVE         = TRUE
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN format_professor.
            END TRIGGERS.
             
      ASSIGN stupid   = h_btn_fmt:MOVE-AFTER(last-tab)
             last-tab = h_btn_fmt
             cur-row  = cur-row + 1.1.
    END.  /* Has a FORMAT */

    WHEN "EDGE-PIXELS" THEN DO:
      IF _L._WIN-TYPE THEN DO:
        CREATE TEXT h_ep_lbl
           ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(12)". 
        CREATE FILL-IN h_edge-pixels
             ASSIGN FRAME             = FRAME prop_sht:HANDLE
                    ROW               = cur-row 
                    COLUMN            = 36
                    HEIGHT            = 1
                    WIDTH             = 9
                    DATA-TYPE         = "INTEGER"
                    FORMAT            = ">>>,>>9"
                    SIDE-LABEL-HANDLE = h_ep_lbl
                    BGCOLOR           = std_fillin_bgcolor
                    FGCOLOR           = std_fillin_fgcolor
                    SCREEN-VALUE      = STRING(_L._EDGE-PIXELS)
                    LABEL             = "Edge Pixels:"
             TRIGGERS:
               ON LEAVE PERSISTENT RUN edge_pixels_change.
             END TRIGGERS.

        ASSIGN stupid                  = h_edge-pixels:MOVE-AFTER(last-tab)
               last-tab                = h_edge-pixels
               h_ep_lbl:HEIGHT         = 1
               h_ep_lbl:WIDTH          = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                          h_edge-pixels:LABEL + " ")
               h_ep_lbl:ROW            = h_edge-pixels:ROW
               h_ep_lbl:COLUMN         = h_edge-pixels:COLUMN - h_ep_lbl:WIDTH
               h_edge-pixels:SENSITIVE = TRUE
               cur-row = cur-row + 1.1.
      END.  /* If GUI */
    END.  /* Has EDGE-PIXELS */

    WHEN "MAX-CHARS" THEN DO:
      CREATE TEXT h_mac_lbl
         ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(19)". 
      CREATE FILL-IN h_max-chars
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 57
                  HEIGHT            = 1
                  WIDTH             = 17
                  DATA-TYPE         = "INTEGER"
                  FORMAT            = ">>>,>>>,>>>"
                  SIDE-LABEL-HANDLE = h_mac_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(IF _F._MAX-CHARS = ? THEN 0 ELSE
                                             _F._MAX-CHARS)
                  LABEL             = "Maximum Characters:"
           TRIGGERS:
             ON LEAVE PERSISTENT RUN max_chars_change.
           END TRIGGERS.

      ASSIGN stupid                  = h_max-chars:MOVE-AFTER(last-tab)
             last-tab                = h_max-chars
             h_mac_lbl:HEIGHT        = 1
             h_mac_lbl:WIDTH         = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                        h_max-chars:LABEL + " ")
             h_mac_lbl:ROW           = h_max-chars:ROW
             h_mac_lbl:COLUMN        = h_max-chars:COLUMN - h_mac_lbl:WIDTH
             h_max-chars:SENSITIVE   = IF _U._TYPE = "EDITOR":U OR 
                                       (_U._TYPE = "COMBO-BOX":U AND 
                                       _U._SUBTYPE NE "DROP-DOWN-LIST":U) THEN TRUE ELSE FALSE
             cur-row = cur-row + 1.1.
    END.  /* Has MAX-CHARS */

    WHEN "MIN-VALUE" THEN DO:
      CREATE TEXT h_miv_lbl
         ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(10)". 
      CREATE FILL-IN h_min-value
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = name:COLUMN IN FRAME prop_sht
                  HEIGHT            = 1
                  WIDTH             = 22
                  DATA-TYPE         = "INTEGER"
                  FORMAT            = "->,>>>,>>>,>>9"
                  SIDE-LABEL-HANDLE = h_miv_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(_F._MIN-VALUE,"->,>>>,>>>,>>9")
                  LABEL             = "Min Value:"
            TRIGGERS:
              ON LEAVE PERSISTENT RUN min_value_change.
            END TRIGGERS.

      ASSIGN stupid                = h_min-value:MOVE-AFTER(last-tab)
             last-tab              = h_min-value
             h_miv_lbl:HEIGHT      = 1
             h_miv_lbl:WIDTH       = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                        h_min-value:LABEL + " ")
             h_miv_lbl:ROW         = h_min-value:ROW
             h_miv_lbl:COLUMN      = h_min-value:COLUMN - h_miv_lbl:WIDTH
             h_min-value:SENSITIVE = TRUE.
             
      CREATE TEXT h_mav_lbl
         ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(10)". 
      CREATE FILL-IN h_max-value
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 48
                  HEIGHT            = 1
                  WIDTH             = 22
                  DATA-TYPE         = "INTEGER"
                  FORMAT            = "->,>>>,>>>,>>9"
                  SIDE-LABEL-HANDLE = h_mav_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(_F._MAX-VALUE,"->,>>>,>>>,>>9")
                  LABEL             = "Max Value:"
            TRIGGERS:
              ON LEAVE PERSISTENT RUN max_value_change.
            END TRIGGERS.

      ASSIGN stupid                = h_max-value:MOVE-AFTER(last-tab)
             last-tab              = h_max-value
             h_mav_lbl:HEIGHT      = 1
             h_mav_lbl:WIDTH       = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                        h_max-value:LABEL + " ")
             h_mav_lbl:ROW         = h_max-value:ROW
             h_mav_lbl:COLUMN      = h_max-value:COLUMN - h_mav_lbl:WIDTH
             h_max-value:SENSITIVE = TRUE.

      CREATE TEXT h_tic_lbl
         ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(10)".         
      CREATE COMBO-BOX h_tic-marks
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row + 1
                  COLUMN            = name:COLUMN IN FRAME prop_sht
                  INNER-LINES       = 4
                  WIDTH             = 19
                  DATA-TYPE         = "CHARACTER"
                  FORMAT            = "X(19)"
                  SIDE-LABEL-HANDLE = h_tic_lbl 
                  FGCOLOR           = std_fillin_fgcolor
                  LIST-ITEMS        = "None,Top/Left,Bottom/Right,Both"
                  SCREEN-VALUE      = _F._TIC-MARKS
                  LABEL             = "Tic Marks:"
            TRIGGERS:
              ON VALUE-CHANGED PERSISTENT RUN tic_marks_change.
            END TRIGGERS.

      ASSIGN stupid                = h_tic-marks:MOVE-AFTER(last-tab)
             last-tab              = h_tic-marks
             sav-tic               = _F._TIC-MARKS
             h_tic_lbl:HEIGHT      = 1
             h_tic_lbl:WIDTH       = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                        h_tic-marks:LABEL + " ")
             h_tic_lbl:ROW         = h_tic-marks:ROW
             h_tic_lbl:COLUMN      = h_tic-marks:COLUMN - h_tic_lbl:WIDTH
             h_tic-marks:SENSITIVE = TRUE.                                 


      CREATE TEXT h_freq_lbl
         ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(10)". 
      CREATE FILL-IN h_frequency
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row + 1
                  COLUMN            = 45
                  HEIGHT            = 1
                  WIDTH             = 10
                  DATA-TYPE         = "INTEGER"
                  FORMAT            = "->>,>>9"
                  SIDE-LABEL-HANDLE = h_freq_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(_F._FREQUENCY,"->>,>>9")
                  LABEL             = "Frequency:"
            TRIGGERS:
              ON LEAVE PERSISTENT RUN frequency_change.
            END TRIGGERS.

      ASSIGN stupid                 = h_frequency:MOVE-AFTER(last-tab)
             last-tab               = h_frequency
             h_freq_lbl:HEIGHT      = 1
             h_freq_lbl:WIDTH       = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                        h_frequency:LABEL + " ")
             h_freq_lbl:ROW         = h_frequency:ROW
             h_freq_lbl:COLUMN      = h_frequency:COLUMN - h_freq_lbl:WIDTH
             h_frequency:SENSITIVE  = (IF h_tic-marks:SCREEN-VALUE NE "NONE":U THEN TRUE ELSE FALSE)
             cur-row                = cur-row + 2.1.
      
    END.  /* Has Min and Max values */

    WHEN "LOCK-COLUMNS" THEN DO:
      CREATE TEXT h_locked-cols_lbl
         ASSIGN FRAME  = FRAME prop_sht:HANDLE FORMAT = "X(16)"
                COLUMN = name:COLUMN IN FRAME prop_sht. 
      CREATE FILL-IN h_locked-cols
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  SIDE-LABEL-HANDLE = h_locked-cols_lbl
                  LABEL             = "Locked Columns:"
                  ROW               = cur-row 
                  COLUMN            = name:COLUMN IN FRAME prop_sht +
                                        FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                          h_locked-cols:LABEL + " ")
                  HEIGHT            = 1
                  WIDTH             = 9
                  DATA-TYPE         = "INTEGER"
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  FORMAT            = ">,>>>,>>9"
                  SCREEN-VALUE      = STRING(_C._NUM-LOCKED-COLUMNS,">,>>>,>>9")
            TRIGGERS:
              ON LEAVE PERSISTENT RUN lock_columns_change.
            END TRIGGERS.

      ASSIGN stupid                = h_locked-cols:MOVE-AFTER(last-tab)
             last-tab              = h_locked-cols
             h_locked-cols_lbl:HEIGHT = 1
             h_locked-cols_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                         h_locked-cols:LABEL)
             h_locked-cols_lbl:ROW    = h_locked-cols:ROW
             h_locked-cols:SENSITIVE  = TRUE.
             
      CREATE TEXT h_max-dg_lbl
         ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(15)". 
      CREATE FILL-IN h_max-dg
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = h_btn_mdfy:COLUMN
                  HEIGHT            = 1
                  WIDTH             = h_btn_mdfy:WIDTH
                  DATA-TYPE         = "INTEGER"
                  FORMAT            = ">>,>>>,>>9"
                  SIDE-LABEL-HANDLE = h_max-dg_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(_C._MAX-DATA-GUESS,">>,>>>,>>9")
                  LABEL             = "Max Data Guess:"
             TRIGGERS:
               ON LEAVE PERSISTENT RUN max_data_guess_change.
             END TRIGGERS.

      ASSIGN stupid                = h_max-dg:MOVE-AFTER(last-tab)
             last-tab              = h_max-dg
             h_max-dg_lbl:HEIGHT = 1
             h_max-dg_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                           h_max-dg:LABEL + " ")
             h_max-dg_lbl:ROW    = h_max-dg:ROW
             h_max-dg_lbl:COLUMN = h_max-dg:COLUMN - h_max-dg_lbl:WIDTH
             h_max-dg:SENSITIVE  = TRUE.
            
      cur-row = cur-row + 1.1.   
    END.  /* Has Lock Columns */
    
    WHEN "ICON" THEN DO:
      IF _L._WIN-TYPE THEN DO:
      CREATE BUTTON h_btn_up
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = cur-row
                  COLUMN           = name:COLUMN IN FRAME prop_sht
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = TRUE
             TRIGGERS:
               ON CHOOSE PERSISTENT RUN icon_change.
             END TRIGGERS.

      CREATE TEXT h_fn_txt
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  FONT             = 4
                  WIDTH            = 25
                  ROW              = cur-row + h_btn_up:HEIGHT + .1
                  COLUMN           = h_btn_up:COLUMN
                  FORMAT           = "X(50)"
                  SCREEN-VALUE     = IF _C._ICON = "" THEN "" ELSE
                                       ENTRY(NUM-ENTRIES(_C._ICON,"/"),_C._ICON,"/").             
      CREATE TEXT txt_up
           ASSIGN FRAME            = FRAME prop_sht:HANDLE 
                  HEIGHT           = h_btn_up:HEIGHT
                  WIDTH            = 15
                  ROW              = cur-row
                  COLUMN           = h_btn_up:COLUMN + h_btn_up:WIDTH + 1
                  FORMAT           = "X(11)"
                  SCREEN-VALUE     = "Icon Image".
 
      ASSIGN stupid   = h_btn_up:MOVE-AFTER(last-tab)
             last-tab = h_btn_up
             sav-iu   = _C._ICON.
             
      CREATE BUTTON h_sicon
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = cur-row
                  COLUMN           = name:COLUMN IN FRAME prop_sht + 30
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = TRUE
             TRIGGERS:
               ON CHOOSE PERSISTENT RUN sicon_change.
             END TRIGGERS.
      CREATE TEXT h_sicon_txt
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  FONT             = 4
                  WIDTH            = 25
                  ROW              = cur-row + h_sicon:HEIGHT + .1
                  COLUMN           = h_sicon:COLUMN
                  FORMAT           = "X(50)"
                  SCREEN-VALUE     = {&sicon_txt}.              
      CREATE TEXT txt_sicon
           ASSIGN FRAME            = FRAME prop_sht:HANDLE 
                  HEIGHT           = h_sicon:HEIGHT
                  WIDTH            = 20
                  ROW              = cur-row
                  COLUMN           = h_sicon:COLUMN + h_sicon:WIDTH + 1
                  FORMAT           = "X(16)"
                  SCREEN-VALUE     = "Small Icon Image".
 
      ASSIGN stupid   = h_sicon:MOVE-AFTER(last-tab)
             last-tab = h_sicon
             sav-iu2  = _C._SMALL-ICON
             cur-row  = cur-row + h_sicon:HEIGHT + h_sicon_txt:HEIGHT + 0.2.
      END.  /* IF GUI */
 
    END. /* Has icon */

    WHEN "CONTEXT-HELP" THEN DO:
      IF _L._WIN-TYPE THEN DO:
        ASSIGN cur-row = cur-row + .2.
      
        CREATE TEXT h_context-txt
          ASSIGN FRAME        = FRAME prop_sht:HANDLE
                 HEIGHT       = .77
                 WIDTH        = 72
                 FORMAT       = "X(50)"
                 ROW          = cur-row
                 COLUMN       = 2
                 SCREEN-VALUE = "Context-Sensitive Help"
                 BGCOLOR      = 1
                 FGCOLOR      = 15.

        cur-row = cur-row + h_context-txt:HEIGHT.
                     
        CREATE TOGGLE-BOX h_context-help
          ASSIGN FRAME     = FRAME prop_sht:HANDLE
                 ROW       = cur-row
                 COLUMN    = name:COLUMN
                 HEIGHT    = 1
                 WIDTH     = 20
                 LABEL     = "Context Help"
                 CHECKED   = _C._CONTEXT-HELP
                 SENSITIVE = TRUE
            TRIGGERS:
              ON VALUE-CHANGED PERSISTENT RUN context_help_change.
            END TRIGGERS.
      
        ASSIGN stupid   = h_context-help:MOVE-AFTER(last-tab)
               last-tab = h_context-help
               cur-row  = cur-row + 1.
      END.  /* if _L._WIN-TYPE - GUI */       
    END.  /* when context-help */
    
    WHEN "CONTEXT-HELP-FILE" THEN DO:  
      IF _L._WIN-TYPE THEN DO:
        CREATE TEXT h_context-hlp-fil_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(15)".
        CREATE FILL-IN h_context-help-file
          ASSIGN FRAME             = FRAME prop_sht:HANDLE
                 ROW               = cur-row
                 COLUMN            = name:COLUMN
                 HEIGHT            = 1
                 WIDTH             = name:WIDTH - 13
                 DATA-TYPE         = "CHARACTER"
                 FORMAT            = "x(79)"
                 SIDE-LABEL-HANDLE = h_context-hlp-fil_lbl 
                 LABEL             = "Help File:"
                 SCREEN-VALUE      = _C._CONTEXT-HELP-FILE
                 SENSITIVE         = TRUE
            TRIGGERS:
              ON VALUE-CHANGED PERSISTENT RUN context_help_file_change.
            END TRIGGERS.
               
        ASSIGN stupid                       = h_context-help-file:MOVE-AFTER(last-tab)
               last-tab                     = h_context-help-file
               h_context-hlp-fil_lbl:HEIGHT = 1
               h_context-hlp-fil_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                              h_context-help-file:LABEL + " ")
               h_context-hlp-fil_lbl:ROW    = h_context-help-file:ROW
               h_context-hlp-fil_lbl:COLUMN = h_context-help-file:COLUMN - h_context-hlp-fil_lbl:WIDTH.

        CREATE BUTTON h_context-help-btn
          ASSIGN FRAME     = FRAME prop_sht:HANDLE
                 ROW       = cur-row 
                 COLUMN    = h_context-help-file:COLUMN + h_context-help-file:WIDTH + 1
                 HEIGHT    = 1
                 WIDTH     = 12
                 LABEL     = "Browse..."
                 SENSITIVE = TRUE 
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN context_help_btn_choose.
            END TRIGGERS.

        ASSIGN stupid   = h_context-help-btn:MOVE-AFTER(last-tab)
               last-tab = h_context-help-btn.
             
        cur-row = cur-row + 1.
      END.  /* if _L.WIN-TYPE - GUI */
    END.  /* when context-help-file */
    
    WHEN "IMAGE-FILE" THEN DO:
      IF _L._WIN-TYPE THEN DO:
      CREATE BUTTON h_btn_up
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = cur-row
                  COLUMN           = name:COLUMN IN FRAME prop_sht
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = TRUE
             TRIGGERS:
               ON CHOOSE PERSISTENT RUN image_up_change.
             END TRIGGERS.
                 
      IF _U._TYPE NE "IMAGE" THEN
         CREATE TEXT txt_image
              ASSIGN FRAME            = FRAME prop_sht:HANDLE 
                     HEIGHT-PIXELS    = icon-hp
                     WIDTH            = FONT-TABLE:GET-TEXT-WIDTH-CHARS("Images: ")
                     ROW              = cur-row
                     COLUMN           = h_btn_up:COLUMN - txt_image:WIDTH
                     SCREEN-VALUE     = "Images:".
      CREATE TEXT txt_up
           ASSIGN FRAME            = FRAME prop_sht:HANDLE 
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH            = 6
                  ROW              = cur-row
                  COLUMN           = h_btn_up:COLUMN + h_btn_up:WIDTH + 1
                  SCREEN-VALUE     = IF _U._TYPE = "IMAGE" THEN "Image" ELSE "Up".
      CREATE TEXT h_fn_txt
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  WIDTH            = IF _U._TYPE = "IMAGE":U THEN 50 ELSE 18
                  ROW              = cur-row + h_btn_up:HEIGHT + .1
                  COLUMN           = h_btn_up:COLUMN
                  FORMAT           = "X(50)"
                  SCREEN-VALUE     = IF _F._IMAGE-FILE = "" THEN "" ELSE
                                       ENTRY(NUM-ENTRIES(_F._IMAGE-FILE,dir-del),
                                                         _F._IMAGE-FILE,dir-del).
      IF _U._TYPE NE "IMAGE" THEN DO:
        CREATE BUTTON h_btn_down
             ASSIGN FRAME            = FRAME prop_sht:HANDLE
                    ROW              = cur-row
                    COLUMN           = h_btn_up:COLUMN + 19
                    HEIGHT-PIXELS    = icon-hp
                    WIDTH-PIXELS     = icon-wp
                    SENSITIVE        = TRUE
             TRIGGERS:
               ON CHOOSE PERSISTENT RUN image_down_change.
             END TRIGGERS.
        CREATE TEXT txt_down
             ASSIGN FRAME            = FRAME prop_sht:HANDLE 
                    HEIGHT-PIXELS    = icon-hp
                    WIDTH            = 7
                    ROW              = cur-row
                    COLUMN           = h_btn_down:COLUMN + h_btn_down:WIDTH + 1
                    SCREEN-VALUE     = "Down".
        CREATE TEXT h_fn_dwn_txt
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  WIDTH            = 18
                  ROW              = cur-row + h_btn_up:HEIGHT + .1
                  COLUMN           = h_btn_down:COLUMN
                  FORMAT           = "X(50)"
                  SCREEN-VALUE     = IF _F._IMAGE-DOWN-FILE = "" THEN "" ELSE
                                       ENTRY(NUM-ENTRIES(_F._IMAGE-DOWN-FILE,dir-del),
                                                         _F._IMAGE-DOWN-FILE,dir-del).
        CREATE BUTTON h_btn_insen
             ASSIGN FRAME            = FRAME prop_sht:HANDLE
                    ROW              = cur-row
                    COLUMN           = h_btn_down:COLUMN + 19
                    HEIGHT-PIXELS    = icon-hp
                    WIDTH-PIXELS     = icon-wp
                    SENSITIVE        = TRUE
             TRIGGERS:
               ON CHOOSE PERSISTENT RUN image_insen_change.
             END TRIGGERS.
        CREATE TEXT txt_insen
             ASSIGN FRAME            = FRAME prop_sht:HANDLE 
                    HEIGHT-PIXELS    = icon-hp
                    WIDTH            = 13
                    FORMAT           = "X(14)"
                    ROW              = cur-row
                    COLUMN           = h_btn_insen:COLUMN + h_btn_insen:WIDTH + 1
                    SCREEN-VALUE     = "Insensitive".
        CREATE TEXT h_fn_ins_txt
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  WIDTH            = 18
                  ROW              = cur-row + h_btn_up:HEIGHT + .1
                  COLUMN           = h_btn_insen:COLUMN
                  FORMAT           = "X(50)"
                  SCREEN-VALUE     = IF _F._IMAGE-INSENSITIVE-FILE = "" THEN "" ELSE
                                       ENTRY(NUM-ENTRIES(
                                          _F._IMAGE-INSENSITIVE-FILE,dir-del),
                                          _F._IMAGE-INSENSITIVE-FILE,dir-del).
      END.
      
      ASSIGN stupid   = h_btn_up:MOVE-AFTER(last-tab)
             last-tab = h_btn_up
             sav-iu   = _F._IMAGE-FILE
             sav-id   = _F._IMAGE-DOWN-FILE
             sav-ii   = _F._IMAGE-INSENSITIVE-FILE
             sav-dflt = _F._DEFAULT
             cur-row  = cur-row + h_btn_up:HEIGHT + h_fn_txt:HEIGHT + .2.

      IF _U._TYPE NE "IMAGE" THEN      
        ASSIGN stupid   = h_btn_down:MOVE-AFTER(last-tab)
               stupid   = h_btn_insen:MOVE-AFTER(h_btn_down)
               last-tab = h_btn_insen.
    END. /* IF GUI */
    END. /* Has image file */
    
    WHEN "TOOLTIP" THEN DO:
      CREATE TEXT h_tooltip_lbl
         ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(15)". 
    
      CREATE FILL-IN h_tooltip
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = name:COLUMN
                  HEIGHT            = 1
                  WIDTH             = name:WIDTH
                  DATA-TYPE         = "CHARACTER"
                  FORMAT            = "X(79)"
                  SIDE-LABEL-HANDLE = h_tooltip_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = (IF _U._TOOLTIP = ? THEN "" ELSE _U._TOOLTIP)
                  LABEL             = "Tooltip:"
             TRIGGERS:
               ON LEAVE PERSISTENT RUN tooltip_change.
             END TRIGGERS.

      ASSIGN stupid                = h_tooltip:MOVE-AFTER(last-tab)
             last-tab              = h_tooltip
             h_tooltip_lbl:HEIGHT = 1
             h_tooltip_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                           h_tooltip:LABEL + " ")
             h_tooltip_lbl:ROW    = h_tooltip:ROW
             h_tooltip_lbl:COLUMN = h_tooltip:COLUMN - h_tooltip_lbl:WIDTH
             h_tooltip:SENSITIVE  = TRUE.
            
      cur-row = cur-row + 1.1.   
    
    END. /* TOOLTIP */

    WHEN "DELIMITER" THEN DO:
      CREATE TEXT h_delimiter_lbl
         ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(15)". 
    
      CREATE FILL-IN h_delimiter
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 45
                  HEIGHT            = 1
                  WIDTH             = 9
                  DATA-TYPE         = "CHARACTER"
                  FORMAT            = "X"
                  SIDE-LABEL-HANDLE = h_delimiter_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = (IF _F._delimiter = ? THEN ""
                                      ELSE IF (ASC( _F._delimiter) LE 126 AND ASC( _F._delimiter) GE 32) THEN _F._Delimiter
                                      ELSE ",":U)
                  LABEL             = "Delimiter:"
             TRIGGERS:
               ON LEAVE PERSISTENT RUN Delimiter_change.
             END TRIGGERS.

      ASSIGN stupid                = h_delimiter:MOVE-AFTER(last-tab)
             last-tab              = h_delimiter
             h_delimiter_lbl:HEIGHT = 1
             h_delimiter_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                           h_delimiter:LABEL + " ")
             h_delimiter_lbl:ROW    = h_delimiter:ROW
             h_delimiter_lbl:COLUMN = h_delimiter:COLUMN - h_delimiter_lbl:WIDTH
             h_delimiter:SENSITIVE  = IF isDynView THEN TRUE ELSE FALSE.
            
      cur-row = cur-row + 1.1.   
    
    END. /* Delimiter */
    
    WHEN "FOLDER-WIN-TO-LAUNCH" THEN DO:
      IF isDynBrow THEN DO:
        CREATE TEXT h_folder-win-to-launch_lbl
           ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(24)". 
                
        CREATE FILL-IN h_folder-win-to-launch
             ASSIGN FRAME             = FRAME prop_sht:HANDLE
                    SIDE-LABEL-HANDLE = h_folder-win-to-launch_lbl
                    LABEL             = "Folder Window To Launch:"
                    ROW               = cur-row
                    COLUMN            =  h_locked-cols:COLUMN + 2
                    HEIGHT            = 1
                    WIDTH             = 42
                    DATA-TYPE         = "CHARACTER"
                    FORMAT            = "X(100)"
                  
                    BGCOLOR           = std_fillin_bgcolor
                    FGCOLOR           = std_fillin_fgcolor
                    SCREEN-VALUE      = (IF _C._folder-window-to-launch = ? THEN ""
                                        ELSE  _C._folder-window-to-launch) 
               TRIGGERS:
                 ON LEAVE PERSISTENT RUN Folder-win-to-launch_change.
               END TRIGGERS.

        ASSIGN stupid                               = h_folder-win-to-launch:MOVE-AFTER(last-tab)
               last-tab                             = h_folder-win-to-launch
               h_folder-win-to-launch_lbl:HEIGHT = 1
               h_folder-win-to-launch_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_folder-win-to-launch:LABEL + " ")
               h_folder-win-to-launch_lbl:ROW    = h_folder-win-to-launch:ROW
               h_folder-win-to-launch_lbl:COLUMN = h_folder-win-to-launch:COLUMN - h_folder-win-to-launch_lbl:WIDTH
               h_folder-win-to-launch:SENSITIVE  = TRUE.
            
        cur-row = cur-row + 1.1. 
      END.
    
    END. /* FOLDER WINDOW TO LAUNCH */

    WHEN "window-title-field" THEN DO:
      IF isDynBrow OR isDynView THEN DO:
        CREATE TEXT h_window-title-field_lbl
           ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(19)". 
                
        CREATE FILL-IN h_window-title-field
             ASSIGN FRAME             = FRAME prop_sht:HANDLE
                    SIDE-LABEL-HANDLE = h_window-title-field_lbl
                    LABEL             = "Window Title Field:"
                    ROW               = cur-row
                    COLUMN            =  FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                            "Custom Super Proc:" + " ") + 3.4
                    HEIGHT            = 1
                    WIDTH             = 51
                    DATA-TYPE         = "CHARACTER"
                    FORMAT            = "X(100)"
                  
                    BGCOLOR           = std_fillin_bgcolor
                    FGCOLOR           = std_fillin_fgcolor
                    SCREEN-VALUE      = (IF _C._window-title-field = ? THEN ""
                                        ELSE  _C._window-title-field)
               TRIGGERS:
                 ON LEAVE PERSISTENT RUN Window-title-field_change.
               END TRIGGERS.

        ASSIGN stupid                               = h_window-title-field:MOVE-AFTER(last-tab)
               last-tab                             = h_window-title-field
               h_window-title-field_lbl:HEIGHT = 1
               h_window-title-field_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_window-title-field:LABEL + " ")
               h_window-title-field_lbl:ROW    = h_window-title-field:ROW
               h_window-title-field_lbl:COLUMN = h_window-title-field:COLUMN - h_window-title-field_lbl:WIDTH
               h_window-title-field:SENSITIVE  = TRUE.
            
        cur-row = cur-row + 1.1.   
      END. /* If it is a Dynamics Browse or Viewer */
    END. /* window title field */

    WHEN "CUSTOM-SUPER-PROC" THEN DO:
      IF (isDynBrow OR isDynView) AND _DynamicsIsRunning THEN 
      DO:
        CREATE TEXT h_CUSTOM-SUPER-PROC_lbl
           ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(25)". 
                
        CREATE FILL-IN h_CUSTOM-SUPER-PROC
             ASSIGN FRAME             = FRAME prop_sht:HANDLE
                    SIDE-LABEL-HANDLE = h_CUSTOM-SUPER-PROC_lbl
                    LABEL             = "Custom Super Proc:"
                    ROW               = cur-row
                    COLUMN            =  h_window-title-field:COLUMN 
                    HEIGHT            = 1
                    WIDTH             = 41
                    DATA-TYPE         = "CHARACTER"
                    FORMAT            = "X(100)"
                    BGCOLOR           = std_fillin_bgcolor
                    FGCOLOR           = std_fillin_fgcolor
                    .
        
       CREATE BUTTON h_CUSTOM-SUPER-PROC_btn
             ASSIGN FRAME             = FRAME prop_sht:HANDLE
                    LABEL             = "Lookup"
                    ROW               = cur-row
                    COLUMN            =  h_CUSTOM-SUPER-PROC:COLUMN + h_CUSTOM-SUPER-PROC:WIDTH
                    HEIGHT            = 1.14
                    WIDTH             = 5
                    SENSITIVE         = TRUE
                    TOOLTIP           = "Lookup custom super procedure"
               TRIGGERS:
                 ON CHOOSE PERSISTENT RUN CUSTOM-SUPER-PROC_change.
               END TRIGGERS.
       h_CUSTOM-SUPER-PROC_btn:LOAD-IMAGE("ry/img/afbinos.gif":U).

       ASSIGN stupid                               = h_CUSTOM-SUPER-PROC_btn:MOVE-AFTER(last-tab)
              last-tab                             = h_CUSTOM-SUPER-PROC_btn.

       CREATE BUTTON h_CUSTOM-SUPER-PROC_btnd
              ASSIGN FRAME             = FRAME prop_sht:HANDLE
                     LABEL             = "Clear"
                     ROW               = cur-row
                     COLUMN            =  h_CUSTOM-SUPER-PROC:COLUMN + h_CUSTOM-SUPER-PROC:WIDTH + h_CUSTOM-SUPER-PROC_btn:WIDTH + .4
                     HEIGHT            = 1.14
                     WIDTH             = 5
                     SENSITIVE         = TRUE
                     TOOLTIP           = "Clear custom super procedure"
               TRIGGERS:
                 ON CHOOSE PERSISTENT RUN CUSTOM-SUPER-PROC_clear.
               END TRIGGERS.
        h_CUSTOM-SUPER-PROC_btnd:LOAD-IMAGE("ry/img/objectcancel.bmp":U).

        ASSIGN stupid                               = h_CUSTOM-SUPER-PROC_btnd:MOVE-AFTER(last-tab)
               last-tab                             = h_CUSTOM-SUPER-PROC_btnd
               h_CUSTOM-SUPER-PROC_lbl:HEIGHT = 1
               h_CUSTOM-SUPER-PROC_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_CUSTOM-SUPER-PROC:LABEL + " ")
               h_CUSTOM-SUPER-PROC_lbl:ROW    = h_CUSTOM-SUPER-PROC:ROW
               h_CUSTOM-SUPER-PROC_lbl:COLUMN = h_CUSTOM-SUPER-PROC:COLUMN - h_CUSTOM-SUPER-PROC_lbl:WIDTH
               h_CUSTOM-SUPER-PROC:SENSITIVE  = FALSE.
            
        cur-row = cur-row + 1.1.   
        IF _C._CUSTOM-SUPER-PROC = ""  THEN
        DO:
           hRepDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
           /* Retrieve the object for the current existing object opened in the appBuilder */
           RUN retrieveDesignObject IN hRepDesManager ( INPUT  _P.object_filename,
                                                        INPUT  "",  /* Get default result Code */
                                                        OUTPUT TABLE ttObject ,
                                                        OUTPUT TABLE ttPage,
                                                        OUTPUT TABLE ttLink,
                                                        OUTPUT TABLE ttUiEvent,
                                                        OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
           FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = _P.object_filename 
                                 AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
           IF AVAIL ttObject THEN
             h_CUSTOM-SUPER-PROC:SCREEN-VALUE =  ttObject.tCustomSuperprocedure .
        END.
        ELSE IF _C._CUSTOM-SUPER-PROC <> ? THEN
        DO:
           RUN adecomm/_relname.p (_C._CUSTOM-SUPER-PROC, "",OUTPUT cCustom_Super_proc).
           h_CUSTOM-SUPER-PROC:SCREEN-VALUE = cCustom_Super_proc.
        END.
            
      END. /* IF DynBrow or DynView */
    END. /* CUSTOM SUPER PROCEDURE */

    WHEN "CONTEXT-HELP-ID" THEN DO:
      IF _L._WIN-TYPE THEN DO:
        CREATE TEXT h_context-hlp-id_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(15)".
        CREATE FILL-IN h_context-help-id
          ASSIGN FRAME             = FRAME prop_sht:HANDLE
                 ROW               = cur-row
                 COLUMN            = name:COLUMN
                 HEIGHT            = 1
                 WIDTH             = 18
                 FONT              = 0
                 DATA-TYPE         = "INTEGER"
                 FORMAT            = ">>>>>>>>9"
                 SIDE-LABEL-HANDLE = h_context-hlp-id_lbl 
                 LABEL             = "Help ID:"
                 SCREEN-VALUE      = STRING(_U._CONTEXT-HELP-ID)
                 SENSITIVE         = TRUE
            TRIGGERS:     
              ON VALUE-CHANGED PERSISTENT RUN context_help_id_change.
            END TRIGGERS.
        
        ASSIGN stupid                       = h_context-help-id:MOVE-AFTER(last-tab)
               last-tab                     = h_context-help-id
               h_context-hlp-id_lbl:HEIGHT = 1
               h_context-hlp-id_lbl:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                              h_context-help-id:LABEL + " ")
               h_context-hlp-id_lbl:ROW    = h_context-help-id:ROW
               h_context-hlp-id_lbl:COLUMN = h_context-help-id:COLUMN - h_context-hlp-id_lbl:WIDTH.

        IF NOT CAN-DO("COMBO-BOX,SELECTION-LIST,RADIO-SET":U,_U._TYPE)
            THEN cur-row = cur-row + 1.1.

      END.  /* if _L._WIN-TYPE - GUI */
    END.  /* CONTEXT-HELP-ID */
    
    WHEN "COLOR" THEN DO:
      ASSIGN txt_geom:ROW              = cur-row + IF SESSION:HEIGHT > 18.5 OR
                                                      _U._TYPE NE "FRAME":U
                                                   THEN .4 ELSE .2
             cur-row                   = cur-row + IF SESSION:HEIGHT > 18.5 OR
                                                      _U._TYPE NE "FRAME":U
                                                   THEN 1.27 ELSE 1.07
             btn_color:HEIGHT-PIXELS   = icon-hp
             btn_color:WIDTH-PIXELS    = icon-wp
             btn_color:TOOLTIP         = "Color"
             btn_color:SENSITIVE       = _L._WIN-TYPE.
    END.  /* Has Color */
    
    WHEN "FONT" THEN DO:
      CREATE BUTTON h_btn_font
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = btn_color:ROW + btn_color:HEIGHT + .25
                  COLUMN           = btn_color:COLUMN
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = _L._WIN-TYPE
                  TOOLTIP          = "Font"
              TRIGGERS:
                 ON CHOOSE PERSISTENT RUN font_edit.
              END TRIGGERS.
      ASSIGN stupid = h_btn_font:LOAD-IMAGE({&ADEICON-DIR} + "font1-u" +
                        "{&BITMAP-EXT}",2,2,32,32).
    END. /* Has Font */
         
    WHEN "POP-UP" THEN DO:
      FIND x_U WHERE x_U._parent-recid = RECID(_U) AND
                     x_U._TYPE = "MENU" AND
                     x_U._SUBTYPE = "POPUP-MENU" NO-ERROR.
      CREATE BUTTON h_btn_popup
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = btn_color:ROW + 2 * btn_color:HEIGHT + .5
                  COLUMN           = btn_color:COLUMN
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = TRUE
                  TOOLTIP          = "Popup" + (IF AVAILABLE x_U THEN " Menu (Defined)" ELSE " Menu")
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN popup_menu_change.
            END TRIGGERS.
            
      IF _U._TYPE = "{&WT-CONTROL}" THEN
        h_btn_popup:ROW = btn_color:ROW + btn_color:HEIGHT + .25.
      ASSIGN stupid = h_btn_popup:LOAD-IMAGE({&ADEICON-DIR} + "popup-u" +
                                  "{&BITMAP-EXT}",2,2,32,32)
             stupid = h_btn_popup:LOAD-IMAGE-INSENSITIVE({&ADEICON-DIR} + "popup-i" +
                                  "{&BITMAP-EXT}",2,2,32,32)
      .
    END. /* Has Popup */

    WHEN "TRANS-ATTRS" THEN DO:
      CREATE BUTTON h_btn_trans
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = btn_color:ROW + (IF _U._TYPE NE "TEXT" THEN 3
                                                      ELSE 2) * (btn_color:HEIGHT + .25)
                  COLUMN           = btn_color:COLUMN
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = TRUE
                  TOOLTIP          = "Translation Attributes"
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN adeuib/_attredt.w (h_self, ?).
            END TRIGGERS.
      ASSIGN stupid         = h_btn_trans:LOAD-IMAGE({&ADEICON-DIR} + "trans-u" +
                                          "{&BITMAP-EXT}",2,2,32,32)
             stupid         = h_btn_trans:LOAD-IMAGE-INSENSITIVE({&ADEICON-DIR} +
                                          "trans-i" + "{&BITMAP-EXT}",2,2,32,32).
    END.  /* Has translation attributes */

    WHEN "DB-FIELD" THEN DO:
      CREATE BUTTON h_btn_dbfld
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = btn_color:ROW + 4 * btn_color:HEIGHT + 1
                  COLUMN           = btn_color:COLUMN
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = TRUE
                  TOOLTIP          = "Database Field"
           TRIGGERS:
             ON CHOOSE PERSISTENT RUN db_field_selection.
           END TRIGGERS.
           
      ASSIGN stupid = h_btn_dbfld:LOAD-IMAGE({&ADEICON-DIR} + "flds-u" +
                                 "{&BITMAP-EXT}",2,2,32,32)
      .
    END.  /* Has dbfield */
    
    WHEN "MENU-BAR" THEN DO:
      FIND x_U WHERE RECID(x_U) = _C._menu-recid NO-ERROR.
      CREATE BUTTON h_btn_menu-bar
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = btn_color:ROW + 4 * btn_color:HEIGHT + 1
                  COLUMN           = btn_color:COLUMN
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = TRUE
                  TOOLTIP          = "Menu Bar" + (IF AVAILABLE x_U THEN " (Defined)" ELSE "")
           TRIGGERS:
             ON CHOOSE PERSISTENT RUN menu_bar_change.
           END TRIGGERS.
      ASSIGN stupid = h_btn_menu-bar:LOAD-IMAGE({&ADEICON-DIR} + "menu-u" +
                                    "{&BITMAP-EXT}",2,2,32,32)
             stupid = h_btn_menu-bar:LOAD-IMAGE-INSENSITIVE({&ADEICON-DIR} + "menu-i" +
                                    "{&BITMAP-EXT}",2,2,32,32)
      .
    END.  /* Has menu bar */

    WHEN "TITLE-COLOR" THEN DO:
      CREATE BUTTON h_btn_ttl_clr
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = btn_color:ROW + 4 * btn_color:HEIGHT + 1
                  COLUMN           = btn_color:COLUMN
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = _L._WIN-TYPE
                  TOOLTIP          = "Title Color"
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN ttl_color_change.
            END TRIGGERS.
      ASSIGN stupid           = h_btn_ttl_clr:LOAD-IMAGE({&ADEICON-DIR} + "color2-u" +
                                             "{&BITMAP-EXT}",2,2,32,32)
      .
    END.  /* Has title bar */

    WHEN "COLUMN" THEN DO:
      /* Adjust the column position according to alignment type                  */

      /* First force alignment to "L" if column-labels */
      IF AVAILABLE parent_U THEN DO:
        IF parent_U._TYPE = "FRAME" AND NOT parent_C._SIDE-LABELS AND
           NOT parent_L._NO-LABELS THEN _U._ALIGN = "L".
      END.
      
      CASE _U._ALIGN:
        WHEN "R"  THEN xpos = _L._COL - 1 + _L._WIDTH.
        WHEN "C"  THEN xpos = _L._COL - 2.
        OTHERWISE
          /* NOTE: lbl_wdth was computed in h_label section */
          xpos = IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND parent_C._SIDE-LABELS THEN
                      /* SIDE-LABELS */  (_L._COL - lbl_wdth)
                 ELSE IF parent_U._TYPE = "FRAME" AND NOT parent_C._SIDE-LABELS AND
                      NOT parent_L._NO-LABELS THEN
                      /* COLUMN LABELS */ (_L._COL - MAX(0, lbl_wdth - _L._WIDTH))
                 ELSE _L._COL.
      END.  /* Case */
           
      CREATE TEXT h_col_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE. 
      CREATE FILL-IN h_col
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = name:COLUMN IN FRAME prop_sht
                  HEIGHT            = 1
                  WIDTH             = IF SESSION:PIXELS-PER-COL = 5 THEN 11 ELSE 9
                  DATA-TYPE         = "DECIMAL"
                  FORMAT            = IF CAN-DO("WINDOW,DIALOG-BOX", _U._TYPE) THEN "->>9.99" 
                                                                               ELSE ">>9.99"
                  SIDE-LABEL-HANDLE = h_col_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = IF xpos NE ? THEN STRING(xpos) ELSE "?"
                  LABEL             = "Column:"
            TRIGGERS:
              ON LEAVE PERSISTENT RUN column_change.
            END TRIGGERS.
      ASSIGN stupid            = h_col:MOVE-AFTER(last-tab)
             last-tab          = h_col
             h_col_lbl:HEIGHT  = 1
             h_col_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_col:LABEL + " ")
             h_col_lbl:ROW     = h_col:ROW
             h_col_lbl:COLUMN  = h_col:COLUMN - h_col_lbl:WIDTH
             h_col:SENSITIVE   = NOT _U._size-to-parent.

      CREATE TEXT h_row_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE. 
      CREATE FILL-IN h_row
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row + 1.1
                  COLUMN            = name:COLUMN IN FRAME prop_sht
                  HEIGHT            = 1
                  WIDTH             = h_col:WIDTH
                  DATA-TYPE         = "DECIMAL"
                  FORMAT            = IF CAN-DO("WINDOW,DIALOG-BOX", _U._TYPE) THEN "->>9.99" 
                                                                 ELSE ">>9.99"
                  SIDE-LABEL-HANDLE = h_row_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = IF _L._ROW NE ? THEN STRING(_L._ROW - col-lbl-adj)
                                                      ELSE "?"
                  LABEL             = "Row:"
            TRIGGERS:
              ON LEAVE PERSISTENT RUN row_change.
            END TRIGGERS.
      ASSIGN stupid            = h_row:MOVE-AFTER(last-tab)
             last-tab          = h_row
             h_row_lbl:HEIGHT  = 1
             h_row_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_row:LABEL + " ")
             h_row_lbl:ROW     = h_row:ROW
             h_row_lbl:COLUMN  = h_row:COLUMN - h_row_lbl:WIDTH
             h_row:SENSITIVE   = NOT _U._size-to-parent.
    END.  /* Has column and ROW */

    WHEN "WIDTH" THEN DO:
      CREATE TEXT h_wdth_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE. 
      CREATE FILL-IN h_wdth
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 36
                  HEIGHT            = 1
                  WIDTH             = h_col:WIDTH
                  DATA-TYPE         = "DECIMAL"
                  FORMAT            = ">>9.99"
                  SIDE-LABEL-HANDLE = h_wdth_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(_L._WIDTH)
                  LABEL             = "Width:"
            TRIGGERS:
              ON LEAVE PERSISTENT RUN width_change.
            END TRIGGERS.
      ASSIGN stupid             = h_wdth:MOVE-AFTER(last-tab)
             last-tab           = h_wdth
             h_wdth_lbl:HEIGHT  = 1
             h_wdth_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_wdth:LABEL + " ")
             h_wdth_lbl:ROW     = h_wdth:ROW
             h_wdth_lbl:COLUMN  = h_wdth:COLUMN - h_wdth_lbl:WIDTH
             h_wdth:SENSITIVE   = TRUE.

      CREATE TEXT h_hgt_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE. 
      CREATE FILL-IN h_hgt
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row + 1.1
                  COLUMN            = h_wdth:COLUMN
                  HEIGHT            = 1
                  WIDTH             = h_col:WIDTH
                  DATA-TYPE         = "DECIMAL"
                  FORMAT            = ">>9.99"
                  SIDE-LABEL-HANDLE = h_hgt_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = IF _U._TYPE = "COMBO-BOX":U THEN
                                           STRING(_U._HANDLE:HEIGHT)
                                      ELSE STRING(_L._HEIGHT)
                  LABEL             = "Height:"
            TRIGGERS:
              ON LEAVE PERSISTENT  RUN height_change.
            END TRIGGERS.
      ASSIGN stupid            = h_hgt:MOVE-AFTER(last-tab)
             last-tab          = h_hgt
             h_hgt_lbl:HEIGHT  = 1
             h_hgt_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_hgt:LABEL + " ")
             h_hgt_lbl:ROW     = h_hgt:ROW
             h_hgt_lbl:COLUMN  = h_hgt:COLUMN - h_hgt_lbl:WIDTH.
      
      IF _U._TYPE = "COMBO-BOX" AND _U._SUBTYPE NE "SIMPLE" THEN
        h_hgt:SENSITIVE = FALSE.
      ELSE h_hgt:SENSITIVE = TRUE.
             
      /* Disable the height fill-in for TTY mode Combo-boxes, toggle-boxes, buttons, 
       * text, and fill-ins. */
      IF NOT _L._WIN-TYPE AND CAN-DO ("COMBO-BOX,TOGGLE-BOX,BUTTON,TEXT,FILL-IN", _U._TYPE) THEN
          h_hgt:SENSITIVE = FALSE.
          
     END.  /* Has width and height */
     
     WHEN "ROW-HEIGHT" THEN DO:
       CREATE TEXT h_row-hgt_lbl ASSIGN FRAME  = FRAME prop_sht:HANDLE
                                        FORMAT = "X(11)".
       CREATE FILL-IN h_row-hgt
            ASSIGN FRAME             = FRAME prop_sht:HANDLE
                   ROW               = cur-row + 2.2
                   COLUMN            = h_wdth:COLUMN
                   HEIGHT            = 1
                   WIDTH             = h_col:WIDTH
                   DATA-TYPE         = "DECIMAL"
                   FORMAT            = ">>9.99"
                   SIDE-LABEL-HANDLE = h_row-hgt_lbl
                   BGCOLOR           = std_fillin_bgcolor
                   FGCOLOR           = std_fillin_fgcolor
                   SCREEN-VALUE      = IF _C._ROW-HEIGHT = 0.0 THEN
                                         STRING(h_self:ROW-HEIGHT)
                                       ELSE STRING(_C._ROW-HEIGHT)
                   LABEL             = "Row Height:"
             TRIGGERS:
               ON LEAVE PERSISTENT  RUN row-height_change.
             END TRIGGERS.
       ASSIGN stupid                = h_row-hgt:MOVE-AFTER(last-tab)
              last-tab              = h_row-hgt
              h_row-hgt_lbl:HEIGHT  = 1
              h_row-hgt_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_row-hgt:LABEL + " ")
              h_row-hgt_lbl:ROW     = h_row-hgt:ROW
              h_row-hgt_lbl:COLUMN  = h_row-hgt:COLUMN - h_row-hgt_lbl:WIDTH
              h_row-hgt:SENSITIVE   = YES.
              cur-row               = cur-row + 1.1.

       /* Disable the row height for TTY mode. */
       IF NOT _L._WIN-TYPE THEN h_row-hgt:SENSITIVE = FALSE.         
     END.  /* Has row height */
    
     WHEN "ALIGN" THEN DO:
       DEFINE VAR radio-btns AS CHAR INITIAL "Left-Align,L,Right-Align,R".
       IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN
         radio-btns = "Left-Align,L,Colon-Align,C,Right-Align,R".
       ELSE IF _U._ALIGN = "C":U THEN 
         _U._ALIGN = "L":U.

       CREATE RADIO-SET h_align
         ASSIGN FRAME         = FRAME prop_sht:HANDLE
                ROW           = cur-row - (IF _U._TYPE = "BROWSE" THEN 1.1 ELSE 0)
                COLUMN        = 55
                WIDTH         = 16
                RADIO-BUTTONS = radio-btns
                HEIGHT        = IF SESSION:WINDOW-SYSTEM = "OSF/MOTIF" AND
                                  CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN 3.5 
                                  ELSE 2.25
                SCREEN-VALUE  = _U._ALIGN
                SENSITIVE     = TRUE
         TRIGGERS:
           ON VALUE-CHANGED PERSISTENT RUN alignment_change.
         END TRIGGERS.
                
       ASSIGN stupid   = h_align:MOVE-AFTER(last-tab)
              last-tab = h_align.
     END.  /* Has align */

    WHEN "VIRTUAL-WIDTH" THEN DO:
      CREATE TEXT h_v-wdth_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(14)". 
      CREATE FILL-IN h_v-wdth
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row 
                  COLUMN            = 64
                  HEIGHT            = 1
                  WIDTH             = h_col:WIDTH
                  DATA-TYPE         = "DECIMAL"
                  FORMAT            = ">>9.99"
                  SIDE-LABEL-HANDLE = h_v-wdth_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(_L._VIRTUAL-WIDTH)
                  LABEL             = "Virtual Width:"
            TRIGGERS:
              ON LEAVE PERSISTENT RUN vir_width_change.
            END TRIGGERS.
      ASSIGN stupid               = h_v-wdth:MOVE-AFTER(last-tab)
             last-tab             = h_v-wdth
             h_v-wdth_lbl:HEIGHT  = 1
             h_v-wdth_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                         h_v-wdth:LABEL + " ")
             h_v-wdth_lbl:ROW     = h_v-wdth:ROW
             h_v-wdth_lbl:COLUMN  = h_v-wdth:COLUMN - h_v-wdth_lbl:WIDTH
             h_v-wdth:SENSITIVE   = (_U._TYPE = "WINDOW" OR _C._SCROLLABLE).

      CREATE TEXT h_v-hgt_lbl ASSIGN FRAME = FRAME prop_sht:HANDLE FORMAT = "X(15)". 
      CREATE FILL-IN h_v-hgt
           ASSIGN FRAME             = FRAME prop_sht:HANDLE
                  ROW               = cur-row + 1.1
                  COLUMN            = h_v-wdth:COLUMN
                  HEIGHT            = 1
                  WIDTH             = h_col:WIDTH
                  DATA-TYPE         = "DECIMAL"
                  FORMAT            = ">>9.99"
                  SIDE-LABEL-HANDLE = h_v-hgt_lbl
                  BGCOLOR           = std_fillin_bgcolor
                  FGCOLOR           = std_fillin_fgcolor
                  SCREEN-VALUE      = STRING(_L._VIRTUAL-HEIGHT)
                  LABEL             = "Virtual Height:"
            TRIGGERS:
              ON LEAVE PERSISTENT RUN vir_height_change.
            END TRIGGERS.
      ASSIGN stupid              = h_v-hgt:MOVE-AFTER(last-tab)
             last-tab            = h_v-hgt
             h_v-hgt_lbl:HEIGHT  = 1
             h_v-hgt_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_v-hgt:LABEL + " ")
             h_v-hgt_lbl:ROW     = h_v-hgt:ROW
             h_v-hgt_lbl:COLUMN  = h_v-hgt:COLUMN - h_v-hgt_lbl:WIDTH
             h_v-hgt:SENSITIVE   = (_U._TYPE = "WINDOW" OR _C._SCROLLABLE).
     END. /* Has virtual width and height */
  END CASE.
END. /* For each non-toggle attribute */
/* This is a temporary kluge that needs to be fixed for 8.1A.                   */
/* The tab order attribute should be added to the UIB-ATTRS DB for dialog-boxes */
/* and frames.  Then the section below needs to be moved into the above case    */
/* statement and the case needs to be reworked into the proper style.  Also the */
/* h_btn_tabs button has to be sensitized and desensitized properly as well     */
/* get it into the correct tab-order position.  DRH 10/30/95                    */
    IF CAN-DO("FRAME,DIALOG-BOX":U,_U._TYPE) THEN DO:
      CREATE BUTTON h_btn_tabs
           ASSIGN FRAME            = FRAME prop_sht:HANDLE
                  ROW              = btn_color:ROW + (IF _U._TYPE EQ "DIALOG-BOX" THEN
                                                      4 * btn_color:HEIGHT + 1 ELSE
                                                      5 * btn_color:HEIGHT + 1.25)
                  COLUMN           = btn_color:COLUMN
                  HEIGHT-PIXELS    = icon-hp
                  WIDTH-PIXELS     = icon-wp
                  SENSITIVE        = TRUE
                  TOOLTIP          = "Tab Order"
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN adeuib/_tabedit.w (RECID(_U)).
            END TRIGGERS.
      ASSIGN stupid         = h_btn_tabs:LOAD-IMAGE({&ADEICON-DIR} + "tabedit" +
                                          "{&BITMAP-EXT}",2,2,32,32)
             stupid         = h_btn_tabs:LOAD-IMAGE-INSENSITIVE({&ADEICON-DIR} +
                                          "tabedit" + "{&BITMAP-EXT}",2,2,32,32)
      .
    END.  /* Has translation attributes */
END. /* PROCEDURE create_top_stuff */


/* Compute_lbl_wdth : It the widget has a label, then compute the label width
   in the current label units (including the ": " for a side-label).  */
PROCEDURE compute_lbl_wdth.
  DEF VAR i   AS INTEGER NO-UNDO.
  DEF VAR lbl AS CHAR    NO-UNDO.

  lbl_wdth = 0.
  IF h_label = ? OR NOT CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN RETURN.
  /* Get the currently specified label */
  IF _U._LABEL-SOURCE = "D" THEN DO:
    IF _U._TABLE EQ ? THEN lbl = _U._NAME.
    ELSE RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, no, OUTPUT lbl).
  END.
  ELSE DO WITH FRAME prop_sht:
     RUN adeuib/_strfmt.p (h_label:SCREEN-VALUE, _U._LABEL-ATTR, no, OUTPUT lbl).
  END.

  /* Note, on MS-WINDOWS, & characters are removed (and && becomes &).
     This allows for mnemonics in the label. */
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  lbl = REPLACE (REPLACE( REPLACE (lbl,"&&",CHR(10)) ,"&",""), CHR(10),"&").
  &ENDIF

  /* Check for no-labels or down-frame */ 
  IF _L._NO-LABELS OR parent_L._NO-LABELS THEN lbl_wdth = 0.
  ELSE IF parent_C._SIDE-LABELS THEN DO:
    /* Compute the size of the label - then add in the ": ". */
    ASSIGN lbl      = lbl + ": "
           lbl_wdth = (IF NOT _L._WIN-TYPE THEN LENGTH(lbl,"CHARACTER":U) ELSE
                       FONT-TABLE:GET-TEXT-WIDTH (lbl, parent_L._FONT)).
  END.
  ELSE DO:
    lbl_wdth = 0.
    /* Get each line (! delimited) of the label and find the maximum width */
    DO i = 1 TO NUM-ENTRIES (lbl, "!"):
      lbl_wdth = MAX (lbl_wdth,
                   FONT-TABLE:GET-TEXT-WIDTH(ENTRY(i,lbl,"!"), parent_L._FONT)).
    END.
  END.
END PROCEDURE.

PROCEDURE count_toggles.
 TOGGLE-COUNT:
  FOR EACH _PROP WHERE CAN-DO(_PROP._WIDGETS,_U._TYPE) AND
                       _PROP._CLASS = 1 BY _PROP._NAME:
    IF _PROP._NAME NE "NO-TITLE" THEN togcnt = togcnt + 1.
  END.

  ASSIGN tog-rows  = TRUNCATE((togcnt + 2) / 3,0)
         togcnt    = 0
         tog-col-2 = IF CAN-DO("RECTANGLE,RADIO-SET,BUTTON,SLIDER",_U._TYPE) THEN 27
                        ELSE IF CAN-DO("FILL-IN,IMAGE":U,_U._TYPE)           THEN 29
                        ELSE IF CAN-DO("EDITOR,SELECTION-LIST",_U._TYPE)     THEN 26
                        ELSE 28
         tog-col-3 = IF CAN-DO(
      "RECTANGLE,RADIO-SET,BROWSE,BUTTON,SLIDER,FILL-IN,TOGGLE-BOX,COMBO-BOX",
                                                                   _U._TYPE)THEN 48
                        ELSE IF CAN-DO("EDITOR,SELECTION-LIST",_U._TYPE)    THEN 50
                        ELSE IF CAN-DO("IMAGE",_U._TYPE)                    THEN 53
                        ELSE 51.5.
  ASSIGN tog-col-2 = tog-col-2 + 1
         tog-col-3 = tog-col-3 + 2
         tog-spc = (IF SESSION:PIXELS-PER-ROW < 25 OR SESSION:HEIGHT-PIXELS > 480
               THEN .88 ELSE .78).
      /* A good formula which almost works and probably could
           with some fine tuning is:
           tog-spc = DECIMAL(FONT-TABLE:GET-TEXT-HEIGHT-PIXELS() + 4) / 
                       DECIMAL(SESSION:PIXELS-PER-ROW). */
END PROCEDURE.  /* count_toggles */


PROCEDURE final_adjustments:
  DO WITH FRAME prop_sht:
    /* Put the Advanced... button in the bottom row with OK & Cancel */
    ASSIGN btn_adv:ROW = btn_Cancel:ROW
           btn_adv:COL = btn_Cancel:COL + btn_Cancel:WIDTH + 4
           stupid      = btn_adv:MOVE-AFTER(btn_cancel:HANDLE) IN FRAME prop_sht.

    ASSIGN FRAME prop_sht:DEFAULT-BUTTON = btn_OK:HANDLE IN FRAME prop_sht.

    /* Make inappropriate things not visible in tty emulation mode               */
    IF NOT _L._WIN-TYPE THEN DO:
      HIDE btn_color IN FRAME prop_sht.
      IF h_btn_font NE ?    THEN ASSIGN h_btn_font:VISIBLE    = FALSE.
      IF h_btn_ttl_clr NE ? THEN ASSIGN h_btn_ttl_clr:VISIBLE = FALSE.
    END.

    IF _U._TYPE = "IMAGE":U THEN HIDE btn_color IN FRAME prop_sht.

    /* If there are problems positioning the OK and Cancel buttons
     * modify the Define Frame prop_sht statement above by increasing
     * the height AND increasing the row of txt_attrs and btn_adv
     * so that they remain 3 PPUs less than the height of the frame
     * [gfs 01/29/98]
     */
    ASSIGN cur-row                 = cur-row + (tog-rows * tog-spc) + {&IVM_OKBOX} -
                                     (IF h_self:TYPE = "FRAME" THEN .2 ELSE 0 )
           adjust                  = frame prop_sht:HEIGHT - cur-row - 2.25
           btn_ok:ROW              = btn_ok:ROW - adjust
           btn_cancel:ROW          = btn_cancel:ROW - adjust
           btn_help:ROW            = btn_help:ROW - adjust
           btn_adv:ROW             = btn_adv:ROW - adjust
           frame prop_sht:HEIGHT   = frame prop_sht:HEIGHT - adjust
           rect-pal:HEIGHT         = (IF _U._TYPE NE "TEXT":U THEN btn_ok:ROW - 1.75
                                      ELSE h_btn_trans:ROW + h_btn_trans:HEIGHT - 1)
           FRAME prop_sht:HIDDEN   = FALSE.
  END.  /* DO WITH FRAME prop_sht */
END.  /* PROCEDURE final_adjustments */

/* For LongChar Editors, LARGE must be TRUE and cannot be modified */
PROCEDURE setEditorLarge:
  IF _F._DATA-TYPE = "LongChar" THEN
    ASSIGN
      _F._LARGE = TRUE
      h_large:CHECKED = TRUE
      h_large:SENSITIVE = FALSE.
  ELSE
      h_large:SENSITIVE = TRUE.
END PROCEDURE.

/* freeform_setup: Removes query amd fields buttons enlargens the query    */
/*                 editor box                                              */
PROCEDURE freeform_setup.
  IF h_btn_mdfy:VISIBLE THEN DO:
    ASSIGN h_btn_mdfy:VISIBLE   = FALSE
           h_btn_mdfy:SENSITIVE = FALSE
           h_query:WIDTH = h_query:WIDTH + h_btn_mdfy:WIDTH
           h_query:SCREEN-VALUE = "Freeform Query:" + CHR(10) +
                                  "  Use Code Section Editor to modify.".
   IF VALID-HANDLE(h_btn_flds) THEN 
     ASSIGN  h_btn_flds:VISIBLE   = FALSE
             h_btn_flds:SENSITIVE = FALSE. 
  END.  /* IF btn_mdfy was visible */
END. /* PROCEDURE freeform_setup */


PROCEDURE sensitize.
  DEF VAR h         AS HANDLE  NO-UNDO.
  DEF VAR i         AS INTEGER NO-UNDO.  
  DEF VAR local_var AS LOGICAL NO-UNDO.
  DEF VAR start-y   AS INTEGER NO-UNDO.    
  
  IF _U._LAYOUT-NAME = "Master Layout" THEN DO:
    /* Note that certain fields are NOT sensitized if this is database field */
    local_var = (_U._TABLE eq ?) OR CAN-DO("LOCAL,LIKE",_F._DISPOSITION).

    ASSIGN name:SENSITIVE IN FRAME prop_sht = local_var.
    IF h_label              NE ? THEN ASSIGN h_label:SENSITIVE =
                                    IF _U._LABEL-SOURCE = "D" THEN FALSE ELSE TRUE.
    IF h_nolbl              NE ? THEN h_nolbl:SENSITIVE                     = TRUE.
    IF h_query              NE ? THEN ASSIGN h_query:SENSITIVE              = TRUE.
    IF h_btn_mdfy           NE ? THEN ASSIGN h_btn_mdfy:SENSITIVE = 
                              NOT CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(_U) AND
                                           _TRG._tEVENT = "OPEN_QUERY":U) AND
                              _Q._TblList NE "rowObject":U.
    IF h_btn_flds           NE ? THEN ASSIGN h_btn_flds:SENSITIVE =
                                      (_Q._TblList NE "" AND h_btn_mdfy:SENSITIVE)
                                    OR _Q._TblList eq "rowObject":U.
    IF h_btn_mdfy NE ? AND h_btn_mdfy:SENSITIVE = FALSE AND
       _Q._TblList ne "rowObject":U THEN RUN freeform_setup.
    IF h_inner-lines        NE ? THEN ASSIGN h_inner-lines:SENSITIVE        = TRUE.
    IF h_data-type          NE ? THEN ASSIGN h_data-type:SENSITIVE =
                                            IF _U._TABLE NE ? OR (_U._TYPE = "COMBO-BOX" AND
                                              _U._SUBTYPE NE "DROP-DOWN-LIST") THEN FALSE
                                                ELSE TRUE.
    IF h_format             NE ? THEN ASSIGN h_format:SENSITIVE =
                                   IF _F._FORMAT-SOURCE = "D" OR
                                      (_U._TYPE = "COMBO-BOX" AND
                                     _U._SUBTYPE NE "DROP-DOWN-LIST") THEN FALSE ELSE TRUE.
    IF h_btn_fmt            NE ? THEN ASSIGN h_btn_fmt:SENSITIVE =
                                   IF _F._FORMAT-SOURCE = "D" OR
                                      (_U._TYPE = "COMBO-BOX" AND
                                     _U._SUBTYPE NE "DROP-DOWN-LIST") THEN FALSE ELSE TRUE.
    IF h_min-value          NE ? THEN ASSIGN h_min-value:SENSITIVE          = TRUE.
    IF h_max-value          NE ? THEN ASSIGN h_max-value:SENSITIVE          = TRUE.
    IF h_locked-cols        NE ? THEN ASSIGN h_locked-cols:SENSITIVE        = TRUE.
    IF h_max-dg             NE ? THEN ASSIGN h_max-dg:SENSITIVE             = TRUE.
    IF h_btn_up             NE ? THEN DO:
      ASSIGN h_btn_up:SENSITIVE             = TRUE.
      IF _U._TYPE = "WINDOW" THEN 
        stupid = IF _C._ICON NE "" THEN h_btn_up:LOAD-IMAGE(_C._ICON) ELSE TRUE.
      ELSE IF _F._IMAGE-FILE NE "" THEN
        stupid = h_btn_up:LOAD-IMAGE(_F._IMAGE-FILE).
    END.
    IF h_sicon              NE ? THEN
      ASSIGN h_sicon:SENSITIVE = _C._CONTROL-BOX
             stupid            = IF _C._SMALL-ICON NE "" 
                                 THEN h_sicon:LOAD-IMAGE(_C._SMALL-ICON) 
                                 ELSE TRUE.       
    IF h_btn_down           NE ? THEN 
      ASSIGN h_btn_down:SENSITIVE = TRUE
             stupid               = IF _F._IMAGE-DOWN-FILE NE ""
                                      THEN h_btn_down:LOAD-IMAGE(_F._IMAGE-DOWN-FILE)
                                      ELSE TRUE.
    IF h_btn_insen          NE ? THEN
      ASSIGN h_btn_insen:SENSITIVE = TRUE
            stupid                 = IF _F._IMAGE-INSENSITIVE-FILE NE ""
                            THEN h_btn_insen:LOAD-IMAGE(_F._IMAGE-INSENSITIVE-FILE)
                            ELSE TRUE.
    IF h_btn_popup          NE ? THEN ASSIGN h_btn_popup:SENSITIVE          = TRUE.
    IF h_btn_trans          NE ? THEN ASSIGN h_btn_trans:SENSITIVE          = TRUE.
    IF h_btn_dbfld          NE ? THEN ASSIGN h_btn_dbfld:SENSITIVE          = TRUE.
    IF h_btn_menu-bar       NE ? THEN ASSIGN h_btn_menu-bar:SENSITIVE       = TRUE.
    IF h_row-hgt            NE ? THEN ASSIGN h_row-hgt:SENSITIVE            = TRUE.
    IF h_align              NE ? THEN DO: /* Keep insensitive for column labels */
      ASSIGN h_align:SENSITIVE  =
             IF NOT parent_C._SIDE-LABELS AND NOT parent_L._NO-LABELS THEN FALSE
             ELSE TRUE.
    END.
    IF h_AUTO-END-KEY       NE ? THEN ASSIGN h_AUTO-END-KEY:SENSITIVE       = TRUE.
    IF h_AUTO-GO            NE ? THEN ASSIGN h_AUTO-GO:SENSITIVE            = TRUE.
    IF h_AUTO-INDENT        NE ? THEN ASSIGN h_AUTO-INDENT:SENSITIVE        = TRUE.
    IF h_AUTO-RESIZE        NE ? THEN ASSIGN h_AUTO-RESIZE:SENSITIVE        = TRUE.
    IF h_AUTO-RETURN        NE ? THEN ASSIGN h_AUTO-RETURN:SENSITIVE        = TRUE.
    IF h_BLANK              NE ? THEN ASSIGN h_BLANK:SENSITIVE              = TRUE.
    IF h_CANCEL-BTN         NE ? THEN ASSIGN h_CANCEL-BTN:SENSITIVE         = TRUE.
    IF h_DEBLANK            NE ? THEN ASSIGN h_DEBLANK:SENSITIVE            = TRUE.
    IF h_DEFAULT-BTN        NE ? THEN ASSIGN h_DEFAULT-BTN:SENSITIVE        = TRUE.
    IF h_DEFAULT-STYLE      NE ? THEN ASSIGN h_DEFAULT-STYLE:SENSITIVE      = TRUE.
    IF h_DISPLAY            NE ? THEN ASSIGN h_DISPLAY:SENSITIVE            = TRUE.
    IF h_DOWN               NE ? THEN ASSIGN h_DOWN:SENSITIVE               = TRUE.
    IF h_DRAG-ENABLED       NE ? THEN ASSIGN h_DRAG-ENABLED:SENSITIVE       = TRUE.
    IF h_ENABLE             NE ? THEN ASSIGN h_ENABLE:SENSITIVE             = TRUE.
    IF h_EXPAND             NE ? THEN ASSIGN h_EXPAND:SENSITIVE   = _F._HORIZONTAL.
    IF h_EXPLICIT-POSITION  NE ? THEN ASSIGN 
                                        h_EXPLICIT-POSITION:SENSITIVE = _U._size-to-parent eq no
                                        h_row:SENSITIVE = _U._size-to-parent eq no
                                                          AND _C._EXPLICIT_POSITION
                                        h_col:SENSITIVE = h_row:SENSITIVE.  
    IF h_folder-win-to-launch NE ? THEN ASSIGN h_folder-win-to-launch:SENSITIVE = isDynBrow.
    IF h_window-title-field   NE ? THEN ASSIGN h_window-title-field:SENSITIVE   = isDynView OR isDynBrow.
    IF h_custom-super-proc    NE ? THEN ASSIGN h_custom-super-proc:SENSITIVE    = FALSE.
    IF h_custom-super-proc_btn NE ? THEN ASSIGN h_custom-super-proc_btn:SENSITIVE = isDynView OR isDynBrow.
    IF h_custom-super-proc_btnd NE ? THEN ASSIGN h_custom-super-proc_btnd:SENSITIVE = isDynView OR isDynBrow.
    IF h_HIDDEN             NE ? THEN ASSIGN h_HIDDEN:SENSITIVE             = TRUE.
    IF h_HORIZONTAL         NE ? THEN ASSIGN h_HORIZONTAL:SENSITIVE         = TRUE.
    IF h_LARGE              NE ? THEN RUN setEditorLarge.
    IF h_LARGE-TO-SMALL     NE ? THEN ASSIGN h_LARGE-TO-SMALL:SENSITIVE     = TRUE.
    IF h_MESSAGE-AREA       NE ? THEN ASSIGN h_MESSAGE-AREA:SENSITIVE       = TRUE.
    IF h_MAX-BUTTON         NE ? THEN ASSIGN h_MAX-BUTTON:SENSITIVE         = _C._CONTROL-BOX.
    IF h_MIN-BUTTON         NE ? THEN ASSIGN h_MIN-BUTTON:SENSITIVE         = _C._CONTROL-BOX.    
    IF h_MULTIPLE           NE ? THEN ASSIGN h_MULTIPLE:SENSITIVE           = TRUE.
    IF h_NATIVE             NE ? THEN ASSIGN h_NATIVE:SENSITIVE             = TRUE.
    IF h_NO-ASSIGN          NE ? THEN ASSIGN h_NO-ASSIGN:SENSITIVE          = TRUE.
    IF h_NO-BOX             NE ? THEN ASSIGN h_NO-BOX:SENSITIVE             = TRUE.
    IF h_NO-HELP            NE ? THEN ASSIGN h_NO-HELP:SENSITIVE            = TRUE.
    IF h_NO-HIDE            NE ? THEN ASSIGN h_NO-HIDE:SENSITIVE            = TRUE.
    IF h_NO-ROW-MARKERS     NE ? THEN ASSIGN h_NO-ROW-MARKERS:SENSITIVE     = TRUE.
    IF h_NO-UNDO            NE ? THEN ASSIGN h_NO-UNDO:SENSITIVE            = local_var.
    IF h_OPEN-QUERY         NE ? THEN ASSIGN h_OPEN-QUERY:SENSITIVE         = TRUE.
    IF h_OVERLAY            NE ? THEN ASSIGN h_OVERLAY:SENSITIVE            = TRUE.
    IF h_READ-ONLY          NE ? THEN ASSIGN h_READ-ONLY:SENSITIVE          = TRUE.
    IF h_REMOVE-FROM-LAYOUT NE ? THEN ASSIGN h_REMOVE-FROM-LAYOUT:SENSITIVE = TRUE.
    IF h_RESIZE             NE ? THEN ASSIGN h_RESIZE:SENSITIVE             = TRUE.
    IF h_RETURN-INSERTED    NE ? THEN ASSIGN h_RETURN-INSERTED:SENSITIVE    = TRUE.
    IF h_SCROLL-BARS        NE ? THEN ASSIGN h_SCROLL-BARS:SENSITIVE        = TRUE.
    IF h_SCROLLABLE         NE ? THEN ASSIGN h_SCROLLABLE:SENSITIVE         = TRUE.
    IF h_SCROLLBAR-H        NE ? THEN ASSIGN h_SCROLLBAR-H:SENSITIVE        = TRUE.
    IF h_SCROLLBAR-V        NE ? THEN ASSIGN h_SCROLLBAR-V:SENSITIVE        = TRUE.
    IF h_SENSITIVE          NE ? THEN ASSIGN h_SENSITIVE:SENSITIVE          = TRUE.
    IF h_SHARED             NE ? THEN ASSIGN h_SHARED:SENSITIVE             = local_var.
    IF h_show-popup         NE ? THEN ASSIGN h_show-popup:SENSITIVE         = IF (AVAILABLE _F AND CAN-DO("DATE,DECIMAL,INTEGER":u, _F._DATA-TYPE) AND isDynView)
                                                                              THEN TRUE
                                                                               ELSE FALSE.
    IF h_SIDE-LABELS        NE ? THEN ASSIGN h_SIDE-LABELS:SENSITIVE        = TRUE.
    IF h_SORT               NE ? THEN ASSIGN h_SORT:SENSITIVE               = TRUE.
    IF h_STATUS-AREA        NE ? THEN ASSIGN h_STATUS-AREA:SENSITIVE        = TRUE.
    IF h_TIC-MARKS          NE ? THEN ASSIGN h_TIC-MARKS:SENSITIVE          = TRUE.
    IF h_TITLE-BAR          NE ? THEN ASSIGN h_TITLE-BAR:SENSITIVE          = TRUE.
    IF h_USE-DICT-EXPS      NE ? THEN ASSIGN h_USE-DICT-EXPS:SENSITIVE      = TRUE.
    IF h_VIEW               NE ? THEN ASSIGN h_VIEW:SENSITIVE               = TRUE.
    IF h_VIEW-AS-TEXT       NE ? THEN ASSIGN h_VIEW-AS-TEXT:SENSITIVE       = TRUE.
    IF h_WORD-WRAP          NE ? THEN ASSIGN h_WORD-WRAP:SENSITIVE = NOT _F._SCROLLBAR-H.
    IF _U._size-to-parent eq yes THEN ASSIGN h_row:SENSITIVE = no
                                             h_col:SENSITIVE = h_row:SENSITIVE.                                       
    IF h_AUTO-COMPLETION    NE ? THEN ASSIGN h_AUTO-COMPLETION:SENSITIVE = (h_SUBTYPE:SCREEN-VALUE NE "DL":U).
    IF h_UNIQUE-MATCH       NE ? THEN ASSIGN h_UNIQUE-MATCH:SENSITIVE = h_AUTO-COMPLETION:CHECKED.

    /* If the control is an OCX, the visible toggle's sensitivity is based
       on the control-frame's IsVisibleAtRuntime attribute */
    IF VALID-HANDLE(h_HIDDEN) AND _U._TYPE = "{&WT-CONTROL}" THEN
      ASSIGN h_HIDDEN:SENSITIVE    = _U._COM-HANDLE:IsVisibleAtRuntime.
  
    /* Retain Shape is only enabled when Stretch to Fit is TRUE */
    IF h_RETAIN-SHAPE NE ? THEN
      h_RETAIN-SHAPE:SENSITIVE = _F._STRETCH-TO-FIT.
      
    /* Desensitize _REMOVE-FROM-LAYOUT if MASTER is the only layout                 */
    IF  VALID-HANDLE(h_REMOVE-FROM-LAYOUT) THEN DO:
      i = 0.
      FOR EACH x_L WHERE x_L._u-recid = RECID(_U):
        i = i + 1.
      END.
      h_REMOVE-FROM-LAYOUT:SENSITIVE = i > 1.
    END.

  END.  /* If the master layout */
  ELSE DO:  /* A custom layout */
    ASSIGN name:SENSITIVE IN FRAME prop_sht = FALSE.
    IF h_label              NE ? THEN ASSIGN h_label:SENSITIVE              = isDynView OR isDynBrow.
    IF h_nolbl              NE ? THEN ASSIGN h_nolbl:SENSITIVE              = isDynView OR isDynBrow.
    IF h_window-title-field NE ? THEN ASSIGN h_window-title-field:SENSITIVE = FALSE.
    IF h_query              NE ? THEN ASSIGN h_query:READ-ONLY              = TRUE.
    IF h_btn_mdfy           NE ? THEN ASSIGN h_btn_mdfy:SENSITIVE           = FALSE.
    IF h_inner-lines        NE ? THEN ASSIGN h_inner-lines:SENSITIVE        = FALSE.
    IF h_data-type          NE ? THEN ASSIGN h_data-type:SENSITIVE          = FALSE.
    IF h_format             NE ? THEN ASSIGN h_format:SENSITIVE             = FALSE.
    IF h_btn_fmt            NE ? THEN ASSIGN h_btn_fmt:SENSITIVE            = FALSE.
    IF h_min-value          NE ? THEN ASSIGN h_min-value:SENSITIVE          = FALSE.
    IF h_max-value          NE ? THEN ASSIGN h_max-value:SENSITIVE          = FALSE.
    IF h_max-chars          NE ? THEN ASSIGN h_max-chars:SENSITIVE          = FALSE.
    IF h_locked-cols        NE ? THEN ASSIGN h_locked-cols:SENSITIVE        = FALSE.
    IF h_max-dg             NE ? THEN ASSIGN h_max-dg:SENSITIVE             = FALSE.
    IF h_btn_up             NE ? THEN ASSIGN h_btn_up:SENSITIVE             = FALSE.
    IF h_sicon              NE ? THEN ASSIGN h_sicon:SENSITIVE              = FALSE.
    IF h_btn_down           NE ? THEN ASSIGN h_btn_down:SENSITIVE           = FALSE.
    IF h_btn_insen          NE ? THEN ASSIGN h_btn_insen:SENSITIVE          = FALSE.
    IF h_btn_popup          NE ? THEN ASSIGN h_btn_popup:SENSITIVE          = FALSE.
    IF h_btn_trans          NE ? THEN ASSIGN h_btn_trans:SENSITIVE          = FALSE.
    IF h_btn_dbfld          NE ? THEN ASSIGN h_btn_dbfld:SENSITIVE          = FALSE.
    IF h_btn_tabs           NE ? THEN ASSIGN h_btn_tabs:SENSITIVE           = FALSE.
    IF h_btn_menu-bar       NE ? THEN ASSIGN h_btn_menu-bar:SENSITIVE       = FALSE.
    IF h_row-hgt            NE ? THEN ASSIGN h_row-hgt:SENSITIVE            = FALSE. 
    IF h_align              NE ? THEN ASSIGN h_align:SENSITIVE              = FALSE. 
    IF h_context-help       NE ? THEN ASSIGN h_context-help:SENSITIVE       = FALSE.
    IF h_context-help-file  NE ? THEN ASSIGN h_context-help-file:SENSITIVE  = FALSE.
    IF h_context-help-btn   NE ? THEN ASSIGN h_context-help-btn:SENSITIVE   = FALSE.
    IF h_context-help-id    NE ? THEN ASSIGN h_context-help-id:SENSITIVE    = FALSE.
    IF h_subtype            NE ? THEN ASSIGN h_subtype:SENSITIVE            = FALSE.
    IF h_tooltip            NE ? THEN ASSIGN h_tooltip:SENSITIVE            = FALSE.
    IF h_show-popup         NE ? THEN ASSIGN h_show-popup:SENSITIVE         = FALSE.  
    
    IF h_EXPLICIT-POSITION  NE ? THEN ASSIGN h_row:SENSITIVE = _C._EXPLICIT_POSITION
                                             h_col:SENSITIVE = _C._EXPLICIT_POSITION.
    IF h_col                NE ? AND CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) THEN
                                     ASSIGN h_col:SENSITIVE = FALSE
                                            h_row:SENSITIVE = FALSE.
    IF _U._TYPE = "BROWSE"       THEN ASSIGN h_wdth:SENSITIVE               = FALSE
                                             h_hgt:SENSITIVE                = FALSE
                                             h_btn_flds:SENSITIVE           = FALSE.   
    
    /* Only a few of the buttons in Other Settings are enabled. Desensitize 
       everything that isn't in the list. */
    ASSIGN h = FRAME prop_sht:CURRENT-ITERATION
           h = h:FIRST-CHILD
           start-y = txt_attrs:Y IN FRAME prop_sht.
    DO WHILE VALID-HANDLE(h):
      IF h:TYPE eq "TOGGLE-BOX":U AND h:Y > start-y THEN DO:
        IF (h ne h_SEPARATORS)        AND (h ne h_REMOVE-FROM-LAYOUT) AND
           (h ne h_FILLED)            AND (h ne h_GRAPHIC-EDGE) AND
           (h ne h_convert-3d-colors) AND (h ne h_no-focus)
        THEN h:SENSITIVE = FALSE.       
      END. /* IF ... toggle-box... */
      /* Get the next widget */
      h = h:NEXT-SIBLING.
    END.  /* DO WHILE... */      
  END.  /* If a custom layout */
END.  /* Procedure sensitize */

PROCEDURE frequency_change:
  RUN frequency_validation (OUTPUT lFreqValidate).
  IF NOT lFreqValidate THEN RETURN ERROR.
  ELSE ASSIGN _F._FREQUENCY = INTEGER(h_frequency:SCREEN-VALUE).
end procedure.

PROCEDURE frequency_validation:
  DEFINE OUTPUT PARAMETER lOk AS LOGICAL NO-UNDO.

  /* The minimum value could be negative or greater than zero so we want to see 
     if the frequency is more than the difference between the max and min values */
  IF INTEGER(h_min-value:SCREEN-VALUE) <> 0 THEN DO:
    IF INTEGER(h_frequency:SCREEN-VALUE) > 
      (INTEGER(h_max-value:SCREEN-VALUE) - INTEGER(h_min-value:SCREEN-VALUE)) THEN DO:
        MESSAGE "Tic mark frequency cannot be larger than the difference between" +
          " the maximum and minimum values." 
            VIEW-AS ALERT-BOX ERROR.
        ASSIGN lOk = FALSE.
    END.  /* tic mark frequency too big */
    ELSE lOk = TRUE.
  END.  /* min value negative */
  ELSE IF INTEGER(h_frequency:SCREEN-VALUE) > INTEGER(h_max-value:SCREEN-VALUE) THEN DO:
    MESSAGE "Tic mark frequency cannot be larger than the maximum value."
        VIEW-AS ALERT-BOX ERROR.
    ASSIGN lOk = FALSE.
  END.  /* frequency > max-value */  
  ELSE lOk = TRUE.
end procedure.

PROCEDURE tic_marks_change:
  IF h_tic-marks:SCREEN-VALUE <> "NONE" THEN DO:
    IF h_frequency:SCREEN-VALUE = "0" THEN h_frequency:SCREEN-VALUE = "10".
    ASSIGN h_frequency:SENSITIVE = YES
           _F._FREQUENCY         = INTEGER(h_frequency:SCREEN-VALUE).
  END.
  ELSE h_frequency:SENSITIVE = NO.
  _F._TIC-MARKS = h_tic-marks:SCREEN-VALUE.
end procedure.

PROCEDURE tooltip_change:
  IF h_tooltip:SCREEN-VALUE NE ? AND h_tooltip:SCREEN-VALUE NE "" THEN
    ASSIGN _U._TOOLTIP = h_tooltip:SCREEN-VALUE.
  ELSE
    ASSIGN _U._TOOLTIP = ?.  
end.

PROCEDURE Folder-win-to-launch_change:
IF h_folder-win-to-launch:SCREEN-VALUE NE ? AND h_folder-win-to-launch:SCREEN-VALUE NE "" THEN
    ASSIGN _C._folder-window-to-launch = h_folder-win-to-launch:SCREEN-VALUE.
  ELSE
    ASSIGN _C._folder-window-to-launch = ?.
END.

PROCEDURE Window-title-field_change:
IF h_window-title-field:SCREEN-VALUE NE ? AND h_window-title-field:SCREEN-VALUE NE "" THEN
    ASSIGN _C._window-title-field = h_window-title-field:SCREEN-VALUE.
  ELSE
    ASSIGN _C._window-title-field = ?.
END.


PROCEDURE delimiter_change:
    DEF VAR i AS INT NO-UNDO.
    DEF VAR cDelim AS CHAR NO-UNDO.

     if h_delimiter:SCREEN-VALUE = ? 
         or length(h_delimiter:SCREEN-VALUE) = 0 
           or h_delimiter:SCREEN-VALUE = " ":U
       then DO:
          MESSAGE "Delimiter must be specified. Reverting to default delimiter."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
          ASSIGN _F._delimiter = ",":U
                 h_delimiter:SCREEN-VALUE  = ",":U.
          RETURN NO-APPLY.
       END.

    /* if invalid format*/
       IF LENGTH(h_delimiter:SCREEN-VALUE) <> 1 OR 
         (ASC(h_delimiter:SCREEN-VALUE) GT 126 OR ASC(h_delimiter:SCREEN-VALUE) LE 32) THEN DO:
         MESSAGE "Delimiter must be a single printable character."
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
       END. /*if length */
       ELSE 
         ASSIGN _F._delimiter = h_delimiter:SCREEN-VALUE.
END. /* Procedure delimiter_change */


PROCEDURE remember_layout.  
  IF _U._TYPE EQ "FRAME" THEN 
     ASSIGN _L._VIRTUAL-WIDTH  = MAX(_L._VIRTUAL-WIDTH, _L._WIDTH)
            _L._VIRTUAL-HEIGHT = MAX(_L._VIRTUAL-HEIGHT, _L._HEIGHT).
            
  IF CAN-DO("WINDOW,FRAME,DIALOG-BOX",_U._TYPE) THEN
    ASSIGN sav_row        = _L._ROW
           sav_col        = _L._COL
           sav_width      = _L._WIDTH
           sav_height     = _L._HEIGHT
           sav_v-height   = _L._VIRTUAL-HEIGHT
           sav_v-width    = _L._VIRTUAL-WIDTH.
                 
  IF _L._LO-NAME NE "Master Layout" THEN 
    /* Before changing _L._ROW, _L._COL or _L._HEIGHT save the existing values so
       that we can determine if this become a custom layout (or not).            */
    ASSIGN sav_row      = _L._ROW
           sav_col      = _L._COL
           sav_width    = _L._WIDTH
           sav_height   = _L._HEIGHT
           sav_v-height = _L._VIRTUAL-HEIGHT
           sav_v-width  = _L._VIRTUAL-WIDTH.
END PROCEDURE. /* remember_layout */

PROCEDURE save_off:
 DO WITH FRAME prop_sht:
  /* Save current attribute settings that will cause the widget to be "recreated"   */
  /* if the attribute is changed.                                                   */
  IF _U._TYPE = "WINDOW" THEN
    ASSIGN sav-msg  = _C._MESSAGE-AREA
           sav-stsa = _C._STATUS-AREA
           sav-scr  = _C._SCROLL-BARS.
      
  IF CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) THEN
    ASSIGN sav-lo = _U._LAYOUT-NAME
           sav-3d = _L._3-D.

  IF CAN-DO("EDITOR,SELECTION-LIST",_U._TYPE) THEN
    ASSIGN sav-sh   = _F._SCROLLBAR-H
           sav-sv   = _U._SCROLLBAR-V
           sav-init = _F._INITIAL-DATA.
  
  IF _U._TYPE = "EDITOR" THEN sav-box = _L._NO-BOX.
         
  IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN
    ASSIGN sav-box  = _L._NO-BOX
           sav-ttl  = _C._TITLE
           sav-slab = _C._SIDE-LABEL
           sav-lbl  = _L._NO-LABELS
           sav-3d   = _L._3-D
           sav-scr  = _C._SCROLLABLE.

  IF CAN-DO("RADIO-SET,SLIDER,COMBO-BOX":U,_U._TYPE) THEN
    ASSIGN sav-exp  = _F._EXPAND
           sav-hor  = _F._HORIZONTAL
           sav-max  = _F._MAX-VALUE
           sav-min  = _F._MIN-VALUE
           sav-rb   = _F._LIST-ITEMS
           sav-lp  = _F._LIST-ITEM-PAIRS
           sav-init = _F._INITIAL-DATA
           sav-tic  = _F._TIC-MARKS
           sav-freq = _F._FREQUENCY
           sav-ncv  = _F._NO-CURRENT-VALUE
           sav-l-s  = _F._LARGE-TO-SMALL
           sav-sub  = _U._SUBTYPE
           sav-hgt  = _L._HEIGHT.

  /* Save entry number (1 or 2) of logical fill-in/combo-box initial value */
  IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND _F._DATA-TYPE EQ "LOGICAL" THEN DO:
    sav-ldef = LOOKUP (_F._INITIAL-DATA,_F._FORMAT,"/":U).
    IF sav-ldef = 0 THEN sav-ldef = 2. /* Just to be safe. */
  END.
    
  IF CAN-DO("FILL-IN",_U._TYPE) THEN
    ASSIGN sav-lbl  = _L._NO-LABELS
           sav-init = _F._INITIAL-DATA
           sav-vat  = _U._SUBTYPE.
  
  IF CAN-DO("COMBO-BOX",_U._TYPE) THEN
    ASSIGN sav-lbl  = _L._NO-LABELS
           sav-init = _F._INITIAL-DATA.
         
  IF CAN-DO("TOGGLE-BOX",_U._TYPE) THEN
    ASSIGN sav-init = _F._INITIAL-DATA. 
         
  IF _U._TYPE = "TEXT" THEN name:LABEL = "Text".
  
  IF NOT CAN-DO("COMBO-BOX,RADIO-SET",_U._TYPE) THEN
    valid-data-tp = valid-data-tp + ",Recid".
  
  sav-lbla = _U._LABEL-ATTR.   /* Most widgets have a label or a title */
 END.
END PROCEDURE. /* save_off */


PROCEDURE save_parent_info:
  /* If parent is a window, then update position in case it was moved. */
  IF parent_U._TYPE EQ "WINDOW" AND _h_win:WINDOW-STATE EQ WINDOW-NORMAL THEN
    ASSIGN parent_L._ROW = _h_win:ROW 
           parent_L._COL = _h_win:COLUMN
           /* Also, store virtual dimensions for easy comparisons, later */
           v-wdth        = parent_L._VIRTUAL-WIDTH
           v-hgt         = parent_L._VIRTUAL-HEIGHT.
  ELSE /* Parent is not a window */
    ASSIGN v-wdth = IF parent_C._SCROLLABLE
                      THEN MAX(parent_L._WIDTH, parent_L._VIRTUAL-WIDTH)
                      ELSE parent_L._WIDTH
           v-hgt  = IF parent_C._SCROLLABLE
                      THEN MAX(parent_L._HEIGHT, parent_L._VIRTUAL-HEIGHT)
                      ELSE parent_L._HEIGHT.

  IF parent_U._TYPE = "FRAME" AND NOT parent_C._SIDE-LABELS AND
     NOT parent_L._NO-LABELS THEN
    col-lbl-adj = (parent_C._FRAME-BAR:Y + 2) / SESSION:PIXELS-PER-ROW.

END.

PROCEDURE set_tab_order.
  /* Tab orders */
  IF h_btn_font NE ? THEN
    ASSIGN stupid   = h_btn_font:MOVE-AFTER(last-tab)
           last-tab = h_btn_font.
  IF h_btn_popup NE ? THEN
    ASSIGN stupid   = h_btn_popup:MOVE-AFTER(last-tab)
           last-tab = h_btn_popup.
  IF h_btn_trans NE ? THEN
    ASSIGN stupid   = h_btn_trans:MOVE-AFTER(last-tab)
           last-tab = h_btn_trans.
  IF h_btn_dbfld NE ? THEN
    ASSIGN stupid   = h_btn_dbfld:MOVE-AFTER(last-tab)
           last-tab = h_btn_dbfld.
  IF h_btn_menu-bar NE ? THEN
    ASSIGN stupid   = h_btn_menu-bar:MOVE-AFTER(last-tab)
           last-tab = h_btn_menu-bar.
  IF h_btn_ttl_clr NE ? THEN
    ASSIGN stupid   = h_btn_ttl_clr:MOVE-AFTER(last-tab)
           last-tab = h_btn_ttl_clr.
  ASSIGN stupid   = btn_adv:MOVE-AFTER(last-tab) IN FRAME prop_sht.
END PROCEDURE. /* set_tab_order */

PROCEDURE setup_for_window.
  DEF VAR not-used AS LOGICAL NO-UNDO.
    
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    /* Check the virtual dimensions, in case a frame was moved in the window.  This
     * only affects MSW because under Motif the Virtual sizes are strict and can only
     * be changed explicitly.  Under MSW virtual size is adjusted dynamically. */
    RUN height_check (INPUT        _U._HANDLE,         /* Handle to the window to check */
                      INPUT        _L._ROW-MULT,       
                      INPUT-OUTPUT _L._VIRTUAL-HEIGHT, /* Gets updated if its too small */
                      OUTPUT       not-used).          /* No need to know if it was changed */
    RUN width_check (INPUT         _U._HANDLE,
                     INPUT         _L._COL-MULT,
                     INPUT-OUTPUT  _L._VIRTUAL-WIDTH,
                     OUTPUT        not-used).
  &ENDIF
    
  /* Only update the Row&Col if the window is in a normal state (not minimized).
   * Otherwise, we end up with odd values. */
  IF _h_win:WINDOW-STATE EQ WINDOW-NORMAL AND _L._LO-NAME = "Master Layout" THEN DO:
    ASSIGN _L._ROW            = _h_win:ROW
           _L._COL            = _h_win:COLUMN.
    /* Keep other layout in sync with master -important for stupid multi-layout */
    /* runtime tricks                                                           */
    FOR EACH x_L WHERE x_L._u-recid = _L._u-recid AND x_L._LO-NAME NE "Master Layout":
      ASSIGN x_L._ROW = _L._ROW
             x_L._COL = _L._COL.
    END.
  END.         
END PROCEDURE. /* setup-for-window */

PROCEDURE setup_toggles:
  DO WITH FRAME prop_sht:
  /* Now get set to display toggles */
  ASSIGN txt_attrs:ROW = IF _U._TYPE = "TEXT" THEN
                           (btn_color:ROW + btn_color:HEIGHT + 2.25) ELSE
                         IF h_align NE ? THEN (h_align:ROW + h_align:HEIGHT +
                            (IF _U._TYPE = "BROWSE" THEN 1.5 ELSE .5))
                         ELSE cur-row + IF _U._TYPE NE "FRAME":U OR
                                        SESSION:HEIGHT > 18.5 THEN 2.6 ELSE 2.4
         txt_attrs:HIDDEN = _U._TYPE = "TEXT"
         cur-row       = (IF _U._TYPE NE "TEXT":U THEN
                            txt_attrs:ROW + txt_attrs:HEIGHT + .1
                          ELSE MAX(h_btn_trans:ROW + h_btn_trans:HEIGHT + .5,
                                   cur-row + 2.6))
         togcnt        = 0
         stupid        = btn_color:MOVE-AFTER(last-tab) IN FRAME prop_sht
         last-tab      = btn_color:HANDLE IN FRAME prop_sht.
  END.
END PROCEDURE. /* setup_toggles */

PROCEDURE process-sellist-and-combo:
  /* Procedure is called from the GO trigger and validates/assigns values for
     Combo-Box's and Selection-List's */
     
    /* check the format string for logicals, and then set the initial value. */
    /* NOTE: This code is mirrored in the FILL-IN section below */
    IF _U._TYPE = "COMBO-BOX" AND _F._DATA-TYPE = "LOGICAL":U THEN DO:
      IF NUM-ENTRIES (_F._FORMAT, "/") NE 2 THEN DO:
        MESSAGE "'" _F._FORMAT "' is an invalid logical format." SKIP
                " Use a format of the form 'yes/no' or 'true/false'."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        l_error_on_go = TRUE.
      END.
      ELSE _F._INITIAL-DATA = ENTRY (sav-ldef, _F._FORMAT,"/":U).
    END.  /* COMBO-BOX AND LOGICAL */

    IF _U._TYPE = "COMBO-BOX":U THEN DO:
      IF valid-handle(h_listType) AND h_listType:SCREEN-VALUE = "I":U THEN DO:
        ASSIGN _F._LIST-ITEM-PAIRS = ?
               _F._LIST-ITEMS = REPLACE(RIGHT-TRIM(h_query:SCREEN-VALUE),CHR(13),"").
        ASSIGN l_error_on_go = NOT validate-list-items(_U._HANDLE).
        IF l_error_on_go THEN new_btns  = FALSE.
      END.      
      ELSE IF valid-handle(h_query) THEN DO:
       ASSIGN _F._LIST-ITEM-PAIRS = REPLACE(RIGHT-TRIM(h_query:SCREEN-VALUE),CHR(13),"")
              _F._LIST-ITEMS = ?.   
       ASSIGN l_error_on_go = NOT validate-list-item-pairs(_U._HANDLE).   
       IF l_error_on_go THEN new_btns  = FALSE.
      END.
    END.  /* IF COMBO-BOX */
    IF _U._TYPE NE "COMBO-BOX" OR _U._WIN-TYPE THEN DO:
      /* See which type of list to process */
      IF h_listType:SCREEN-VALUE = "P":U AND 
        NOT l_error_on_go                THEN 
      DO:
       ASSIGN _F._LIST-ITEM-PAIRS = REPLACE(RIGHT-TRIM(h_query:SCREEN-VALUE),CHR(13),"")
              _F._LIST-ITEMS = ?.
        /* Did we switch from LIST-ITEMS to LIST-ITEM-PAIRS? If so, 
           then we have to destroy and redraw the selection list. Otherwise,
           set the values to the existing widget */
        IF NOT switchlist THEN DO:
          ASSIGN h_self:DELIMITER = ",":U.
          tmpstr = "".
          /* In case the user did not enter commas at the end, add them for the widget */
          DO i = 1 to NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
            tmpstr = tmpstr + ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)) + 
             (IF i < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) AND 
              SUBSTRING(ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)),LENGTH(ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))),1,"CHARACTER":U) <> ",":U 
              THEN ",":U ELSE "").
          END.
          ASSIGN h_self:LIST-ITEM-PAIRS = tmpstr NO-ERROR.
        END.
      END.
      ELSE DO:
        IF NOT l_error_on_go AND
          h_self:DATA-TYPE = _F._DATA-TYPE THEN
        DO:
          ASSIGN _F._LIST-ITEMS         = REPLACE(RIGHT-TRIM(h_query:SCREEN-VALUE),CHR(13),"")
                 _F._LIST-ITEM-PAIRS    = ?.
        /* Did we switch from LIST-ITEM-PAIRS to LIST-ITEMS? If so, 
           then we have to destroy and redraw the selection list. Otherwise,
           set the values to the existing widget */
          IF NOT switchlist THEN
           ASSIGN 
             h_self:DELIMITER  = CHR(10)
             h_self:LIST-ITEMS = _F._LIST-ITEMS.
        END.
      END.
    END. /* IF a COMBO-BOX or GUI */
END PROCEDURE. /* process-sellist-and-combo */

PROCEDURE set_window_controls:
  /* set window control attributes, 
     this is called from value-changed of h_small-title and h_control-box. */  
  
  DEFINE VARIABLE ok AS log NO-UNDO.
  
  /* If both properties are checked we turn off the other */
  IF _C._CONTROL-BOX AND _C._SMALL-TITLE THEN
  DO: 
    IF SELF = h_control-box THEN 
      ASSIGN 
        h_small-title:CHECKED = FALSE
        _C._SMALL-TITLE       = FALSE.            
    ELSE
      ASSIGN 
        h_control-box:CHECKED = FALSE
        _C._CONTROL-BOX       = FALSE.            
  END. /* if control-box and small-title */
  
  /* Tell the user that the small icon will be removed if no control-box */
  IF _C._CONTROL-BOX = FALSE AND _C._SMALL-ICON <> "" THEN
  DO:
    MESSAGE 
       "This property change will remove the specified small icon"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE ok.
    IF NOT ok THEN
    DO:
        ASSIGN
          _C._CONTROL-BOX       = TRUE
          _C._SMALL-TITLE       = FALSE
          h_control-box:CHECKED = TRUE
          h_small-title:CHECKED = FALSE.
        RETURN NO-APPLY.
    END.
    ASSIGN
      _C._SMALL-ICON = "":U 
      h_sicon_txt:SCREEN-VALUE = "":U
      h_sicon:SENSITIVE = FALSE.
      h_sicon:LOAD-IMAGE("":U).     
  END. /* id control-box = false and small-icon <> '' */     
  
  /* max- and min-buttons and small-icon are only actual when control box. */
  ASSIGN
    h_sicon:SENSITIVE      = _C._CONTROL-BOX
    h_max-button:SENSITIVE = _C._CONTROL-BOX
    h_min-button:SENSITIVE = _C._CONTROL-BOX
    h_max-button:CHECKED   = _C._CONTROL-BOX
    h_min-button:CHECKED   = _C._CONTROL-BOX
    _C._min-button         = _C._CONTROL-BOX
    _C._max-button         = _C._CONTROL-BOX
    .    
    
  /* If control box is False, context help cannot be true */  
  IF SELF = h_control-box AND NOT _C._CONTROL-BOX AND _C._CONTEXT-HELP THEN DO:
    ASSIGN h_context-help:CHECKED = FALSE.
    APPLY "VALUE-CHANGED":U TO h_context-help.
  END.  /* if not control box and context-help */
  
  /* If small title is True, context help cannot be true */
  IF SELF = h_small-title AND _C._SMALL-TITLE AND _C._CONTEXT-HELP THEN DO:
    ASSIGN h_context-help:CHECKED = FALSE.
    APPLY "VALUE-CHANGED":U TO h_context-help.
  END.  /* if small title and context help */
  
END.

/* tog-proc.i contains internal procedures for the toggle VALUE-CHANGED
   trigger code */
{adeuib/tog-proc.i}

PROCEDURE toggle_placement:

  TOGGLE-PLACEMENT:
  FOR EACH _PROP WHERE CAN-DO(_PROP._WIDGETS,_U._TYPE) AND
                 _PROP._CLASS = 1 AND _PROP._NAME NE "NO-TITLE" BY _PROP._NAME:
    togcnt = togcnt + 1.
    CASE _PROP._NAME:
      {adeuib/tog-disp.i}
    END.
  END.

END.  /* procedure toggle_placement */



PROCEDURE CUSTOM-SUPER-PROC_change:
/* ***********************************************************
   Purpose: Lookup dialog call for Dynamics custom super 
            procedure when the lookup button is choosen
*************************************************************/
 DEFINE VARIABLE cFilename          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK                AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRepDesManager     AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cPathedFilename    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRelativePath  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRootDir       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRelPathSCM    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcFullPath      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcObject        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcFile          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcError         AS CHARACTER  NO-UNDO.

 ASSIGN CURRENT-WINDOW:PRIVATE-DATA = STRING(THIS-PROCEDURE).
 
 RUN ry/obj/gopendialog.w (INPUT CURRENT-WINDOW,
                           INPUT "",
                           INPUT No,
                           INPUT "Get Object",
                           OUTPUT cFilename,
                           OUTPUT lok).
 IF lOK THEN
 DO:
    hRepDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
    /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
    RUN retrieveDesignObject IN hRepDesManager ( INPUT  cFilename,
                                                 INPUT  "",  /* Get default result Code */
                                                 OUTPUT TABLE ttObject ,
                                                 OUTPUT TABLE ttPage,
                                                 OUTPUT TABLE ttLink,
                                                 OUTPUT TABLE ttUiEvent,
                                                 OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
    FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = cFilename 
                          AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
    IF AVAIL ttObject THEN
    DO:
       /* Get relative directory of specified object */ 
       RUN calculateObjectPaths IN gshRepositoryManager
                          (cFilename,  /* ObjectName */          0.0, /* Object Obj */      
                           "",  /* Object Type */         "",  /* Product Module Code */
                           "", /* Param */                "",
                           OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                           OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                           OUTPUT cCalcObject,            OUTPUT cCalcFile,
                           OUTPUT cCalcError).
       IF cCalcRelPathSCM > "" THEN
          cCalcRelativePath = cCalcRelPathSCM.
       ASSIGN cPathedFilename = cCalcRelativePath + (IF cCalcRelativePath = "" then "" ELSE "/":U )
                                                    + cCalcFile .
       IF DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "Procedure":U) THEN
          ASSIGN    h_CUSTOM-SUPER-PROC:SCREEN-VALUE = cPathedFilename
                    h_CUSTOM-SUPER-PROC:MODIFIED     = YES.
    END.
 END.

END PROCEDURE.

PROCEDURE CUSTOM-SUPER-PROC_clear:
/* ***********************************************************
   Purpose: Clear Progress Dynamics custom super procedure 
*************************************************************/
   ASSIGN
     h_CUSTOM-SUPER-PROC:SCREEN-VALUE = ""
     h_CUSTOM-SUPER-PROC:MODIFIED     = YES.

END PROCEDURE.

FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( ) :

  RETURN "Procedure":U.
END FUNCTION.
