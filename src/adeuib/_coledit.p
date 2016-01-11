/***********************************************************************
* Copyright (C) 2005-2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: adeuib/_coledit.p

  Description:

  This procedure is designed to edit the columns of a browse, SmartData.  This procedure
  gets called from two places: The UIB Browse property sheet and the Query Builder.

  The output of this procedure is the proper set of _BC records that completely
  reflects the columns of the browse.  Except for _rdbrow.p, this is the ONLY
  procedure that can create or modify these record.  

  There are two kinds of columns that can be defined for a browse (smart or not):
    1) A database field in which case _BC._DBNAME, _BC._TABLE and _BC._NAME are
       completely filled in. _BC._DISP-NAME contains the concatenated value 
        (depending on mode) of _BC._DBNAME + _BC._TABLE + _BC._FIELD
    2) The other kind is a calculated field in which case _BC._DBNAME contains
       the identifier "_<CALC>",  _BC._TABLE is ? and _BC._DISP-NAME contains the
       expression of the calculated field.

  There are two kinds of columns that can be defined for a SmartData:
    1) A database field in which case _BC._DBNAME, _BC._TABLE and _BC._NAME are
       completely filled in. _DISP-NAME contains a unique field name.
    2) The other kind is a calculated field in which case _BC._DBNAME contains
       the identifier "_<CALC>",  _BC._TABLE is ?, _BC._NAME contains the
       expression of the calculated field. _DISP-NAME contains a unique field 
        name.

  The input of this procedure is really:
     1) The RECID of the browse or SmartData query being editted.  
        This is the shared variable _query-u-rec.
     2) The current list of tables that fields can be choosen from.  Given the _U
        record found from the handle _h_cur_widg we can get access to the _TblList
        field of the _Q record, but when this is called from the Query Builder this
        would be out of date.  Therefore, this information will be passed in via the
        Tbl-List input parameter.  This list will include <External Tables> of the
        browse as well as tables that are part of the browses query.  This is a 
        comma delimitted list of DB.TABLE combinations.
     3) The handle to the Smartdata if we are using the SmartData as the source.
  * NOTE that 2 and 3 are mutually exclusive
     4) The current list of fields in the browse/smartdata. 
        Since this is the only procedure
        that can manipulate _BC records, the current set of records with the RECID
        of the browse or SmartData query is the current set when this procedure 
        starts up.


  Input Parameters:
      Tbl-List - Comma delimitted list of DB tables whose fields can be choosen
      sHandle - Handle to the SmartData whose fields can be choosen

  Output Parameters:
      <none>

  Author: D. Ross Hunter

  Created: 02/14/95 - 10:50 am
  Modified: 1/98 SLK Added morphing for the SmartData column editor
            2/98 SLK Added morphing for the SmartBrowser column editor
                        like browser column editor but width instead of format
            04/03/98 SLK For SmartData, changed Enabled to Updateable...
            04/10/98 SLK For SmartData Beta1, disable Calculated Fld, Edit
                     Search for BETA1
            06/01/98 HD Added morphing for WebReport 
            06/01/98 SLK Allow renaming of SmartDataObject field name 
            06/01/98 SLK Added USER-LISTS to SDO Advanced dialog
            06/11/98 SLK ReEnable Calculated Fld, Edit
            06/26/98 SLK Create _TRG
            08/21/98 SLK Removed USER-LISTS to SDO Advanced dialog
            10/15/98 HD  Using a query for DICTDB data 
            04/27/99 TSM Added bcformat local variable for browse column
                         format so that the format can be displayed with
                         various Intl Numeric Formats and stored in 
                         _BC._FORMAT as American format
            05/20/99 TSM Added VISIBLE attribute  
            06/10/99 TSM Added AUTO-RESIZE and COLUMN-READ-ONLY attributes   
            06/14/99 TSM Added support for browse separator fgcolor - changed
                         parameters in call to _chscolr.p     
            06/25/99 TSM Changed VISIBLE toggle to be enabled for calculated fields
                         that contain "@ fieldname"    
            08/08/00 JEP Assign _P recid to newly created _TRG records.
            11.15.00 AC  Added fix for bug #20000904-004 

NOTE: The variable isReport is used to enable calculated fields 
      for WebReports. 
      Remove this when making calculated fields for SDO's. 
      The isReport variable should only be used to hide enable/disable 
      buttons and toggle boxes.      
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER Tbl-List AS CHAR                    NO-UNDO.
DEFINE INPUT        PARAMETER p_hSmartData AS WIDGET-HANDLE       NO-UNDO.

&GLOBAL-DEFINE WIN95-BTN TRUE
/* Shared variables and temp-tables                                     */
{adecomm/adestds.i}
{adeuib/sharvars.i}
{adeuib/brwscols.i}
{adeuib/triggers.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/uibhlp.i}
{adecomm/getdbs.i &NEW="NEW"}
{src/adm2/globals.i}
/** Contains definitions for all design-time temp-tables. **/
{ destdefi.i}

/* Local Variable Definitions ---                                       */

/* Used to distinguish between different behavior for different objects */ 
DEFINE VARIABLE isSmartData   AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE srcSmartData  AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE isQuery       AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE isReport      AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE isDynSDO      AS LOGICAL                          NO-UNDO.

DEFINE VARIABLE cCalcClass    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcColLabel AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cCalcDataType AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cCalcLabel    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cCalcFormat   AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cCalcHelp     AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cCalcModule   AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE ch            AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE choice        AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE counter       AS INTEGER                          NO-UNDO.
DEFINE VARIABLE cur-db-name   AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE curObjName    AS CHARACTER INITIAL "browse":U     NO-UNDO.
DEFINE VARIABLE cur-record    AS RECID                            NO-UNDO.
DEFINE VARIABLE cur-seq       AS INTEGER                          NO-UNDO.
DEFINE VARIABLE cur-tbl-name  AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE dataType      AS INTEGER                          NO-UNDO.
DEFINE VARIABLE dummy         AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE empty-flg     AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE empty-msg     AS CHARACTER VIEW-AS EDITOR
                              SIZE 25 BY 7                        NO-UNDO.
DEFINE VARIABLE enableValue   AS CHARACTER FORMAT "x(1)"          NO-UNDO.
DEFINE VARIABLE hasDataField  AS CHARACTER FORMAT "x(1)"          NO-UNDO.
DEFINE VARIABLE first-rec     AS RECID     INITIAL ?              NO-UNDO.
DEFINE VARIABLE First-Check   AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE Fld-List      AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                          NO-UNDO.
DEFINE VARIABLE icon-hp       AS INTEGER                          NO-UNDO.
DEFINE VARIABLE icon-wp       AS INTEGER                          NO-UNDO.
DEFINE VARIABLE imode         AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE isCalcFld     AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE iTable        AS INTEGER                          NO-UNDO.
DEFINE VARIABLE iw            AS INTEGER                          NO-UNDO.
DEFINE VARIABLE last-rec      AS RECID                            NO-UNDO.
DEFINE VARIABLE lDbAware      AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE lError        AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE lNewCalc      AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE ret-msg       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE sep_fgc       AS INTEGER                          NO-UNDO.
DEFINE VARIABLE this-is-a-SB  AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE tt-info       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE UniqueName    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE userNames     AS CHARACTER                        NO-UNDO.


DEFINE VARIABLE lBufferType        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lEnableDFInfo      AS LOGICAL    NO-UNDO.

/* Variable used to determine if the objName has "Object" in its name 
 * so that we do not have the phrase
 * SmartDataObject object and only SmartDataObject */
DEFINE VARIABLE hasObjInName  AS LOGICAL                          NO-UNDO.

DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER xx_U FOR _U.
DEFINE BUFFER x_C FOR _C.

/* Function prototype */
FUNCTION get-sdo-hdl RETURNS HANDLE
    (INPUT proc-file-name AS CHARACTER,
     INPUT pOwnerHdl AS HANDLE ) IN _h_func_lib.

FUNCTION shutdown-sdo RETURNS CHARACTER
    (INPUT pOwnerHdl AS HANDLE) IN _h_func_lib.

FIND _U WHERE RECID(_U)         = _query-u-rec.
FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
FIND _C WHERE RECID(_C)         = _U._x-recid NO-ERROR.
IF AVAILABLE _C THEN
  FIND _Q WHERE RECID(_Q)       = _C._q-recid NO-ERROR.

/* The 4 cases are: 
A regular browse or SmartBrowse with query ---------------------------| 
A SmartBrowse (SmartData, DataSet is Source)-----------------------|  |
An SDO ---------------------------------------------------------|  |  |
A WebReport -------------------------------------------------|  |  |  |
                   
The behavior variables are:                      
isQuery      - Not a browse,(different layout and widgets)   Y  Y  N  N      
isReport     - No update widgets visible                     Y  N  N  N 
isSmartData  - Regulates how to store computed fields:       N  Y  N  N
srcSmartData - src is sdo                                    N  N  Y  N
*/

ASSIGN srcSmartData = _P._data-object > '' 
       isQuery      = _U._type = "QUERY":U
       isSmartData  = _U._subtype = "SmartDataObject":U
       isReport     = isQuery AND NOT isSmartData. 
                    /*  
                      (NOT srcSmartData) AND
                      (NOT CAN-FIND(FIRST x_U WHERE
                          x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                          x_U._TYPE          = "FRAME":U)).
                      */

/* Set isDynSDO if ICF is running and we are working on a Dynamic SDO */
IF isSmartData AND _DynamicsIsRunning THEN DO:
  isDynSDO = LOOKUP(_P.object_Type_Code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                 INPUT "DynSDO":U)) <> 0 .
END.

/* If srcSmartData make sure we have a valid procedure handle */
IF srcSmartData THEN p_hSmartData = get-sdo-hdl(_P._data-object,THIS-PROCEDURE).

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define EnableValue IF NOT _BC._ENABLED THEN "":U~
                           ELSE IF isSmartData THEN "u":U~
                           ELSE                     "e" @ enableValue 
&Scoped-define HasDataField IF _DynamicsIsRunning AND isSmartData AND~
                               NOT _BC._HAS-DATAFIELD-MASTER THEN "*":U~
                           ELSE "":U @ hasDataField
&Scoped-define Mandatory   IF isReport THEN FALSE~
                           ELSE _BC._Mandatory          @ _BC._Mandatory 

&Scoped-define OPEN-QUERY-brw-flds OPEN QUERY brw-flds FOR EACH _BC~
  WHERE _BC._x-recid = _query-u-rec NO-LOCK USE-INDEX _x-recid-seq.


/* ***********************  Control Definitions  ********************** */
/* Buttons for the bottom of the screen                                 */
DEFINE BUTTON btn_ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_cancel LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_help   LABEL "&Help":C12  {&STDPH_OKBTN}.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_add      LABEL "&Add..."              SIZE 19 BY 1.125.
DEFINE BUTTON b_advanced LABEL "Ad&vanced..."         SIZE 19 BY 1.125.
DEFINE BUTTON b_calc-fld LABEL "&Calculated Field..." SIZE 22.5 BY 1.125.
DEFINE BUTTON b_clr      IMAGE-UP FILE "adeicon/color1-u" FROM X 4 Y 4
                         TOOLTIP "Color"              SIZE-PIXELS 34 BY 34.
DEFINE BUTTON b_edit     LABEL "Ed&it..."             SIZE 10.5 BY 1.125.
DEFINE BUTTON b_fnt      IMAGE-UP FILE "adeicon/font1-u"  FROM X 5 Y 4
                         TOOLTIP "Font"               SIZE-PIXELS 34 BY 34.
DEFINE BUTTON b_attr     IMAGE-UP FILE "adeicon/trans-u"  FROM X 5 Y 4
                         TOOLTIP "Translation Attributes" SIZE-PIXELS 34 BY 34.
DEFINE BUTTON b_view-as  IMAGE-UP FILE "adeicon/viewas.gif"
                         TOOLTIP "View-as"            SIZE-PIXELS 30 BY 30.
DEFINE BUTTON b_frm-hlp  LABEL "For&mat Help..."      SIZE 15 BY 1.125.
DEFINE BUTTON b_lbl-clr  IMAGE-UP FILE "adeicon/color1-u" FROM X 4 Y 4
                         TOOLTIP "Label Color"        SIZE-PIXELS 34 BY 34.
DEFINE BUTTON b_lbl-fnt  IMAGE-UP FILE "adeicon/font1-u"  FROM X 5 Y 4
                         TOOLTIP "Label Font"         SIZE-PIXELS 34 BY 34.
DEFINE BUTTON b_enable   LABEL "&Enable All"          SIZE 19 BY 1.125.
DEFINE BUTTON b_disable  LABEL "Di&sable All"         SIZE 19 BY 1.125.
DEFINE BUTTON b_mv-dn    LABEL "Move &Down"           SIZE 19 BY 1.125.
DEFINE BUTTON b_mv-up    LABEL "Move &Up"             SIZE 19 BY 1.125.
DEFINE BUTTON b_remove   LABEL "&Remove"              SIZE 19 BY 1.125.

DEFINE RECTANGLE enable-rect    EDGE-PIXELS 2 NO-FILL SIZE 20.5 BY .4.
DEFINE RECTANGLE help-rect      EDGE-PIXELS 2 NO-FILL SIZE 47 BY 2.125.
DEFINE RECTANGLE col-attrs-rect EDGE-PIXELS 4 NO-FILL SIZE 49 BY 16.0.
DEFINE RECTANGLE width-rect     EDGE-PIXELS 2 NO-FILL SIZE 47 BY 2.125.
DEFINE RECTANGLE format-rect    EDGE-PIXELS 2 NO-FILL SIZE 47 BY 3.
DEFINE RECTANGLE column-rect    EDGE-PIXELS 2 NO-FILL SIZE 47 BY 3.2.
DEFINE RECTANGLE rdonly-rect    EDGE-PIXELS 2 NO-FILL SIZE 51 BY 7.5.
DEFINE RECTANGLE advanced-rect  EDGE-PIXELS 2 NO-FILL SIZE 51 BY 7.7.


DEFINE VAR Flds-in-brws-lbl AS CHARACTER FORMAT "X(256)":U
                      VIEW-AS TEXT SIZE 23.5 BY .72                    NO-UNDO.
DEFINE VAR help-lbl         AS CHARACTER FORMAT "X(14)":U              NO-UNDO
                      INITIAL "Column Help":U VIEW-AS TEXT SIZE 12.4 BY .76.
DEFINE VAR col-attrs-lbl     AS CHARACTER INITIAL "Column Attributes":U 
                      VIEW-AS TEXT SIZE 16.9 BY .76 FORMAT "X(20)"     NO-UNDO.
DEFINE VAR data_type         AS CHARACTER INITIAL "Character":U FORMAT "x(20)"
                      VIEW-AS COMBO-BOX INNER-LINES 6
                      LIST-ITEMS "Character","Date","DateTime","DateTime-Tz","Decimal","Integer","INT64","Logical"
                      SIZE 37 BY 1 NO-UNDO.
DEFINE VAR width-lbl         AS CHARACTER INITIAL "Width":U 
                      VIEW-AS TEXT SIZE 7 BY .76                       NO-UNDO.
DEFINE VAR format-lbl        AS CHARACTER INITIAL "Format":U 
                      VIEW-AS TEXT SIZE 7 BY .76                       NO-UNDO.
DEFINE VAR label-lbl         AS CHARACTER INITIAL "Label":U 
                      VIEW-AS TEXT SIZE 5.9 BY .72                     NO-UNDO.
DEFINE VAR tog_enabled       AS LOGICAL  LABEL "Enabled" 
                      VIEW-AS TOGGLE-BOX SIZE 14.5 BY .72              NO-UNDO.
DEFINE VAR tog_auto_resize   AS LOGICAL  LABEL "Auto-Resize"
                      VIEW-AS TOGGLE-BOX SIZE 19 BY .72                NO-UNDO.
DEFINE VAR tog_column_read_only AS LOGICAL LABEL "Column-Read-Only"
                      VIEW-AS TOGGLE-BOX SIZE 22 BY .72                NO-UNDO.
DEFINE VAR tog_disable_auto_zap AS LOGICAL LABEL "Disable-autozap" 
                      VIEW-AS TOGGLE-BOX SIZE 19 BY .72                NO-UNDO.
DEFINE VAR tog_auto_return   AS LOGICAL LABEL "Auto-Return" 
                      VIEW-AS TOGGLE-BOX SIZE 16 BY .72                NO-UNDO.
DEFINE VAR tog_inherit_validation AS LOGICAL  
                      LABEL "Inherit Dictionary Validation Expression" 
                      INITIAL YES
                      VIEW-AS TOGGLE-BOX SIZE 45 BY .72                NO-UNDO.
DEFINE VAR tog_visible       AS LOGICAL  LABEL "Visible"
                      VIEW-AS TOGGLE-BOX SIZE 14.5 BY .72              NO-UNDO.  
DEFINE VAR fldBCFieldNameLbl AS CHARACTER INITIAL "Name:"
                      VIEW-AS TEXT SIZE 8 BY 1 FORMAT "X(11)" NO-UNDO.
DEFINE VAR fldBCLabelLbl AS CHARACTER INITIAL "Label:"
                      VIEW-AS TEXT SIZE 8 BY 1 FORMAT "X(11)" NO-UNDO.
DEFINE VAR fldBCColLabelLbl AS CHARACTER INITIAL "Column label:"
                      VIEW-AS TEXT SIZE 13 BY 1 FORMAT "x(13)" NO-UNDO.
DEFINE VAR fldBCDBNameLbl AS CHARACTER INITIAL "Database:"
                      VIEW-AS TEXT SIZE 11 BY .76 FORMAT "X(11)"       NO-UNDO.
DEFINE VAR fldBCTableLbl AS CHARACTER INITIAL "Table:"
                      VIEW-AS TEXT SIZE 11 BY .76 FORMAT "X(11)"       NO-UNDO.
DEFINE VAR fldBCNameLbl AS CHARACTER INITIAL "Field:"
                      VIEW-AS TEXT SIZE 11 BY .76 FORMAT "X(11)"       NO-UNDO.
DEFINE VAR fldBCDataTypeLbl AS CHARACTER INITIAL "Data Type:"
                      VIEW-AS TEXT SIZE 11 BY .76 FORMAT "X(11)"       NO-UNDO.
DEFINE VAR fldBCFormatLbl AS CHARACTER INITIAL "Format:"
                      VIEW-AS TEXT SIZE 11 BY 1 FORMAT "X(11)"         NO-UNDO.
DEFINE VAR fldBCWidthLbl AS CHARACTER INITIAL "Width:"
                      VIEW-AS TEXT SIZE 11 BY 1 FORMAT "X(11)"         NO-UNDO.
DEFINE VAR fldBCDescriptionLbl AS CHARACTER INITIAL "Description:"
                      VIEW-AS TEXT SIZE 16.9 BY .76 FORMAT "X(20)"     NO-UNDO.
DEFINE VAR dfMasterLbl   AS CHARACTER INITIAL "* Datafield Master not defined":U 
                      VIEW-AS TEXT SIZE 35 BY .76                      NO-UNDO.

DEFINE VAR bcformat    AS CHARACTER VIEW-AS FILL-IN NATIVE 
                       SIZE 45 BY 1 FORMAT "X(256)":U                  NO-UNDO.
                                                 
DEFINE VAR convformat  AS CHARACTER                                    NO-UNDO.             

DEFINE VAR nonAmerican AS LOGICAL                                      NO-UNDO.                               

/* Query definitions                                                    */
DEFINE QUERY brw-flds FOR _BC SCROLLING.
define variable ghQuery            as handle                no-undo.
define variable ghBuffer           as handle                no-undo.
define variable ghField            as handle                no-undo.


/* Browse definitions                                                   */
DEFINE BROWSE brw-flds 
    QUERY brw-flds NO-LOCK DISPLAY 
      {&Mandatory}    FORMAT "m/"  
      {&HasDataField}
      {&EnableValue}
      _BC._DISP-NAME  FORMAT "X(256)"
    WITH NO-LABELS SINGLE NO-COLUMN-SCROLLING SIZE 38 BY 14.455.


/* ************************  Frame Definitions  *********************** */
/* ************************  bc-editor  Frame *********************** */

DEFINE FRAME bc-editor
     Flds-in-brws-lbl AT ROW 1.2 COL 2.5 NO-LABEL
     brw-flds AT ROW 1.92 COL 2.5
     b_add AT ROW 1.92 COL 42.4
     b_remove AT ROW 3.12 COL 42.4
     b_mv-up AT ROW 5.00 COL 42.4
     b_mv-dn AT ROW 6.20 COL 42.4
     enable-rect AT ROW 8.0 COL 43.4
     tog_disable_auto_zap AT ROW 8.5 COL 42.7
     tog_column_read_only AT ROW 9.25 COL 42.7
     tog_auto_return AT ROW 10.0 COL 42.7
     tog_enabled AT ROW 10.75 COL 42.7
     tog_visible AT ROW 12.00 COL 42.7
     tog_auto_resize AT ROW 12.75 COL 42.7
     b_enable AT ROW 13.95 COL 42.5
     b_disable AT ROW 15.15 COL 42.5
     col-attrs-lbl AT ROW 1.2 COL 69 NO-LABEL
     b_clr AT ROW 2.15 COL 73 NO-LABEL
     b_fnt AT ROW 2.15 COL 84 NO-LABEL
     b_attr AT ROW 2.15 COL 95 NO-LABEL
     b_view-as AT ROW 2.15 COL 106 NO-LABEL
     column-rect AT ROW 4.4 COL 69
     label-lbl AT ROW 3.95 COL 70 NO-LABEL
     _BC._DISP-NAME AT ROW 4.72 COL 70 VIEW-AS FILL-IN NATIVE
                 SIZE 45 BY 1 FORMAT "X(256)":U NO-LABEL
     _BC._LABEL AT ROW 4.72 COL 70 VIEW-AS FILL-IN NATIVE
                 SIZE 45 BY 1 FORMAT "X(256)":U NO-LABEL
     _BC._COL-LABEL AT ROW 5.72 COL 70 VIEW-AS FILL-IN native
                 SIZE 29 BY 1 FORMAT "x(256)":U NO-LABEL
     b_lbl-clr AT ROW 5.9 COL 70
     b_lbl-fnt AT ROW 5.9 COL 87 NO-LABEL
     format-rect AT ROW 8.35 COL 69
     format-lbl AT ROW 7.9 COL 70 NO-LABEL
     bcformat AT ROW 8.85 COL 70 NO-LABEL
     b_frm-hlp AT ROW 9.95 COL 85
     width-rect AT ROW 12.2 COL 69
     width-lbl AT ROW 11.8 COL 70 NO-LABEL
     _BC._WIDTH VIEW-AS FILL-IN NATIVE SIZE 45 BY 1
                 FORMAT ">>>>>>9.99":U AT ROW 12.7 COLUMN 70 NO-LABEL
     help-rect AT ROW 15.2 COL 69
     help-lbl AT ROW 14.8 COL 70 NO-LABEL
     _BC._HELP VIEW-AS FILL-IN NATIVE SIZE 45 BY 1
                 FORMAT "X(256)":U AT ROW 15.7 COL 70 NO-LABEL
     b_calc-fld AT ROW 16.575 COL 2.5
     b_edit     AT ROW 16.575 COL 25.5
     dfMasterLbl AT ROW 17.575 COL 74 NO-LABEL FORMAT "X(30)"
     fldBCDBNameLbl AT ROW 2.15 COLUMN 66 NO-LABEL
     _BC._DBNAME VIEW-AS TEXT SIZE 20 BY .7
                 FORMAT "X(256)":U NO-LABEL
                 AT ROW 2.15 COLUMN 76 COLON-ALIGNED
     fldBCTableLbl AT ROW 3.15 COLUMN 66 NO-LABEL
     _BC._TABLE VIEW-AS TEXT SIZE 20 BY .7
                 FORMAT "X(256)":U NO-LABEL 
                 AT ROW 3.15 COLUMN 76 COLON-ALIGNED
     fldBCNameLbl AT ROW 4.15 COLUMN 66 NO-LABEL
     _BC._NAME VIEW-AS TEXT SIZE 36 BY .7
                 FORMAT "X(256)":U NO-LABEL 
                 AT ROW 4.15 COLUMN 76 COLON-ALIGNED
     fldBCDataTypeLbl AT ROW 5.15 COLUMN 66 NO-LABEL
     _BC._DATA-TYPE VIEW-AS TEXT SIZE 20 BY .7
                 FORMAT "X(256)":U NO-LABEL
                 AT ROW 5.15 COLUMN 76 COLON-ALIGNED
     data_type NO-LABEL AT ROW 5.15 COLUMN 76 COLON-ALIGNED
                 
     fldBCDescriptionLbl AT ROW 6.15 COLUMN 66 NO-LABEL
     _BC._DEF-DESC VIEW-AS EDITOR SCROLLBAR-VERTICAL 
                 SIZE 49 BY 2.5 FORMAT "X(256)":U NO-LABEL
                 AT ROW 6.80 COLUMN 66
     fldBCFieldNameLbl AT ROW 9.87 COLUMN 66 NO-LABEL
     fldBCLABELLbl AT ROW 11 COLUMN 66 NO-LABEL
     fldBCColLabelLbl AT ROW 12.13 COLUMN 66 NO-LABEL
     fldBCFormatLbl AT ROW 13.26 COLUMN 66 NO-LABEL
     fldBCWidthLbl AT ROW 14.39 COLUMN 66 NO-LABEL
     b_advanced AT ROW 15.74 COLUMN 82.5
     rdonly-rect AT ROW 2.0 COLUMN 65
     advanced-rect AT ROW 9.5 COLUMN 65 
     col-attrs-rect AT ROW 1.6 COL 68

     {adecomm/okform.i
      &BOX    = "rect_btns"
      &STATUS = "no"
      &OK     = "btn_ok"
      &CANCEL = "btn_cancel"
      &HELP   = "btn_help"}
     empty-msg AT ROW 5  COL 9 NO-LABEL
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
         TITLE "Column Editor".

/* Using _numeric_separator and _numeric_decimal to determine if user is 
   using an Intl Numeric format other than American.  Can't use 
   SESSION:NUMERIC-FORMAT because when this is called from a wizard 
   SESSION:NUMERIC-FORMAT has been set to "AMERICAN" by qssuckr.p */
IF _numeric_separator <> "," OR _numeric_decimal <> "." THEN nonAmerican = TRUE.
ELSE nonAmerican = FALSE.


/* Help Trigger */
ON CHOOSE OF btn_help IN FRAME bc-editor OR HELP OF FRAME bc-editor
DO:
  IF isQuery THEN 
     RUN adecomm/_adehelp.p ("AB", "CONTEXT", {&Column_Editor_for_SmartDataObject}, ?).
  ELSE
     RUN adecomm/_adehelp.p ("AB", "CONTEXT", {&Column_Editor_Dlg_Box}, ?).
END.

ON VALUE-CHANGED OF data_type IN FRAME bc-editor DO:
  ASSIGN _BC._DATA-TYPE = data_type:SCREEN-VALUE.
  CASE _BC._DATA-TYPE:
    WHEN "Logical"       THEN bcFormat = "Yes/No":U.
    WHEN "Character":U   THEN bcFormat = "X(8)":U.
    WHEN "Integer":U     THEN bcFormat = "->,>>>,>>9":U.
    WHEN "INT64":U       THEN bcFormat = "->,>>>,>>>,>>9":U.
    WHEN "Decimal":U     THEN bcFormat = "->>,>>9.99":U.
    WHEN "Date":U        THEN bcFormat = "99/99/99":U.
    WHEN "DateTime":U    THEN bcFormat = "99/99/9999 HH:MM:SS.SSS":U.
    WHEN "DateTime-Tz":U THEN bcFormat = "99/99/9999 HH:MM:SS.SSS+HH:MM":U.
  END CASE.
  IF nonAmerican THEN
    RUN adecomm/_convert.p (INPUT "N-TO-A", 
                            INPUT bcformat,
                            INPUT _numeric_separator,
                            INPUT _numeric_decimal,
                            OUTPUT bcformat).

  DISPLAY bcFormat WITH FRAME bc-editor.
  APPLY "VALUE-CHANGED":U TO bcFormat IN FRAME bc-editor.
  APPLY "LEAVE":U TO bcFormat IN FRAME bc-editor.
END.

/* Run time layout for button area. */
{adecomm/okrun.i
   &FRAME = "FRAME bc-editor"
   &BOX   = "rect_btns"
   &OK    = "btn_ok"
   &HELP  = "btn_help"
}
 

/* ************************  sdoadv-dlg  Frame *********************** */

DEFINE FRAME sdoadv-dlg
        fldBCLabelLbl AT ROW 1.48 COLUMN 5 VIEW-AS TEXT 
        SIZE 8 BY .76  NO-LABEL /* override height because its used elsewhere */
     _BC._LABEL AT ROW 1.48 COL 15 COLON-ALIGNED VIEW-AS TEXT 
        &IF "{&WINDOW-SYSTEM}" EQ "OSF/MOTIF" &THEN SIZE 20 BY 1
        &ELSE SIZE 20 BY .7 &ENDIF FORMAT "X(256)":U NO-LABEL
        fldBCdbnamelbl AT ROW 1.48 COLUMN 45 NO-LABEL
     _BC._DBNAME AT ROW 1.48 COL 55 COLON-ALIGNED VIEW-AS TEXT 
        &IF "{&WINDOW-SYSTEM}" EQ "OSF/MOTIF" &THEN SIZE 20 BY 1
        &ELSE SIZE 20 BY .7 &ENDIF FORMAT "X(256)":U NO-LABEL
        fldBCDataTypeLbl AT ROW 2.67 COLUMN 5 NO-LABEL
     _BC._DATA-TYPE AT ROW 2.67 COL 15 COLON-ALIGNED VIEW-AS TEXT 
        &IF "{&WINDOW-SYSTEM}" EQ "OSF/MOTIF" &THEN SIZE 20 BY 1
        &ELSE SIZE 20 BY .7 &ENDIF FORMAT "X(256)":U NO-LABEL
        fldBCtablelbl AT ROW 2.67 COLUMN 45 NO-LABEL
     _BC._TABLE AT ROW 2.67 COL 55 COLON-ALIGNED VIEW-AS TEXT 
        &IF "{&WINDOW-SYSTEM}" EQ "OSF/MOTIF" &THEN SIZE 20 BY 1
        &ELSE SIZE 20 BY .7 &ENDIF FORMAT "X(256)":U NO-LABEL
     tog_inherit_validation AT ROW 4.30 COL 4
     _BC._DEF-VALEXP VIEW-AS EDITOR SCROLLBAR-VERTICAL
         SIZE 75 BY 2 FORMAT "X(256)":U NO-LABEL
        AT ROW 5.00 COL 5
     "Help Message:" VIEW-AS TEXT
          SIZE 57 BY .62 AT ROW 7.2 COL 4
     _BC._HELP VIEW-AS EDITOR SCROLLBAR-VERTICAL
        &IF "{&WINDOW-SYSTEM}" EQ "OSF/MOTIF" &THEN SIZE 77 BY 2.14
        &ELSE SIZE 75 BY 2 &ENDIF FORMAT "X(256)":U  NO-LABEL
        AT ROW 7.85 COL 5 
     {adecomm/okform.i
      &BOX    = "rect_btns"
      &STATUS = "no"
      &OK     = "btn_ok"
      &CANCEL = "btn_cancel"
      &HELP   = "btn_help"}
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE TITLE "Advanced".

DO WITH FRAME sdoadv-dlg:

ON VALUE-CHANGED OF tog_inherit_validation IN FRAME sdoadv-dlg DO:
  ASSIGN _BC._INHERIT-VALIDATION = SELF:CHECKED.
END.

/* Help Trigger */
ON CHOOSE OF btn_help IN FRAME sdoadv-dlg OR HELP OF FRAME sdoadv-dlg
DO:
   IF isQuery THEN
     RUN adecomm/_adehelp.p ("AB", "CONTEXT", {&Advanced_Dialog_for_Column_Editor_of_SmartDataObject}, ?).
   ELSE
     RUN adecomm/_adehelp.p ("AB", "CONTEXT", {&Column_Editor_Dlg_Box}, ?).
END.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME sdoadv-dlg APPLY "END-ERROR":U TO SELF.

/* Go */
ON GO OF FRAME sdoadv-dlg
  ASSIGN _BC._INHERIT-VALIDATION = tog_inherit_validation:CHECKED
         _BC._HELP               = _BC._HELP:SCREEN-VALUE.

/* Run time layout for button area. */
{adecomm/okrun.i
   &FRAME = "FRAME sdoadv-dlg"
   &BOX   = "rect_btns"
   &OK    = "btn_ok"
   &HELP  = "btn_help"
}

END. /* DO WITH FRAME sdoadv-dlg */
 
/* ***************  Runtime Attributes and UIB Settings  ************** */

/* These fields will contain blank for report
   make them as small as possible (move-column gave error message) */
IF isReport THEN
 ASSIGN
  EnableValue:WIDTH-P IN BROWSE brw-flds = 1
  _BC._Mandatory:WIDTH-P IN BROWSE brw-flds = 1
  . 
ELSE      
 ASSIGN 
   _BC._Mandatory:WIDTH IN BROWSE brw-flds = FONT-TABLE:GET-TEXT-WIDTH-CHARS("m").

IF NOT isSmartData OR NOT _DynamicsIsRunning THEN 
  hasDataField:WIDTH-P IN BROWSE brw-flds = 1.

IF isQuery then
do: 
    data_type:add-last("BLOB"). 
    data_type:add-last("CLOB").
end.   

ASSIGN 
       FRAME bc-editor:SCROLLABLE                     = FALSE
       brw-flds:NUM-LOCKED-COLUMNS IN FRAME bc-editor = 1
       brw-flds:MAX-DATA-GUESS IN FRAME bc-editor     = 20.



/* ************************  Control Triggers  ************************ */

ON CHOOSE OF b_add DO:
  RUN add-fields.ip.
  RUN enable_UI.
END.

ON VALUE-CHANGED OF tog_enabled DO:
  ASSIGN _BC._ENABLED = SELF:CHECKED.
  DISPLAY {&enableValue} WITH BROWSE brw-flds.
  RUN SetToggleState.ip.
END.

ON VALUE-CHANGED OF tog_disable_auto_zap DO:
  ASSIGN _BC._DISABLE-AUTO-ZAP = SELF:CHECKED.
END.

ON VALUE-CHANGED OF tog_column_read_only DO:
  ASSIGN _BC._COLUMN-READ-ONLY = SELF:CHECKED.
END.

ON VALUE-CHANGED OF tog_auto_return DO:
  ASSIGN _BC._AUTO-RETURN = SELF:CHECKED.
END.

ON VALUE-CHANGED OF tog_visible DO:
  ASSIGN _BC._VISIBLE = SELF:CHECKED.
END.  

ON VALUE-CHANGED OF tog_auto_resize DO:
  ASSIGN _BC._AUTO-RESIZE = SELF:CHECKED.
END.

ON LEAVE OF _BC._DISP-NAME IN FRAME bc-editor DO:
   DEFINE VARIABLE a-ok             AS LOGICAL   INITIAL TRUE NO-UNDO.
   DEFINE VARIABLE scrVal           AS CHARACTER              NO-UNDO.
   DEFINE BUFFER x_BC         FOR _BC.
   DEFINE BUFFER xx_BC        FOR _BC.

   /* Please note that if we leave the _BC._DISP-NAME fill in by 
    * moving the mouse to a different record in the browse, the
    * _BC buffer is updated with the new record in the browse,
    * hence the need to use cur-record
    */

   /* scrVal will contain the disp-name
    * cur-record contains the recid of record to be changed */
   ASSIGN scrVal = TRIM(_BC._DISP-NAME:SCREEN-VALUE). 
   FIND x_BC WHERE RECID(x_BC) = cur-record NO-ERROR.

   IF AVAILABLE x_BC THEN
   DO:
      /* Only check conflict if value-changed */
      IF x_BC._DISP-NAME <> scrVal THEN 
      DO:

        RUN adecomm/_valname.p (INPUT scrVal, FALSE, OUTPUT a-ok).
        IF NOT a-ok THEN
        DO:
           /* Only refresh the screen if we are still on the record */
           IF RECID(_BC) = cur-record THEN
              ASSIGN _BC._DISP-NAME:SCREEN-VALUE = _BC._DISP-NAME.
           ELSE
              ASSIGN _BC._DISP-NAME:SCREEN-VALUE = x_BC._DISP-NAME.
           RETURN.
        END. /* invalid */
        ELSE 
        DO:
         /* Find out if there is a renaming conflict, if there 
          * is suggest an unique name 
          */
           FIND FIRST xx_BC WHERE 
             xx_BC._x-recid = x_BC._x-recid 
             AND xx_BC._DISP-NAME = scrVal
             AND xx_BC._SEQUENCE <> x_BC._SEQUENCE NO-ERROR.
           IF AVAILABLE xx_BC THEN 
              ASSIGN a-ok = FALSE.
      
           IF NOT a-ok THEN 
           DO:
              /* Find unique name */
              IF isSmartData THEN
              RUN adeshar/_bstfnam.p (INPUT _query-u-rec, 
                                      INPUT scrVal,
                                      INPUT ?, 
                                      INPUT ?,
                                      OUTPUT UniqueName).
              MESSAGE 
                'There is a naming conflict. ' +
                'You are only allowed unique names.' SKIP(1)
                'You are attempting to rename a field from "' +  x_BC._DISP-NAME + '" to "' + scrVal + '".' SKIP
                'Would you like to rename the field to: "' + UniqueName + '"?'
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE ""
               UPDATE choice.
            CASE choice:
               WHEN TRUE THEN /* Yes */
               DO:
                  ASSIGN 
                     scrVal = UniqueName
                     a-ok = TRUE.
               END.
               OTHERWISE
                   ASSIGN a-ok = FALSE.
            END CASE. /* choice */
         END. /* Conflict */
      END. /* Not blank */
   
      IF a-ok THEN 
      DO:
        IF cur-record = RECID(_BC) THEN
           ASSIGN _BC._DISP-NAME = scrVal.
        ELSE
           ASSIGN x_BC._DISP-NAME = scrVal.

      END. /* No SDO naming conflict or resolved */
      ELSE RETURN NO-APPLY.
   END. /* VALUE CHANGED of DISP-NAME */
  END. /* AVAILABLE x_BC */
END. /* LEAVE of _DISP-NAME */

ON VALUE-CHANGED OF bcformat IN FRAME bc-editor
DO:
  DEFINE VARIABLE tmp-string AS CHARACTER                  NO-UNDO.

  RUN setWidth.ip (INPUT "Yes").
  First-Check = NO.
END.

ON LEAVE OF bcformat IN FRAME bc-editor DO:
   DEFINE VARIABLE a-ok             AS LOGICAL   INITIAL TRUE NO-UNDO.
   DEFINE VARIABLE scrVal           AS CHARACTER              NO-UNDO.

   DEFINE BUFFER x_BC         FOR _BC.
   DEFINE BUFFER xx_BC        FOR _BC.

   /* Please note that if we leave the _BC._FORMAT fill in by 
    * moving the mouse to a different record in the browse, the
    * _BC buffer is updated with the new record in the browse,
    * hence the need to use cur-record
    */

   /* scrVal will contain the disp-name
    * cur-record contains the recid of record to be changed */
   IF nonAmerican THEN 
     RUN adecomm/_convert.p (INPUT "N-TO-A", 
                             INPUT TRIM(bcformat:SCREEN-VALUE),
                             INPUT _numeric_separator,
                             INPUT _numeric_decimal,
                             OUTPUT scrVal).
       
   ELSE ASSIGN scrVal = TRIM(bcformat:SCREEN-VALUE).

   IF data_type:SCREEN-VALUE IN FRAME bc-editor EQ "Logical":U AND
     NOT First-Check THEN DO:
     IF NUM-ENTRIES(scrVal, "/":U) NE 2 THEN DO:
       MESSAGE '"':u + scrVal + '" is not a valid format for a logical value.  Enter a valid format.'
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       RETURN NO-APPLY.
     END.  /* If there isn't a "/" */
     First-Check = YES.
   END. /* If the data_type is logical */

   FIND x_BC WHERE RECID(x_BC) = cur-record NO-ERROR.

   IF AVAILABLE x_BC THEN
   DO:
      /* Only check conflict if value-changed */
      IF x_BC._FORMAT <> scrVal THEN 
      DO:
         /* Validate the format */
         IF isQuery THEN
         DO:
            ASSIGN dataType = IF x_BC._DATA-TYPE BEGINS "char"   THEN 1
                         ELSE IF x_BC._DATA-TYPE = "datetime"    THEN 34
                         ELSE IF x_BC._DATA-TYPE = "datetime-tz" THEN 40
                         ELSE IF x_BC._DATA-TYPE BEGINS "date"   THEN 2
                         ELSE IF x_BC._DATA-TYPE BEGINS "log"    THEN 3
                         ELSE IF x_BC._DATA-TYPE EQ "INT64"      THEN 41
                         ELSE 4.
            RUN adecomm/_chkfmt.p (dataType,"","",scrVal,
                             OUTPUT counter, OUTPUT lError).

            IF lError THEN 
            DO:
               /* Only refresh the screen if we are still on the record */
              IF RECID(_BC) = cur-record THEN
                IF nonAmerican THEN DO:
                  RUN adecomm/_convert.p (INPUT "N-TO-A",
                                          INPUT _BC._FORMAT,
                                          INPUT _numeric_separator,
                                          INPUT _numeric_decimal,
                                          OUTPUT convformat).
                  bcformat:SCREEN-VALUE = convformat.
                END.  /* if numeric-format not American */
                ELSE bcformat:SCREEN-VALUE = _BC._FORMAT.
              ELSE
                IF nonAmerican THEN DO:
                  RUN adecomm/_convert.p (INPUT "N-TO-A",
                                          INPUT x_BC._FORMAT,
                                          INPUT _numeric_separator,
                                          INPUT _numeric_decimal,
                                          OUTPUT convformat).
                  bcformat:SCREEN-VALUE = convformat.
                END.  /* if numeric-format not American */
                ELSE 
                 ASSIGN bcformat:SCREEN-VALUE = x_BC._FORMAT.
               /* Reset the width */
               RUN setWidth.ip (INPUT "NO").
               RETURN NO-APPLY.
            END.
        END.
        /* Only refresh the screen if we are still on the record */
        IF RECID(_BC) = cur-record THEN
          IF nonAmerican THEN DO:
            RUN adecomm/_convert.p (INPUT "N-TO-A",
                                    INPUT _BC._FORMAT,
                                    INPUT _numeric_separator,
                                    INPUT _numeric_decimal,
                                     OUTPUT convformat).
            ASSIGN bcformat = convformat.
          END.  /* if numeric-format not American */
          ELSE ASSIGN bcformat = _BC._FORMAT.
        ELSE
          IF nonAmerican THEN DO:
            RUN adecomm/_convert.p (INPUT "N-TO-A",
                                    INPUT x_BC._FORMAT,
                                    INPUT _numeric_separator,
                                    INPUT _numeric_decimal,
                                    OUTPUT convformat).
            bcformat:SCREEN-VALUE = convformat.
          END.  /* if numeric-format not American */
          ELSE ASSIGN bcformat:SCREEN-VALUE = x_BC._FORMAT.

        /* Update the _FORMAT record of cur-record */
        IF cur-record = RECID(_BC) THEN
           ASSIGN _BC._FORMAT = scrVal.
        ELSE
           ASSIGN x_BC._FORMAT = scrVal.

   END. /* _format value changed */
  END. /* AVAILABLE x_BC */
END. /* LEAVE of _FORMAT */

ON VALUE-CHANGED OF _BC._LABEL IN FRAME bc-editor DO:
   ASSIGN _BC._LABEL.
END. /* VALUE-CHANGED of LABEL */

ON VALUE-CHANGED OF _BC._COL-LABEL IN FRAME bc-editor DO:
   ASSIGN _BC._COL-LABEL.
END. /* VALUE-CHANGED of COL-LABEL */

ON VALUE-CHANGED OF _BC._WIDTH IN FRAME bc-editor DO:
   IF DECIMAL(SELF:SCREEN-VALUE) > 650.0 THEN SELF:SCREEN-VALUE = "650.00".
   ELSE IF DECIMAL(SELF:SCREEN-VALUE) < .0 THEN SELF:SCREEN-VALUE = "0.00".
END. /* VALUE-CHANGED of LABEL */

ON MOUSE-SELECT-DBLCLICK OF brw-flds DO:
  IF isReport OR (_BC._DBNAME = "_<CALC>" AND NOT isSmartData) THEN RETURN NO-APPLY.
  ASSIGN _BC._ENABLED                           = NOT _BC._ENABLED
         tog_enabled:CHECKED IN FRAME bc-editor = _BC._ENABLED.
  DISPLAY {&enableValue} WITH BROWSE brw-flds.
  RUN SetToggleState.ip.
END.
         
ON CHOOSE OF b_enable, b_disable DO:
  RELEASE _BC.
  
  FOR EACH _BC WHERE _BC._x-recid = _query-u-rec AND
                    (_BC._DBNAME NE "_<CALC>":U OR isSmartData):
    IF isQuery THEN
       _BC._ENABLED = (SELF:LABEL = "All U&pdateable").
    ELSE
       _BC._ENABLED = (SELF:LABEL = "&Enable All").
  END.

  ASSIGN dummy = brw-flds:SET-REPOSITIONED-ROW(brw-flds:FOCUSED-ROW, "CONDITIONAL").
  /* Reopen browse */
  {&OPEN-QUERY-brw-flds}
  REPOSITION brw-flds TO RECID cur-record.
  RUN enable_UI.
  ASSIGN cur-record = RECID(_BC).  
  RUN display_bc.ip.
END.

ON CHOOSE OF b_clr DO:
  FIND _U WHERE RECID(_U) = _query-u-rec.
  FIND _L WHERE RECID(_L) = _U._lo-recid.
  
  RUN adecomm/_chscolr.p
       (INPUT "Choose Color",
        INPUT (""),
        INPUT FALSE,       /* separators */
        INPUT _L._BGCOLOR, /* parent_bgcolor */
        INPUT _L._FGCOLOR, /* parent_fgcolor */
        INPUT ?,           /* separators */
        INPUT-OUTPUT _BC._BGCOLOR,
        INPUT-OUTPUT _BC._FGCOLOR,
        INPUT-OUTPUT sep_fgc,
        OUTPUT dummy).
        
END.

ON CHOOSE OF b_calc-fld DO:
  DEFINE VARIABLE i                 AS INTEGER          NO-UNDO. 
  DEFINE VARIABLE pCurrentDB        AS CHAR             NO-UNDO.
  DEFINE VARIABLE pTbl              AS CHAR             NO-UNDO. 
  DEFINE VARIABLE pSelectedTables   AS CHAR             NO-UNDO.
  DEFINE VARIABLE pInputExpression  AS CHAR             NO-UNDO.
  DEFINE VARIABLE pOutputExpression AS CHAR             NO-UNDO.
  DEFINE VARIABLE TestValue         AS CHAR             NO-UNDO.
  DEFINE VARIABLE pOk               AS LOGICAL          NO-UNDO.
  DEFINE VARIABLE pDB-RECID         AS RECID            NO-UNDO.
  DEFINE VARIABLE pErrorStatus      AS LOGICAL          NO-UNDO.
  DEFINE VARIABLE EditFlag          AS LOGICAL          NO-UNDO.
  DEFINE VARIABLE iNumTable         AS INTEGER          NO-UNDO.
  DEFINE VARIABLE cTableList        AS CHARACTER        NO-UNDO.

  IF AVAILABLE _BC THEN  
    ASSIGN pCurrentDB        = IF isSmartData THEN STRING(_query-u-rec)
                               ELSE IF _BC._DBNAME NE "_<CALC>":U
                                 THEN _BC._DBNAME ELSE ldbname("DICTDB")
           pTbl              = IF isSmartData THEN "RowObject"
                               ELSE IF _BC._DBNAME NE "_<CALC>":U
                                 THEN (IF NUM-ENTRIES(ENTRY(1,Tbl-List),".":U) = 2 THEN
                                   pCurrentDB + "." + _BC._TABLE ELSE _BC._TABLE)
                                 ELSE ENTRY(1,Tbl-List)
           pSelectedTables   = IF isSmartData THEN "RowObject" ELSE Tbl-List
           TestValue         = IF isSmartData THEN TRIM(_BC._NAME) 
                                              ELSE TRIM(_BC._DISP-NAME)
           pInputExpression  = ""
           EditFlag          = FALSE. 
  ELSE
    ASSIGN pCurrentDB       = IF isSmartData THEN STRING(_query-u-rec)
                              ELSE IF _BC._DBNAME NE "_<CALC>":U
                                   THEN _BC._DBNAME ELSE ldbname("DICTDB")
           pTbl             = ""
           pSelectedTables  = Tbl-List
           TestValue        = ""
           pInputExpression = ""
           EditFlag         = FALSE.
       
  /* Invoke the calculated field selector for dynamic SDOs and gets data 
     from the calculated field selector (or from a new calculated field).
     _BC._NAME stores the master calculated field name
     _BC._DISP-NAME stores the instance name
     For static SDOs _NAME stores the field expression and _DISP-NAME stores 
     the name. */
  IF isDynSDO THEN
  DO:
    lNewCalc = FALSE.
    DO iNumTable = 1 TO NUM-ENTRIES(Tbl-List):
      IF ENTRY(1, ENTRY(iNumTable, Tbl-List), ".":U) = "Temp-Tables":U THEN
      DO:
        FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
            _TT._name = ENTRY(2, ENTRY(iNumTable, Tbl-List), ".":U) AND
            _TT._table-type = "B":U NO-ERROR.
        IF AVAILABLE _TT THEN
          cTableList = cTableList + (IF NUM-ENTRIES(cTableList) > 0 THEN ",":U ELSE '':U) + 
                       "Temp-Tables":U + ".":U + _TT._like-table.
        ELSE 
          cTableList = cTableList + (IF NUM-ENTRIES(cTableList) > 0 THEN ",":U ELSE '':U) + 
                       ENTRY(iNumTable, Tbl-List).  
      END.
      ELSE 
        cTableList = cTableList + (IF NUM-ENTRIES(cTableList) > 0 THEN ",":U ELSE '':U) + 
                     ENTRY(iNumTable, Tbl-List).
    END.
    RUN adeuib/_calcselg.w 
        (INPUT  cTableList,
         OUTPUT pOutputExpression,
         OUTPUT UniqueName,
         OUTPUT cCalcDataType,
         OUTPUT cCalcLabel,
         OUTPUT cCalcColLabel,
         OUTPUT cCalcFormat,
         OUTPUT cCalcHelp,
         OUTPUT lNewCalc,
         OUTPUT cCalcClass,
         OUTPUT cCalcModule,
         OUTPUT pOK).
    IF NOT pOK THEN RETURN.    
  END.
  ELSE DO:
    RUN adeshar/_calcfld.p (pCurrentDB,
                            pTbl,
                            p_hSmartData,
                            pSelectedTables, 
                            pInputExpression,
                            "{&UIB_SHORT_NAME}":U,
                            this-is-a-SB,
                            isSmartData,
                            tt-info,
                            OUTPUT pOutputExpression,
                            OUTPUT pErrorStatus, 
                            OUTPUT pOk).
  
    /* After Ok or Cancel button have been pressed do the following */      
    IF NOT pOk THEN RETURN.   /* if NOT pErrorStatus then return. */

    IF pOutputExpression = "()":U OR pOutputExpression = "" THEN RETURN.
  END.

  IF empty-flg THEN
    ASSIGN empty-flg                              = FALSE
           empty-msg:VISIBLE   IN FRAME bc-editor = FALSE 
           empty-msg:SENSITIVE IN FRAME bc-editor = FALSE.  

  FIND LAST _BC WHERE _BC._x-recid = _query-u-rec NO-LOCK NO-ERROR.
  IF NOT AVAILABLE(_BC) THEN
      ASSIGN cur-seq = 1.
  ELSE
      ASSIGN cur-seq = _BC._SEQUENCE + 1.

  /* Find unique name */
  IF isSmartData AND NOT isDynSDO THEN
    RUN adeshar/_bstfnam.p (INPUT _query-u-rec, INPUT "CALC", INPUT ?, INPUT ?,
                            OUTPUT UniqueName).

  CREATE _BC.
  ASSIGN _BC._x-recid   = _query-u-rec
         _BC._SEQUENCE  = cur-seq
         _BC._DBNAME    = "_<CALC>":U
         _BC._TABLE     = ?
         _BC._DISP-NAME = IF isSmartData THEN UniqueName 
                                         ELSE pOutputExpression
         _BC._NAME      = IF isSmartData THEN pOutputExpression 
                                         ELSE _BC._NAME
         _BC._DATA-TYPE = IF isSmartData AND NOT isDynSDO THEN "character":U
                          ELSE IF isDynSDO THEN cCalcDataType
                          ELSE _BC._DATA-TYPE
         _BC._FORMAT    = IF isSmartData AND NOT isDynSDO THEN "x(8)":U
                          ELSE IF isDynSDO THEN cCalcFormat
                          ELSE _BC._FORMAT
         _BC._HAS-DATAFIELD-MASTER = IF isSmartData AND lNewCalc THEN TRUE ELSE FALSE
         _BC._HELP      = IF isDynSDO THEN cCalcHelp 
                                      ELSE "":U
         _BC._LABEL     = IF isDynSDO THEN cCalcLabel
                                      ELSE "":U
         _BC._COL-LABEL = IF isDynSDO THEN cCalcColLabel
                                      ELSE "":U
         cur-record     = RECID(_BC).

  /* The _STATUS field is used when saving the SDO for two purposes:
     1) To determine whether a calculated field is a new calculated field
        created by the calculated field selector.  It also stores the
        class, module and column label for the new calculated field, 
        its other info (label, datatype, format and help) is stored in
        their appropriate _BC fields.
     2) For static SDOs it is set to 'STATIC' so that saving a static SDO
        as dynamic saves the calculated field properly */
  IF isDynSDO AND lNewCalc THEN
    _BC._STATUS = 'NEWCALC':U + CHR(3) + 
                   cCalcClass + CHR(3) +
                   cCalcModule + CHR(3) +
                   IF cCalcColLabel = ? THEN '?':U ELSE cCalcColLabel.
  ELSE IF isSmartData AND NOT isDynSDO THEN
    _BC._STATUS = 'STATIC':U.
  
  IF isSmartData AND NOT isDynSDO THEN DO:
    RUN adecomm/_chkfmt.p (1,"","",_BC._FORMAT, 
                                OUTPUT counter, OUTPUT lError).
    ASSIGN _BC._WIDTH = IF NOT lError THEN MIN(650,counter) ELSE ?.

    FIND FIRST xx_U WHERE xx_U._WINDOW-HANDLE = _U._WINDOW-HANDLE
                      AND xx_U._TYPE = "WINDOW":U
                      AND xx_U._STATUS = "NORMAL":U.
    FIND FIRST _TRG WHERE _TRG._tSection = "_PROCEDURE":U 
                      AND _TRG._wRECID = RECID(xx_U)
                      AND _TRG._tSPECIAL = "DATA.CALCULATE":U
                      AND _TRG._tCODE    = ?  NO-ERROR.
    IF NOT AVAILABLE _TRG THEN 
    DO:
       CREATE _TRG.
       ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
              _TRG._tSection = "_PROCEDURE":U
              _TRG._wRECID   = RECID(xx_U) 
              _TRG._tCODE    = ?
              _TRG._STATUS   = "NORMAL":U
              _TRG._tSPECIAL = "DATA.CALCULATE":U
              _TRG._tEVENT   = "DATA.CALCULATE":U
       .
    END. /* Create _TRG */
    ELSE ASSIGN _TRG._STATUS = "NORMAL":U.
  END.
  
  IF brw-flds:FOCUSED-ROW NE ? THEN                      
    ASSIGN dummy = brw-flds:SET-REPOSITIONED-ROW(brw-flds:FOCUSED-ROW,                                                  "CONDITIONAL").
  
  {&OPEN-QUERY-brw-flds}
  REPOSITION brw-flds TO RECID cur-record.
  RUN enable_UI.
END.

ON CHOOSE OF b_edit DO:
  DEFINE VARIABLE i                 AS INTEGER          NO-UNDO. 
  DEFINE VARIABLE pCurrentDB        AS CHAR             NO-UNDO.
  DEFINE VARIABLE pTbl              AS CHAR             NO-UNDO. 
  DEFINE VARIABLE pSelectedTables   AS CHAR             NO-UNDO.
  DEFINE VARIABLE pInputExpression  AS CHAR             NO-UNDO.
  DEFINE VARIABLE pOutputExpression AS CHAR             NO-UNDO.
  DEFINE VARIABLE TestValue         AS CHAR             NO-UNDO.
  DEFINE VARIABLE pOk               AS LOGICAL          NO-UNDO.
  DEFINE VARIABLE pDB-RECID         AS RECID            NO-UNDO.
  DEFINE VARIABLE pErrorStatus      AS LOGICAL          NO-UNDO.
  DEFINE VARIABLE EditFlag          AS LOGICAL          NO-UNDO.
  
  IF AVAILABLE _BC THEN  
    ASSIGN pCurrentDB        = IF isSmartData THEN STRING(_query-u-rec)
                                              ELSE ldbname("DICTDB")
           pTbl              = IF isSmartData THEN "RowObject"
                                              ELSE ENTRY(1,Tbl-List)
           pSelectedTables   = IF isSmartData THEN "RowObject"
                                              ELSE Tbl-List
           TestValue         = IF isSmartData THEN TRIM(_BC._NAME) 
                                              ELSE TRIM(_BC._DISP-NAME)
           pInputExpression  = TestValue
           EditFlag          = IF pInputExpression <> "" THEN True ELSE False. 
  ELSE DO:
    /* This shouls never happen */
    MESSAGE "You may not edit database fields." VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
         
  RUN adeshar/_calcfld.p (pCurrentDB,
                          pTbl,
                          p_hSmartData,
                          pSelectedTables, 
                          pInputExpression,
                          "{&UIB_SHORT_NAME}":U,
                          this-is-a-SB,
                          isSmartData,
                          tt-info,
                          OUTPUT pOutputExpression,
                          OUTPUT pErrorStatus, 
                          OUTPUT pOk).
                          
  /* After Ok or Cancel button have been pressed do the following */      
  IF NOT pOk THEN RETURN.   /* if NOT pErrorStatus then return. */
  
  IF pOutputExpression = "()":U OR pOutputExpression = "" THEN RETURN.

  IF empty-flg THEN
    ASSIGN empty-flg                              = FALSE
           empty-msg:VISIBLE   IN FRAME bc-editor = FALSE 
           empty-msg:SENSITIVE IN FRAME bc-editor = FALSE.  

  IF EditFlag THEN  /* This is an modify not an add */
  ASSIGN
    _BC._DISP-NAME         = IF isSmartData THEN _BC._DISP-NAME 
                                            ELSE pOutputExpression
    _BC._NAME              = IF isSmartData THEN pOutputExpression 
                                            ELSE _BC._NAME.
  
  IF brw-flds:FOCUSED-ROW NE ? THEN                      
    ASSIGN dummy = brw-flds:SET-REPOSITIONED-ROW(brw-flds:FOCUSED-ROW,
                                                  "CONDITIONAL").
  
  {&OPEN-QUERY-brw-flds}
  REPOSITION brw-flds TO RECID cur-record.
  RUN enable_UI.
END.

ON CHOOSE OF b_lbl-clr DO:
  FIND _U WHERE RECID(_U) = _query-u-rec.
  FIND _L WHERE RECID(_L) = _U._lo-recid.
  
  RUN adecomm/_chscolr.p
       (INPUT "Choose Color",
        INPUT (""),
        INPUT FALSE,       /* separators */
        INPUT _L._BGCOLOR, /* parent_bgcolor */
        INPUT _L._FGCOLOR, /* parent_fgcolor */
        INPUT ?,           /* separators */
        INPUT-OUTPUT _BC._LABEL-BGCOLOR,
        INPUT-OUTPUT _BC._LABEL-FGCOLOR,
        INPUT-OUTPUT sep_fgc,
        OUTPUT dummy).
        
END.

ON CHOOSE OF b_fnt DO:
  FIND _U WHERE RECID(_U) = _query-u-rec.
  FIND _L WHERE RECID(_L) = _U._lo-recid.
  
  IF _U._LAYOUT-NAME NE "Master Layout" THEN DO:
    MESSAGE "The font of a browse may not be changed between layouts."
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
  END.  

  RUN adecomm/_chsfont.p  (INPUT "Choose Font",
                           INPUT _L._FONT,
                           INPUT-OUTPUT _BC._FONT,
                           OUTPUT dummy).
END.

ON CHOOSE OF b_attr DO:
   RUN adeuib/_attredt.w (INPUT _U._HANDLE, INPUT RECID(_BC)).
END. /* Choose of b_attr */

ON CHOOSE OF b_view-as DO:
DEFINE VARIABLE cColumnType           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnDelimiter      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnItems          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnItemPairs      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnInnerLines     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnMaxChars       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnSort           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnAutoCompletion AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnUniqueMatch    AS CHARACTER NO-UNDO.

DEFINE VARIABLE cCancel AS LOGICAL     NO-UNDO.

DEFINE VARIABLE isSourceDataView AS LOGICAL     NO-UNDO.

ASSIGN isSourceDataView = VALID-HANDLE(p_hSmartData) AND DYNAMIC-FUNCTION('getObjectType':U IN p_hSmartData) = "SmartDataObject":U AND
                                                         NOT DYNAMIC-FUNCTION('getDBAware':U IN p_hSmartData)
       cColumnDelimiter      = IF _BC._VIEW-AS-DELIMITER = "," THEN "?" ELSE _BC._VIEW-AS-DELIMITER
       cColumnItems          = IF _BC._VIEW-AS-ITEMS = ? THEN "" ELSE _BC._VIEW-AS-ITEMS
       cColumnItemPairs      = IF _BC._VIEW-AS-ITEM-PAIRS = ? THEN "" ELSE _BC._VIEW-AS-ITEM-PAIRS
       cColumnInnerLines     = STRING(IF _BC._VIEW-AS-INNER-LINES = 0 THEN 5 ELSE _BC._VIEW-AS-INNER-LINES)
       cColumnMaxChars       = STRING(_BC._VIEW-AS-MAX-CHARS)
       cColumnSort           = IF _BC._VIEW-AS-SORT THEN "Y":U ELSE "?"
       cColumnAutoCompletion = IF _BC._VIEW-AS-AUTO-COMPLETION THEN "Y":U ELSE "?"
       cColumnUniqueMatch    = IF _BC._VIEW-AS-UNIQUE-MATCH THEN "Y":U ELSE "?".

CASE _BC._VIEW-AS-TYPE:
    WHEN "Toggle-box":U     THEN ASSIGN cColumnType = "TB":U.
    WHEN "DROP-DOWN":U      THEN ASSIGN cColumnType = "DD":U.
    WHEN "DROP-DOWN-LIST":U THEN ASSIGN cColumnType = "DDL":U.
    OTHERWISE ASSIGN cColumnType = "Fill-in":U.
END CASE.

RUN adecomm/_viewasd.w (INPUT IF isSourceDataView THEN _BC._DISP-NAME ELSE _BC._NAME,
                        INPUT _BC._DATA-TYPE,
                        INPUT IF _BC._FORMAT = ? OR _BC._FORMAT = "" THEN _BC._DEF-FORMAT ELSE _BC._FORMAT,
                        INPUT IF _P.static_object THEN "STATIC":U ELSE "SmartDataBrowser":U,
                        INPUT-OUTPUT cColumnType,
                        INPUT-OUTPUT cColumnDelimiter,
                        INPUT-OUTPUT cColumnItems,
                        INPUT-OUTPUT cColumnItemPairs,
                        INPUT-OUTPUT cColumnInnerLines,
                        INPUT-OUTPUT cColumnMaxChars,
                        INPUT-OUTPUT cColumnSort,
                        INPUT-OUTPUT cColumnAutoCompletion,
                        INPUT-OUTPUT cColumnUniqueMatch,
                        OUTPUT cCancel).

IF cCancel = TRUE THEN
    RETURN NO-APPLY.

CASE cColumnType:
    WHEN "DD":U  THEN ASSIGN _BC._VIEW-AS-TYPE = "DROP-DOWN":U.
    WHEN "DDL":U THEN ASSIGN _BC._VIEW-AS-TYPE = "DROP-DOWN-LIST":U.
    WHEN "TB":U  THEN ASSIGN _BC._VIEW-AS-TYPE = "TOGGLE-BOX":U.
    OTHERWISE ASSIGN _BC._VIEW-AS-TYPE = "FILL-IN".
END CASE.

ASSIGN _BC._VIEW-AS-DELIMITER       = IF cColumnDelimiter = ? OR cColumnDelimiter = "" THEN "," ELSE cColumnDelimiter
       _BC._VIEW-AS-ITEMS           = IF cColumnItems = "" THEN ? ELSE cColumnItems
       _BC._VIEW-AS-ITEM-PAIRS      = IF cColumnItemPairs = "" THEN ? ELSE cColumnItemPairs
       _BC._VIEW-AS-INNER-LINES     = INT(cColumnInnerLines)
       _BC._VIEW-AS-MAX-CHARS       = INT(cColumnMaxChars)
       _BC._VIEW-AS-SORT            = IF cColumnSort = "Y":U THEN TRUE ELSE FALSE
       _BC._VIEW-AS-AUTO-COMPLETION = IF cColumnAutoCompletion = "Y":U THEN TRUE ELSE FALSE
       _BC._VIEW-AS-UNIQUE-MATCH    = IF cColumnUniqueMatch = "Y":U THEN TRUE ELSE FALSE.
END. /* Choose of b_view-as */

ON CHOOSE OF b_lbl-fnt DO:
  FIND _U WHERE RECID(_U) = _query-u-rec.
  FIND _L WHERE RECID(_L) = _U._lo-recid.
  
  IF _U._LAYOUT-NAME NE "Master Layout" THEN DO:
    MESSAGE "The font of a browse may not be changed between layouts."
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
  END.  

  RUN adecomm/_chsfont.p  (INPUT "Choose Font",
                           INPUT _L._FONT,
                           INPUT-OUTPUT _BC._LABEL-FONT,
                           OUTPUT dummy).
END.


ON CHOOSE OF b_frm-hlp DO:
  DEF VAR fmt      AS CHAR CASE-SENSITIVE NO-UNDO.
  
  fmt = bcformat:SCREEN-VALUE.

  CASE _BC._DATA-TYPE:
    WHEN "CHARACTER":U   THEN RUN adecomm/_y-build.p ( 1, INPUT-OUTPUT fmt).
    WHEN "DATE":U        THEN RUN adecomm/_y-build.p ( 2, INPUT-OUTPUT fmt).
    WHEN "DATETIME":U    THEN RUN adecomm/_y-build.p (34, INPUT-OUTPUT fmt).
    WHEN "DATETIME-TZ":U THEN RUN adecomm/_y-build.p (40, INPUT-OUTPUT fmt).
    WHEN "LOGICAL":U     THEN RUN adecomm/_y-build.p ( 3, INPUT-OUTPUT fmt).
    WHEN "DECIMAL":U     THEN RUN adecomm/_y-build.p ( 5, INPUT-OUTPUT fmt). 
    WHEN "RECID":U       THEN RUN adecomm/_y-build.p ( 7, INPUT-OUTPUT fmt).
    OTHERWISE                 RUN adecomm/_y-build.p ( 4, INPUT-OUTPUT fmt).
  END CASE.
  
  /* Update value */
  IF bcformat:SCREEN-VALUE NE fmt THEN DO:
    ASSIGN bcformat:SCREEN-VALUE = fmt.
    IF nonAmerican THEN DO:
      RUN adecomm/_convert.p (INPUT "N-TO-A",
                              INPUT fmt,
                              INPUT _numeric_separator,
                              INPUT _numeric_decimal,
                              OUTPUT convformat).
      _BC._FORMAT = convformat.
    END.  /* if numeric-format not American */
    ELSE _BC._FORMAT = fmt.
    APPLY "VALUE-CHANGED" TO bcformat IN FRAME bc-editor.
  END.
END.


ON VALUE-CHANGED OF brw-flds DO:
  DEFINE BUFFER x_BC FOR _BC.

  FIND x_BC WHERE RECID(x_BC) = cur-record NO-ERROR.

  IF AVAILABLE x_BC THEN DO: 
    cur-record = RECID(_BC). 
    IF isQuery THEN  /* Building a SmartData Object or WebReport */
      /* Regardless whether it is calc field or not */
      ASSIGN x_BC._LABEL  = _BC._LABEL:SCREEN-VALUE
             x_BC._DISP-NAME  = _BC._DISP-NAME:SCREEN-VALUE.
    ELSE IF srcSmartData THEN /* SmartData as Source */ 
      ASSIGN x_BC._WIDTH = DECIMAL(_BC._WIDTH:SCREEN-VALUE)
             x_BC._HELP  = _BC._HELP:SCREEN-VALUE
             x_BC._LABEL = _BC._LABEL:SCREEN-VALUE.
    ELSE   /* Smart or Regular Browse */
      ASSIGN x_BC._HELP   = _BC._HELP:SCREEN-VALUE
             x_BC._LABEL  = _BC._LABEL:SCREEN-VALUE
             x_BC._WIDTH  = DECIMAL(_BC._WIDTH:SCREEN-VALUE).
  END. /* Found the _BC record */
  RUN display_bc.ip.
END. /* On value-changed of brw-flds */


ON CHOOSE OF b_mv-dn DO:
  DEFINE VARIABLE cur-row AS INTEGER                               NO-UNDO.
  DEFINE VARIABLE cur-rec AS RECID                                 NO-UNDO.
  DEFINE VARIABLE nxt-rec AS RECID                                 NO-UNDO.
  DEFINE BUFFER x_BC FOR _BC.
  
  ASSIGN cur-rec = RECID(_BC)
         i       = brw-flds:FOCUSED-ROW.
  FIND x_BC WHERE x_BC._x-recid = _query-u-rec AND
                  x_BC._SEQUENCE = _BC._SEQUENCE + 1 NO-ERROR.
  IF AVAILABLE x_BC THEN DO:
    ASSIGN x_BC._SEQUENCE = ?.
    ASSIGN _BC._SEQUENCE  = _BC._SEQUENCE + 1
           x_BC._SEQUENCE = _BC._SEQUENCE - 1.
    {&OPEN-QUERY-brw-flds}
    
    dummy = brw-flds:SET-REPOSITIONED-ROW(MIN(i + 1,brw-flds:NUM-ITERATIONS),
                                             "CONDITIONAL":U).
    REPOSITION brw-flds TO RECID cur-rec.
    dummy = brw-flds:SELECT-FOCUSED-ROW().
    cur-record = RECID(_BC).
    RUN display_bc.ip.
    IF RECID(x_BC) = last-rec THEN DO:
      ASSIGN last-rec       = RECID(_BC)
             SELF:SENSITIVE = FALSE.
    END.
    IF RECID(_BC) = first-rec THEN DO:
      ASSIGN first-rec         = RECID(x_BC)
             b_mv-up:SENSITIVE = TRUE.
    END.
  END.
END.

ON CHOOSE OF b_mv-up DO:
  DEFINE VARIABLE cur-row AS INTEGER                               NO-UNDO.
  DEFINE VARIABLE cur-rec AS RECID                                 NO-UNDO.
  DEFINE VARIABLE nxt-rec AS RECID                                 NO-UNDO.
  DEFINE BUFFER x_BC FOR _BC.
  
  ASSIGN cur-rec = RECID(_BC)
         i       = brw-flds:FOCUSED-ROW.
  FIND x_BC WHERE x_BC._x-recid = _query-u-rec AND
                  x_BC._SEQUENCE = _BC._SEQUENCE - 1 NO-ERROR.
  IF AVAILABLE x_BC THEN DO:
    ASSIGN x_BC._SEQUENCE = ?.
    ASSIGN _BC._SEQUENCE  = _BC._SEQUENCE - 1
           x_BC._SEQUENCE = _BC._SEQUENCE + 1.
    {&OPEN-QUERY-brw-flds}
    
    dummy = brw-flds:SET-REPOSITIONED-ROW(MAX(1,i - 1)).
    REPOSITION brw-flds TO RECID cur-rec.
    dummy = brw-flds:SELECT-FOCUSED-ROW().
    cur-record = RECID(_BC).
    RUN display_bc.ip.
    IF RECID(x_BC) = first-rec THEN DO:
      ASSIGN first-rec      = RECID(_BC)
             SELF:SENSITIVE = FALSE.
    END.
    IF RECID(_BC) = last-rec THEN DO:
      ASSIGN last-rec          = RECID(x_BC)
             b_mv-dn:SENSITIVE = TRUE.
    END.
  END.
END.

ON CHOOSE OF b_remove DO:
  DEFINE VARIABLE this-seq   AS INTEGER NO-UNDO.
  
  ASSIGN this-seq   = _BC._SEQUENCE.
  FOR EACH _TRG WHERE _TRG._wRECID = RECID(_BC):
    DELETE _TRG.
  END.
  DELETE _BC.
  /* close the sequence gap */
  FOR EACH _BC WHERE _BC._x-recid = _query-u-rec AND _BC._SEQUENCE > this-seq:
    _BC._SEQUENCE = _BC._SEQUENCE - 1.
  END.
  FIND _BC WHERE _BC._x-recid = _query-u-rec AND
                 _BC._SEQUENCE = this-seq NO-ERROR.
  IF NOT AVAILABLE _BC THEN  /* we removed the last one */
    FIND _BC WHERE _BC._x-recid = _query-u-rec AND
                   _BC._SEQUENCE = this-seq - 1 NO-ERROR.

  cur-record = IF AVAILABLE _BC THEN RECID(_BC) ELSE ?.
  {&OPEN-QUERY-brw-flds}
  
  ASSIGN dummy = brw-flds:SET-REPOSITIONED-ROW(brw-flds:FOCUSED-ROW, "CONDITIONAL":U).

  IF cur-record NE ? THEN REPOSITION brw-flds TO RECID cur-record.
  IF AVAILABLE _BC THEN DO:
    cur-record        = RECID(_BC).
    RUN display_bc.ip.
  END. 
  ELSE DO:
    ASSIGN cur-record = ?
           first-rec = ?.
    RUN enable_UI.
  END.
END.

ON CHOOSE OF b_advanced DO:
  RUN advanced.ip.
  HIDE FRAME sdoadv-dlg.
  RUN enable_UI.
END.

/* ***************************  Main Block  *************************** */
/* Determine icon size */
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  ASSIGN icon-hp = MIN(38, 1.55 * SESSION:PIXELS-PER-ROW)
         icon-wp = MIN(36, 5 * SESSION:PIXELS-PER-COLUMN).
  IF SESSION:PIXELS-PER-COLUMN = 5 AND SESSION:PIXELS-PER-ROW = 21 THEN
    ASSIGN icon-hp = 31
           icon-wp = 31.
  IF SESSION:WIDTH-PIXELS = 640 AND SESSION:PIXELS-PER-COLUMN = 6 THEN
    ASSIGN icon-hp = 32
           icon-wp = 34.
  icon-hp = MIN(icon-hp, 34).
&ELSE
  ASSIGN icon-hp = MIN(48, 1.55 * SESSION:PIXELS-PER-ROW)
         icon-wp = MIN(40, 7 * SESSION:PIXELS-PER-COLUMN).
&ENDIF

ASSIGN b_lbl-clr:HEIGHT-P     = icon-hp
       b_lbl-clr:WIDTH-P      = icon-wp
       b_lbl-fnt:HEIGHT-P     = icon-hp
       b_lbl-fnt:WIDTH-P      = icon-wp
       b_clr:HEIGHT-P         = icon-hp
       b_clr:WIDTH-P          = icon-wp
       b_fnt:HEIGHT-P         = icon-hp
       b_fnt:WIDTH-P          = icon-wp
       b_attr:HEIGHT-P        = icon-hp
       b_attr:WIDTH-P         = icon-wp
       b_view-as:HEIGHT-P     = icon-hp
       b_view-as:WIDTH-P      = icon-wp
       enable-rect:HEIGHT-P   = 2.
       
  IF SESSION:PIXELS-PER-COLUMN = 5 AND SESSION:PIXELS-PER-ROW = 21 THEN
    ASSIGN b_clr:X         = b_clr:X - 1
           b_fnt:X         = b_fnt:X - 4
           b_attr:X        = b_attr:X - 4
           b_view-as:X     = b_view-as:X - 4
           b_lbl-clr:X     = b_clr:X
           b_lbl-fnt:X     = b_fnt:X.
       
/* Are we dealing with db.table.field format or a SmartData's case */
IF srcSmartData THEN
   ASSIGN 
     lDbAware = {fn getDBAware p_hSmartData}
     imode    = IF lDbAware THEN "1" ELSE "2".
ELSE DO:
  /* Determine if it is necessary to specify the DB and (or) the Table
     name in the list of fields to select from.  The Rules are:
       1) If all tables in the input list are from the same DB, then the
          DB name is remembered in cur-db-name, but not shown.
       2) If all tables in the input list are the same then the table is 
          remembered in cur-tbl-name, but not shown.  (Note: tables with
          the same name but from different DB's are NOT the same.)      */
  IF NUM-ENTRIES(ENTRY(1,Tbl-List),".":U) > 1 THEN   /* Not buffer */
    ASSIGN cur-db-name  = ENTRY(1,ENTRY(1,Tbl-List),".":U)
           cur-tbl-name = ENTRY(2,ENTRY(1,Tbl-List),".":U).
  ELSE  /* If it is a buffer there is only one entry for the table name */ 
    ASSIGN cur-db-name = ""
           cur-tbl-name = ENTRY(1,Tbl-List).
    
  TABLE-SCAN-LOOP:         
  DO i = 1 TO NUM-ENTRIES(Tbl-List):
    IF NUM-ENTRIES(ENTRY(i,Tbl-List),".":U) > 1 THEN DO:  /* Not buffer */     
      IF cur-tbl-name <> ENTRY(2,ENTRY(i,Tbl-List),".":U) THEN 
        ASSIGN cur-tbl-name = "". 
      IF cur-db-name <> ENTRY(1,ENTRY(i,Tbl-List),".":U) THEN DO:
        ASSIGN cur-tbl-name = ""
               cur-db-name  = "".
        LEAVE TABLE-SCAN-LOOP.
      END.  /* If any DB name is different */
    END.  /* IF NUM-ENTRIES ... not buffer */
    ELSE DO:  /* Buffer */
      IF cur-tbl-name <> ENTRY(i,Tbl-List) THEN
        ASSIGN cur-tbl-name = "".
      IF cur-db-name <> "" THEN
        ASSIGN cur-tbl-name = ""
               cur-db-name = "".
        LEAVE TABLE-SCAN-LOOP.
    END.  /* else do */
  END.  /* TABLE-SCAN-LOOP */

  ASSIGN imode   = IF cur-tbl-name EQ "" AND cur-db-name EQ "" THEN "3" 
                                                        /* Fully qualify */
                   ELSE IF cur-tbl-name EQ "" THEN "2"
                                              /* Qualify with table only */
                   ELSE "1".                            /* Don't qualify */
END. /* For Column Editor dealing db as source */

/* It is possible that tables have been removed from the browse since last
   time we added fields.  Delete all fields whose tables have been removed */
FOR EACH _BC WHERE _BC._x-recid = _query-u-rec:
  IF NOT CAN-DO("_<CALC>,_<SDO>",_BC._DBNAME) AND NOT CAN-DO(Tbl-List,
          _BC._DBNAME + "." + _BC._TABLE) THEN DO:
    FOR EACH _TRG WHERE _TRG._wRECID = RECID(_BC):
      DELETE _TRG.
    END.
    DELETE _BC.
  END.  /* IF Table has been removed */
END.

/* Set first-rec and last-rec */
FIND FIRST _BC WHERE _BC._x-recid = _query-u-rec NO-ERROR.
IF AVAILABLE _BC THEN first-rec = RECID(_BC).
ELSE ASSIGN empty-flg = TRUE.            

FIND LAST _BC WHERE _BC._x-recid = _query-u-rec NO-ERROR.
IF AVAILABLE _BC THEN last-rec = RECID(_BC).
             
/* RESET _BC._NAME according to imode - ONLY IF BROWSE!*/
IF NOT isQuery THEN DO:
  FIND FIRST _BC WHERE _BC._x-recid = _query-u-rec AND
                       _BC._DBNAME NE "_<CALC>" NO-ERROR.
  IF AVAILABLE _BC THEN DO:
    IF NUM-ENTRIES(_BC._DISP-NAME,".") NE INTEGER(imode) THEN DO:
      FOR EACH _BC WHERE _BC._x-recid = _query-u-rec AND
                         _BC._DBNAME NE "_<CALC>":
        _BC._DISP-NAME = (IF imode = "3"  THEN 
                             /* If this is a buffer then we don't want to display "Temp-Tables", we only
                                want to display the buffer name and field name */
                            (IF _BC._DBNAME = "Temp-Tables":U AND      
                              CAN-FIND(_tt WHERE _tt._name = _BC._TABLE AND _tt._table-type = "B":U) THEN ""
                             ELSE _BC._DBNAME + ".") 
                          ELSE "") +
                         (IF imode <> "1" THEN _BC._TABLE + "." ELSE "") +
                         _BC._NAME.
      END. /* For each _BC */
    END.  /* If qualification is wrong */
  END.  /* If we have at least one _BC record */
END.  /* If we are working on a Browse */

IF NOT empty-flg THEN FIND FIRST _BC WHERE _BC._x-recid = _query-u-rec.

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(CURRENT-WINDOW) AND FRAME bc-editor:PARENT eq ?
THEN FRAME bc-editor:PARENT = CURRENT-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME bc-editor APPLY "END-ERROR":U TO SELF.

ON END-ERROR OF FRAME bc-editor OR
   ENDKEY    OF FRAME bc-editor
DO:
    IF VALID-HANDLE(p_hSmartData) THEN
        shutdown-sdo(THIS-PROCEDURE).
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Note that the _U can be the BROWSER or the SmartData */
  FIND _U WHERE RECID(_U) = _query-u-rec.
  FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.

  IF _U._TYPE = "BROWSE" THEN DO:
    /* Make sure that column editor knows the current widths of the columns */
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U) AND _BC._WIDTH = 0:
      IF VALID-HANDLE(_BC._COL-HANDLE) THEN _BC._WIDTH = _BC._COL-HANDLE:WIDTH.
    END.  /* For each column */
  END.  /* If a browser */

  /* This is used for CALC fields to make sure @ is included */
  this-is-a-SB = (NOT isQuery) AND
                 (NOT isReport) AND
                 (NOT isSmartData) AND
                 srcSmartData.
  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)) THEN DO:
    FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
      tt-info = tt-info + ",":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                "|":U + (IF _TT._NAME = ? THEN "?":U ELSE _TT._NAME) + "|":U + _TT._TABLE-TYPE.  
    END.
    tt-info = LEFT-TRIM(tt-info,",":U).
  END.  /* IF CAN-FIND _TT */
  ELSE tt-info = ?.

  ASSIGN curObjName = IF NOT srcSmartData AND NOT isSmartData THEN "Browse"
                      ELSE IF _P._TYPE = "SmartViewer" THEN "Viewer"
                      ELSE _P._TYPE
         hasObjInName = IF SUBSTRING(curObjName,
                                  LENGTH(curObjName) - LENGTH("Object":U) + 1)
                        = "Object":U 
                     THEN YES
                     ELSE NO.

  /* Move toggle down to accommodate Instance radio-set */
  IF isQuery AND isDynSDO THEN
    tog_enabled:ROW = tog_enabled:ROW + 1.

  RUN enable_UI.

  IF empty-flg THEN DO:

     &IF "{&WINDOW-SYSTEM}" NE "OSF/MOTIF" &THEN
     ASSIGN empty-msg = CHR(10) +
                        "  There are currently"   + CHR(10) +
                        "  no fields defined"  + CHR(10).
     IF LENGTH("  for this " + curObjName) > 
       (empty-msg:WIDTH-CHAR IN FRAME bc-editor - 2) THEN
     DO:
        empty-msg = empty-msg + "  for this " + CHR(10).
        IF hasObjInName THEN
           ASSIGN empty-msg = empty-msg + "  " + curObjName + ".".
        ELSE
        DO:
           IF LENGTH("  " + curObjName + " object.") 
              > (empty-msg:WIDTH-CHAR IN FRAME bc-editor - 2) THEN
              empty-msg = empty-msg + "  " + curObjName + CHR(10) + "  object.".
           ELSE
              empty-msg = empty-msg + "  " + curObjName + " object.".
        END.
     END.
     ELSE IF hasObjInName 
          AND LENGTH("  for this " + curObjName + ".") 
              > (empty-msg:WIDTH-CHAR IN FRAME bc-editor - 2) THEN
           empty-msg = empty-msg + "  for this " + CHR(10) + curObjName + ".".
     ELSE IF hasObjInName THEN
           empty-msg = empty-msg + "  for this " + curObjName + ".".
     ELSE IF LENGTH("  for this " + curObjName + " object.") 
          > (empty-msg:WIDTH-CHAR IN FRAME bc-editor - 2) THEN
           empty-msg = empty-msg + "  for this " + curObjName + CHR(10) 
                       + "  object.".
     ELSE
           empty-msg = empty-msg + "  for this " + curObjName + " object.".

     ASSIGN empty-msg = empty-msg + CHR(10) + 
                        "  Press the Add button"    + CHR(10) +
                        "  or the Calculated"         + CHR(10) +
                        "  Field button to create"   + CHR(10) +
                        "  field definitions." + CHR(10).
    &ELSE
     ASSIGN empty-msg = CHR(10) +
                        "  There are currently"   + CHR(10) +
                        "  no fields defined"     + CHR(10) +
                        "  for this".
     ASSIGN empty-msg = empty-msg + curObjName + 
                        IF hasObjInName THEN "." ELSE "  object." 
                        + CHR(10) +
                        "  Press the Add button or"     + CHR(10) +
                        "  the Calculated Field"      + CHR(10) +
                        "  button to create"      + CHR(10) +
                        "  field definitions."    + CHR(10).
    
    &ENDIF

     
    DISPLAY empty-msg  WITH FRAME bc-editor.
    ASSIGN empty-msg:READ-ONLY = TRUE
           empty-msg:SENSITIVE = TRUE
           dummy = empty-msg:MOVE-TO-TOP() IN FRAME bc-editor.
  END.
  ELSE ASSIGN empty-msg:VISIBLE   = FALSE
              empty-msg:SENSITIVE = FALSE.
  
  WAIT-FOR GO OF FRAME bc-editor.
  
  IF AVAILABLE _BC THEN /* All _BC records may have been deleted */
  DO:
    ASSIGN _BC._LABEL _BC._HELP _BC._WIDTH _BC._DISP-NAME.
    IF NOT srcSmartData THEN APPLY "LEAVE" TO bcformat IN FRAME bc-editor.
  END.
  
  /* Check for CLOB and BLOB fields in a static SDO, if any exist, 
     set RowObject-NO-UNDO option for the SDO */
  IF isSmartData AND NOT isDynSDO THEN
  DO:
    CheckForLOB: 
    FOR EACH _BC WHERE _BC._x-recid = _query-u-rec :
      IF LOOKUP(_BC._DATA-TYPE, "CLOB,BLOB":U) > 0 THEN
      DO:
        FIND x_U WHERE RECID(x_U) = _U._PARENT-RECID NO-ERROR.  
        IF AVAILABLE x_U THEN 
        DO: 
          FIND x_C WHERE RECID(x_C) = x_U._x-recid NO-ERROR.
          IF AVAILABLE x_C THEN
            ASSIGN x_C._RowObject-NO-UNDO = TRUE.
        END.  /* if available xx_U */
        LEAVE CheckForLOB.
      END.  /* if includes BLOB or CLOB */    
    END.  /* each _BC */
  END.  /* if static SDO */                  


 /* If this is a DataView based browser, the table list and query should only
    include tables for fields that were selected.  */
  IF srcSmartData AND NOT lDbAware THEN
  DO:
    IF AVAILABLE _Q THEN
    DO:
      ASSIGN
        _Q._TblList    = '':U
        _Q._4GLQury    = '':U
        _Q._OptionList = '':U.
      FOR EACH _BC WHERE _BC._x-recid = _query-u-rec:
        IF LOOKUP(_BC._TABLE, _Q._tblList) = 0 THEN
          _Q._tblList = _Q._tblList + (IF NUM-ENTRIES(_Q._tblList) > 0 THEN ',':U ELSE '':U) +
                        _BC._TABLE.
      END.  /* for each _BC */

      DO iTable = 1 TO NUM-ENTRIES(_Q._tblList):
        _Q._4GLQury  = _Q._4GLQury
                     + (IF iTable = 1 THEN "EACH " ELSE ",EACH ")
                     + ENTRY(iTable,_Q._tblList).
      END.

      ASSIGN _Q._OptionList = RIGHT-TRIM(REPLACE(_Q._OptionList, "KEY-PHRASE", ""))
             _Q._OptionList = RIGHT-TRIM(REPLACE(_Q._OptionList, "SORTBY-PHRASE", "")).
             /* KeyPhrase and SortBy options are not needed for SDB's defined
                w/ SDO */ 
    END.  /* if avail _Q */
  END.  /* if SDB based on DataView */

  IF AVAILABLE _P THEN
    ret-msg = shutdown-sdo(THIS-PROCEDURE).
END. /* Main-BLOCK */
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI bc-editor _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME bc-editor.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI bc-editor _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DEFINE VARIABLE fldXLoc AS INTEGER NO-UNDO.

  IF first-rec NE ? AND NOT AVAILABLE _BC THEN DO:
    {&OPEN-QUERY-brw-flds}                       
  END.

  ASSIGN Flds-in-brws-lbl = "Fields in " + curObjName + ":".
         Flds-in-brws-lbl:WIDTH IN FRAME bc-editor = FONT-TABLE:GET-TEXT-WIDTH-CHARS(Flds-in-brws-lbl + " ").
  
  /* Set up depending on Object Type */
  IF isQuery THEN DO:
    ASSIGN col-attrs-lbl = " Field Attributes "
           col-attrs-lbl:WIDTH IN FRAME bc-editor =
                           FONT-TABLE:GET-TEXT-WIDTH-CHARS(col-attrs-lbl)
           tog_enabled:LABEL = "Updateable" 
           b_enable:LABEL = "All U&pdateable" 
           b_disable:LABEL = "&None Updateable" 
           _BC._DISP-NAME:COLUMN  IN FRAME bc-editor = 79.5
           _BC._DISP-NAME:WIDTH   IN FRAME bc-editor = 35.5
           _BC._DISP-NAME:ROW     IN FRAME bc-editor = 11 - (12.13 - 11)
           _BC._LABEL:COLUMN  IN FRAME bc-editor = 79.5
           _BC._LABEL:WIDTH   IN FRAME bc-editor = 35.5
           _BC._LABEL:ROW     IN FRAME bc-editor = 11
           _BC._COL-LABEL:COLUMN IN FRAME bc-editor = 79.5
           _BC._COL-LABEL:WIDTH  IN FRAME bc-editor = 35.5
           _BC._COL-LABEL:ROW    IN FRAME bc-editor = 12.13
           bcformat:COLUMN IN FRAME bc-editor = 79.5
           bcformat:ROW    IN FRAME bc-editor = IF IsReport THEN 12.13 ELSE 13.26
           bcformat:WIDTH  IN FRAME bc-editor = 35.5
           _BC._WIDTH:COLUMN  IN FRAME bc-editor = 79.5
           _BC._WIDTH:ROW     IN FRAME bc-editor = IF IsReport THEN 13.26 ELSE 14.39
           _BC._WIDTH:WIDTH   IN FRAME bc-editor = 35.5.
     ASSIGN
          /* Don't show enable widgets for reports */
           b_enable:HIDDEN             IN FRAME bc-editor = IsReport 
           b_disable:HIDDEN            IN FRAME bc-editor = IsReport 
           tog_enabled:HIDDEN          IN FRAME bc-editor = IsReport
           tog_visible:HIDDEN          IN FRAME bc-editor = TRUE
           tog_auto_resize:HIDDEN      IN FRAME bc-editor = TRUE
           enable-rect:HIDDEN          IN FRAME bc-editor = IsReport            
           tog_disable_auto_zap:HIDDEN IN FRAME bc-editor = TRUE  
           tog_column_read_only:HIDDEN IN FRAME bc-editor = TRUE           
           tog_auto_return:HIDDEN      IN FRAME bc-editor = TRUE
           dfMasterLbl:HIDDEN          IN FRAME bc-editor = IsReport OR NOT _DynamicsIsRunning
           _BC._COL-LABEL:HIDDEN       IN FRAME bc-editor = IsReport
            
           b_clr:HIDDEN       IN FRAME bc-editor = TRUE
           b_fnt:HIDDEN       IN FRAME bc-editor = TRUE
           b_attr:HIDDEN      IN FRAME bc-editor = TRUE
           b_view-as:HIDDEN   IN FRAME bc-editor = TRUE
           b_lbl-clr:HIDDEN   IN FRAME bc-editor = TRUE
           b_lbl-fnt:HIDDEN   IN FRAME bc-editor = TRUE
           b_frm-hlp:HIDDEN   IN FRAME bc-editor = TRUE
           format-lbl:HIDDEN  IN FRAME bc-editor = TRUE
           width-lbl:HIDDEN   IN FRAME bc-editor = TRUE
           help-lbl:HIDDEN    IN FRAME bc-editor = TRUE
           column-rect:HIDDEN IN FRAME bc-editor = TRUE
           format-rect:HIDDEN IN FRAME bc-editor = TRUE
           width-rect:HIDDEN  IN FRAME bc-editor = TRUE
           help-rect:HIDDEN   IN FRAME bc-editor = TRUE
           _BC._HELP:HIDDEN   IN FRAME bc-editor = TRUE.
           
           
      ASSIGN
           fldBCDBNameLbl:HIDDEN       IN FRAME bc-editor = FALSE
           _BC._DBNAME:HIDDEN          IN FRAME bc-editor = FALSE
           fldBCTableLbl:HIDDEN        IN FRAME bc-editor = FALSE
           _BC._TABLE:HIDDEN           IN FRAME bc-editor = FALSE
           fldBCNameLbl:HIDDEN         IN FRAME bc-editor = FALSE
           _BC._NAME:HIDDEN            IN FRAME bc-editor = FALSE
           fldBCDataTypeLbl:HIDDEN     IN FRAME bc-editor = FALSE
           
           /* dma 
           _BC._DATA-TYPE:HIDDEN       IN FRAME bc-editor = FALSE 
           */
           isCalcFld = (_BC._DBNAME:SCREEN-VALUE IN FRAME bc-editor = "_<CALC>") 
           _BC._DATA-TYPE:HIDDEN       IN FRAME bc-editor = isCalcFld
           data_type:HIDDEN            IN FRAME bc-editor = NOT isCalcFld OR isDynSDO
           fldBCFormatLbl:WIDTH        IN FRAME bc-editor = 
                          FONT-TABLE:GET-TEXT-WIDTH-CHARS(fldBCFormatLbl)
           fldBCFormatLbl:HIDDEN       IN FRAME bc-editor = FALSE
           bcformat:HIDDEN          IN FRAME bc-editor = FALSE
           fldBCWidthLbl:WIDTH         IN FRAME bc-editor = 
                          FONT-TABLE:GET-TEXT-WIDTH-CHARS(fldBCWidthLbl)
           fldBCWidthLbl:HIDDEN        IN FRAME bc-editor = FALSE
           _BC._WIDTH:HIDDEN           IN FRAME bc-editor = FALSE
           fldBCDescriptionLbl:HIDDEN  IN FRAME bc-editor = FALSE 
           _BC._DEF-DESC:HIDDEN        IN FRAME bc-editor = FALSE 
           _BC._DISP-NAME:HIDDEN       IN FRAME bc-editor = FALSE
           _BC._DISP-NAME:SENSITIVE    IN FRAME bc-editor = TRUE
           fldBCFieldNameLbl:WIDTH         IN FRAME bc-editor =
                          FONT-TABLE:GET-TEXT-WIDTH-CHARS(fldBCFieldNameLbl)
           fldBCFieldNameLbl:HIDDEN        IN FRAME bc-editor = FALSE
           fldBCLABELLbl:WIDTH         IN FRAME bc-editor =
                          FONT-TABLE:GET-TEXT-WIDTH-CHARS(fldBCLABELLbl)
           fldBCLABELLbl:HIDDEN        IN FRAME bc-editor = FALSE
           _BC._LABEL:HIDDEN           IN FRAME bc-editor = FALSE
           b_advanced:HIDDEN           IN FRAME bc-editor = FALSE
           rdonly-rect:HIDDEN          IN FRAME bc-editor = FALSE
           advanced-rect:HIDDEN        IN FRAME bc-editor = FALSE
           enable-rect:WIDTH           IN FRAME bc-editor = 15.5
           col-attrs-rect:COLUMN       IN FRAME bc-editor = 64
           col-attrs-rect:WIDTH        IN FRAME bc-editor = 53.33
           col-attrs-rect:HEIGHT       IN FRAME bc-editor = 15.8.
    
    /* Make adjustments for web objects that do not include column label */
    IF isReport THEN
      ASSIGN
        fldBCFormatLbl:ROW    = 12.13
        fldBCWidthLbl:ROW     = 13.26
        b_advanced:ROW        = 14.5
        advanced-rect:HEIGHT  = 6.7
        col-attrs-rect:HEIGHT = 14.8.

    DISPLAY Flds-in-brws-lbl fldBCDescriptionLbl fldBCDBNameLbl fldBCTableLbl 
            fldBCNameLbl fldBCDataTypeLbl fldBCFormatLbl fldBCWidthLbl fldBCLABELLbl 
            fldBCFieldNameLbl fldBCColLabelLbl WHEN NOT isReport
        WITH FRAME bc-editor.
  END.  /* If isQuery */
  ELSE DO: /* A browse of some kind - either regular or SmartBrowse */
    ASSIGN col-attrs-lbl = " Column Attributes "
           col-attrs-lbl:WIDTH IN FRAME bc-editor =
                           FONT-TABLE:GET-TEXT-WIDTH-CHARS(col-attrs-lbl)
           tog_enabled:LABEL = "Enable" 
           b_enable:LABEL = "&Enable All"
           b_disable:LABEL = "Di&sable All"
           _BC._DBNAME:HIDDEN         IN FRAME bc-editor = TRUE
           _BC._TABLE:HIDDEN          IN FRAME bc-editor = TRUE
           _BC._NAME:HIDDEN           IN FRAME bc-editor = TRUE
           _BC._DATA-TYPE:HIDDEN      IN FRAME bc-editor = TRUE
           data_type:HIDDEN           IN FRAME bc-editor = TRUE
           fldBCDBNameLbl:HIDDEN      IN FRAME bc-editor = TRUE
           fldBCTableLbl:HIDDEN       IN FRAME bc-editor = TRUE
           fldBCNameLbl:HIDDEN        IN FRAME bc-editor = TRUE
           fldBCDataTypeLbl:HIDDEN    IN FRAME bc-editor = TRUE
           fldBCFormatLbl:HIDDEN      IN FRAME bc-editor = TRUE
           fldBCWidthLbl:HIDDEN       IN FRAME bc-editor = TRUE
           fldBCDescriptionLbl:HIDDEN IN FRAME bc-editor = TRUE
           _BC._DEF-DESC:HIDDEN       IN FRAME bc-editor = TRUE
           fldBCLABELLbl:HIDDEN       IN FRAME bc-editor = TRUE
           _BC._LABEL:HIDDEN          IN FRAME bc-editor = TRUE
           fldBCColLabelLbl:HIDDEN    IN FRAME bc-editor = TRUE
           _BC._COL-LABEL:HIDDEN      IN FRAME bc-editor = TRUE
           b_advanced:HIDDEN          IN FRAME bc-editor = TRUE
           rdonly-rect:HIDDEN         IN FRAME bc-editor = TRUE
           advanced-rect:HIDDEN       IN FRAME bc-editor = TRUE
           b_clr:HIDDEN               IN FRAME bc-editor = FALSE
           b_fnt:HIDDEN               IN FRAME bc-editor = FALSE
           b_attr:HIDDEN              IN FRAME bc-editor = FALSE
           b_view-as:HIDDEN           IN FRAME bc-editor = FALSE
           b_lbl-clr:HIDDEN           IN FRAME bc-editor = FALSE
           b_lbl-fnt:HIDDEN           IN FRAME bc-editor = FALSE
           b_frm-hlp:HIDDEN           IN FRAME bc-editor = FALSE
           help-lbl:HIDDEN            IN FRAME bc-editor = FALSE
           bcformat:HIDDEN            IN FRAME bc-editor = FALSE
           format-lbl:HIDDEN          IN FRAME bc-editor = FALSE
           _BC._WIDTH:HIDDEN          IN FRAME bc-editor = FALSE
           width-lbl:HIDDEN           IN FRAME bc-editor = FALSE
           column-rect:HIDDEN         IN FRAME bc-editor = FALSE
           format-rect:HIDDEN         IN FRAME bc-editor = FALSE
           help-rect:HIDDEN           IN FRAME bc-editor = FALSE
           _BC._HELP:HIDDEN           IN FRAME bc-editor = FALSE
           fldBCFieldNameLbl:HIDDEN   IN FRAME bc-editor = TRUE
           _BC._DISP-NAME:HIDDEN      IN FRAME bc-editor = TRUE
           dfMasterLbl:HIDDEN         IN FRAME bc-editor = TRUE.
  END.  /* Laying out for a browse */

  IF AVAILABLE _BC THEN DO:  /* We have a _BC record */
    IF nonAmerican THEN
      RUN adecomm/_convert.p (INPUT "A-TO-N",
                              INPUT _BC._FORMAT,
                              INPUT _numeric_separator,
                              INPUT _numeric_decimal,
                              OUTPUT bcformat).
    ELSE bcformat = _BC._FORMAT.
         
    IF isQuery THEN DO:
      DISPLAY UNLESS-HIDDEN 
               Flds-in-brws-lbl 
               col-attrs-lbl
               tog_enabled
              _BC._DBNAME 
              _BC._TABLE 
              _BC._NAME 
              _BC._DATA-TYPE
              data_type 
              bcformat 
              _BC._DISP-NAME 
              _BC._LABEL 
              dfMasterLbl WHEN isSmartData AND _DynamicsIsRunning
            WITH FRAME bc-editor.
      ASSIGN 
          b_edit:SENSITIVE      = (_BC._DBNAME eq "_<CALC>" AND NOT isDynSDO)
          _BC._DEF-DESC:READ-ONLY = TRUE.
          
      FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                           _TT._NAME = _BC._TABLE NO-ERROR.
      IF AVAIL _TT AND _TT._TABLE-TYPE = "B":U THEN lBufferType = TRUE.
      ELSE lBufferType = FALSE.

      /* If this is a SmartDataObject and Dynamics is running, label and format should 
         be enabled for calculated fields and temp-table fields, they should be disabled
         for datafields and buffer fields.  */ 
      lEnableDFInfo = NOT (isSmartData AND
                           _DynamicsIsRunning AND
                           ((_BC._DBNAME <> "_<CALC>":U) OR
                            (_BC._DBNAME = "_<CALC>":U AND isDynSDO)) AND
                           (_BC._DBNAME <> "Temp-Tables":U OR 
                             (_BC._DBNAME = "Temp-Tables":U AND lBufferType))).
      ENABLE Flds-in-brws-lbl 
             brw-flds 
             b_mv-up 
             _BC._LABEL WHEN NOT lEnableDFInfo
             bcformat WHEN NOT lEnableDFINfo
             _BC._DEF-DESC 
             b_mv-dn 
             tog_enabled WHEN NOT isReport
             b_remove
             b_add       
             b_enable   WHEN NOT isReport 
             b_disable  WHEN NOT isReport 
             _BC._DISP-NAME
             b_calc-fld WHEN NOT isReport AND first-rec NE ?
             btn_ok 
             btn_cancel 
             btn_help
            WITH FRAME bc-editor.
    END. /* If isQuery */
    ELSE DO: /* Working on a browse column */
      DISPLAY Flds-in-brws-lbl col-attrs-lbl label-lbl help-lbl 
              tog_disable_auto_zap tog_column_read_only tog_auto_return 
              tog_enabled tog_visible WHEN _P.static_object tog_auto_resize
              _BC._HELP _BC._LABEL format-lbl bcformat width-lbl _BC._WIDTH
            WITH FRAME bc-editor.
      ENABLE Flds-in-brws-lbl brw-flds b_mv-up _BC._LABEL b_mv-dn tog_enabled 
             b_remove b_lbl-clr b_lbl-fnt b_add b_enable b_disable b_clr b_fnt 
             b_attr b_view-as b_calc-fld WHEN first-rec NE ? _BC._WIDTH _BC._HELP 
             btn_ok btn_cancel btn_help
           WITH FRAME bc-editor.
      IF NOT srcSmartData THEN
        ENABLE b_frm-hlp bcformat WITH FRAME bc-editor.
      IF srcSmartData AND _P.static_object = NO THEN
        ASSIGN b_calc-fld:HIDDEN = YES
               b_edit:HIDDEN     = YES
               tog_visible:HIDDEN = YES.

      ASSIGN b_edit:SENSITIVE               = _BC._DBNAME = "_<CALC>":U AND NOT isDynSDO AND b_edit:HIDDEN = NO
             tog_enabled:SENSITIVE          = _BC._DBNAME <> "_<CALC>":U OR isSmartData
             tog_visible:SENSITIVE          = (_BC._DBNAME <> "_<CALC>":U OR (LOOKUP("@":U, _BC._DISP-NAME," ":U) > 0))
                                              AND _P.static_object
             tog_auto_resize:SENSITIVE      = _BC._DBNAME <> "_<CALC>":U
             tog_disable_auto_zap:SENSITIVE = tog_enabled:CHECKED
             tog_column_read_only:SENSITIVE = _BC._DBNAME <> "_<CALC>":U
             tog_auto_return:SENSITIVE      = tog_enabled:CHECKED
             b_frm-hlp:SENSITIVE            = (NOT srcSmartData).
    END. /*  Working on a Browser */

    dummy = brw-flds:SELECT-FOCUSED-ROW() NO-ERROR.
    IF NOT DUMMY THEN DO:
      {&OPEN-QUERY-brw-flds}                       
      dummy = brw-flds:SELECT-FOCUSED-ROW() NO-ERROR.   
    END.
    ASSIGN cur-record = RECID(_BC).
    RUN display_bc.ip.
  END.  /* IF we have a _BC Record */

  ELSE DO: /* We opened the query and got no-records */
    
    IF isQuery THEN DO:
      DISPLAY UNLESS-HIDDEN
              Flds-in-brws-lbl 
              col-attrs-lbl 
              tog_enabled
              " " @ _BC._LABEL
            WITH FRAME bc-editor.
      DISABLE ALL EXCEPT 
            b_add 
            btn_ok 
            btn_cancel 
            btn_help
            WITH FRAME bc-editor.
     
      ENABLE b_add
             btn_ok 
             btn_cancel 
             btn_help WITH FRAME bc-editor.
    END.
    ELSE DO:  /* Working on a browse of some kind */
      DISPLAY Flds-in-brws-lbl 
              col-attrs-lbl 
              label-lbl 
              help-lbl
              tog_disable_auto_zap
              tog_column_read_only
              tog_auto_return 
              tog_enabled 
              tog_visible WHEN _P.static_object
              tog_auto_resize 
              format-lbl 
              " " @ bcformat 
              width-lbl 
              " " @ _BC._WIDTH
              " " @ _BC._HELP 
              " " @ _BC._LABEL
            WITH FRAME bc-editor.
      DISABLE ALL EXCEPT b_add btn_ok btn_cancel btn_help
            WITH FRAME bc-editor.
            
      ENABLE b_add b_calc-fld WHEN first-rec NE ? btn_ok btn_cancel btn_help 
             WITH FRAME bc-editor.
    END. /* Else working on a browse */
  END. /* We opened a query with no records */
  RUN set-first-last.ip.
END PROCEDURE. /* enable_ui */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE add-fields.ip:
  DEFINE VARIABLE concatName         AS CHAR       NO-UNDO.
  DEFINE VARIABLE extnt              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE fmt-sa             AS CHAR       NO-UNDO.
  DEFINE VARIABLE hlp-sa             AS CHAR       NO-UNDO.
  DEFINE VARIABLE ii                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE intl               AS CHAR       NO-UNDO.
  DEFINE VARIABLE iTerms             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE last-seq           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lbl-sa             AS CHAR       NO-UNDO.
  DEFINE VARIABLE tmp-db             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tmp-name           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tmp-tbl            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE valmsg             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE valmsg-sa          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataFieldColLabel AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataFieldFormat   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataFieldHelp     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataFieldLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFoundColLabel     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFoundLabel        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFoundFormat       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFoundHelp         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDesignManager     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE pcInheritClasses   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSchemaColLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewFieldList      AS CHARACTER  NO-UNDO.

  DEFINE BUFFER x_BC FOR _BC.

 IF empty-flg THEN
   ASSIGN empty-flg                              = FALSE
          empty-msg:VISIBLE   IN FRAME bc-editor = FALSE 
          empty-msg:SENSITIVE IN FRAME bc-editor = FALSE.  

  /* Make Fld-List to pass to field selector */
  Fld-List = "".

  BuildFieldList:
  FOR EACH _BC WHERE _BC._x-recid = _query-u-rec:
    /* If this is a calculated field for a browser */
    IF _BC._DBNAME = "_<CALC>":U THEN DO:
      /* Only handle the case of a calculated field in a browser.  Before this block
         was entered for IZ 7385, the for each ommitted ALL calculated fields
         If this is a browser calculated field, don't let them chhose the place holder 
         field again. */
      IF NUM-ENTRIES(_BC._DISP-NAME,"@":U) = 2 AND _BC._NAME = "":U AND 
        NOT isQuery AND NOT isReport AND NOT isSmartData THEN DO:
        tmp-name = TRIM(ENTRY(2, _BC._DISP-NAME, "@":U)).
        Fld-List = Fld-List + (IF Fld-List NE "" THEN CHR(10) ELSE "") +
                    IF imode = "1" AND NUM-ENTRIES(tmp-name, ".":U) > 1 THEN 
                               ENTRY(2, tmp-name, ".":U) ELSE tmp-name. 
      END.
      ELSE NEXT BuildFieldList.
    END. /* If it is a calculated field */
    ELSE DO:
      Fld-List = Fld-List + (IF Fld-List NE "" THEN CHR(10) ELSE "") +
                     IF isSmartData THEN ( 
                            (IF imode = "3"  THEN _BC._DBNAME + "." ELSE "") +
                            (IF imode <> "1" THEN _BC._TABLE + "." ELSE "") +
                            _BC._NAME )
                     ELSE _BC._DISP-NAME.
    END.
  END.  /* for eac _BC */

  ASSIGN cNewFieldList = "".
  IF srcSmartData THEN 
       RUN adecomm/_mfldsel.p (INPUT ?, INPUT p_hSmartData,
                               INPUT tt-info, INPUT imode,
                               INPUT CHR(10), INPUT Fld-List, INPUT-OUTPUT cNewFieldList).
  ELSE
       RUN adecomm/_mfldsel.p (INPUT Tbl-List, INPUT ?,
                               INPUT tt-info, INPUT imode,
                               INPUT CHR(10), INPUT Fld-List, INPUT-OUTPUT cNewFieldList).

  IF cNewFieldList NE "":U THEN
      ASSIGN cNewFieldList = TRIM(cNewFieldList, CHR(10))
             Fld-List      = TRIM(Fld-List + CHR(10) + cNewFieldList, CHR(10)).

  RUN adecomm/_setcurs.p ("":U).

  /* Make a pass through _BC records to be certain that all still exist in
     updated Fld-List.  Delete the ones that have been deleted         */
  FOR EACH _BC WHERE _BC._x-recid = _query-u-rec AND _BC._DBNAME NE "_<CALC>":U:
    IF isSmartData THEN DO:
      iTerms = INTEGER(imode).
      IF Fld-List NE "" THEN
        iTerms = NUM-ENTRIES(ENTRY(1,Fld-List,CHR(10)),".":U).
      concatName = (IF imode = "3"  THEN _BC._DBNAME + "." ELSE "") +
                   (IF imode <> "1" THEN _BC._TABLE + "." ELSE "") +
                   _BC._NAME.
      IF imode = "2" AND iTerms = 3 THEN 
        concatName = _BC._DBNAME + ".":U + concatName. 
      IF LOOKUP(concatName,Fld-List,CHR(10)) = 0 THEN DELETE _BC.
    END.
    ELSE
      IF LOOKUP(_BC._DISP-NAME,Fld-List,CHR(10)) = 0 THEN DELETE _BC.
  END.

  /* Resequence _BC Records adding new ones as necessary               */
  cur-seq = 0.
  AddFieldLoop:
  DO i = 1 TO NUM-ENTRIES(cNewFieldList,CHR(10)):
    ASSIGN cur-seq  = cur-seq + 1
           tmp-name = ENTRY(i,cNewFieldList,CHR(10)).

    /* Search procedure temp-table info to see if this cNewFieldList entry is a temp-table
       field instead of a real db field. If so, then prefix tmp-name with "Temp-Tables"
       to reflect that it is a temp-table entry.                                         */
    BUFFER-SEARCH-BLOCK:
    REPEAT ii = 1 TO NUM-ENTRIES(tt-info):
      IF NUM-ENTRIES(tmp-name, ".":U) > 1 AND 
         NUM-ENTRIES(ENTRY(ii,tt-info),"|":U) > 1 AND
         ENTRY(1, tmp-name, ".":U) = ENTRY(2, ENTRY(ii,tt-info), "|":U) THEN DO:
           tmp-name = "Temp-Tables.":U + tmp-name.
        LEAVE BUFFER-SEARCH-BLOCK.
      END.  /* Found buffer */
    END. /* BUFFER-SEARCH-BLOCK REPEAT */

    ASSIGN
           tmp-db   = IF srcSmartData THEN "_<SDO>"
                      ELSE IF tmp-name BEGINS "Temp-Tables.":U THEN "Temp-Tables":U
                      ELSE IF imode = "3" THEN ENTRY(1,tmp-name,".")
                      ELSE cur-db-name
           tmp-tbl  = IF srcSmartData  
                      THEN (IF imode = "2" THEN ENTRY(1,tmp-name,".")
                            ELSE "rowObject")
                      ELSE IF tmp-name BEGINS "Temp-Tables.":U THEN ENTRY(2,tmp-name,".")
                      ELSE IF imode = "3" THEN ENTRY(2,tmp-name,".")
                      ELSE IF imode = "2" THEN ENTRY(1,tmp-name,".")
                      ELSE cur-tbl-name
           tmp-name = ENTRY(NUM-ENTRIES(tmp-name,"."),tmp-name,".")
          /* The cColumnName is currently only used for SDO attribute retrieval
             which need to be qualified if the field list is qualified */
           cColumnName = IF iMode = "2":U 
                         THEN tmp-tbl + '.':U + tmp-name 
                         ELSE tmp-name.

    FIND _BC WHERE _BC._x-recid = _query-u-rec AND
                   _BC._DBNAME  = tmp-db AND
                   _BC._TABLE   = tmp-tbl AND
                   _BC._NAME    = tmp-name NO-ERROR.

    IF NOT AVAILABLE _BC AND NOT isQuery AND NOT isReport AND NOT isSmartData THEN
      /* May be a place holder field for a Calculated field */
      FIND _BC WHERE _BC._x-recid = _query-u-rec AND
                     _BC._DBNAME  = "_<CALC>" AND
                     _BC._TABLE   = ? AND
                     _BC._DISP-NAME MATCHES "*@*":U + tmp-name + "*":U NO-ERROR.


    IF NOT AVAILABLE _BC THEN DO:
      IF isSmartData THEN 
      DO:
          /* Did the user return an array element? If so, Parse it for the
            variable (fld_save) and the array index (fld_index). */
          ASSIGN UniqueName = tmp-name.
          IF (UniqueName MATCHES ("*[*]":U))
            THEN ASSIGN UniqueName  = REPLACE(UniqueName,"[":U,"":U)
                        UniqueName  = REPLACE(UniqueName,"]":U,"":U).

          RUN adeshar/_bstfnam.p (
                                INPUT _query-u-rec,
                                INPUT UniqueName,
                                INPUT ?,
                                INPUT ?,
                                OUTPUT UniqueName).
      END. /* SmartData */

      IF tmp-db = "" THEN DO: 
        FIND _tt WHERE _tt._name = tmp-tbl AND _tt._table-type = "B":U NO-ERROR.
        IF AVAILABLE _tt THEN tmp-db = "Temp-Tables".
      END.  /* IF tmp-db = "", may be buffer */

      /* No record available - create a database one */
      IF isSmartData AND _DynamicsIsRunning THEN
      DO:
        IF tmp-db = "Temp-Tables":U THEN
        DO:
          FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                               _TT._NAME = tmp-tbl NO-ERROR.
          IF AVAIL _TT THEN
            IF _TT._TABLE-TYPE = "B":U OR _TT._TABLE-TYPE = "T":U THEN
              cDataFieldName = _TT._LIKE-TABLE + ".":U + tmp-name.
        END.
        ELSE IF tmp-db = "_<CALC>":U THEN cDataFieldName = tmp-name.
        ELSE cDataFieldName = tmp-tbl + ".":U + tmp-name.

        /* Retrieve the DataField master object */
        ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
        RUN retrieveDesignObject IN hDesignManager ( INPUT  cDataFieldName,
                                                     INPUT  "",  /* Get default  result Codes */
                                                     OUTPUT TABLE ttObject,
                                                     OUTPUT TABLE ttPage,
                                                     OUTPUT TABLE ttLink,
                                                     OUTPUT TABLE ttUiEvent,
                                                     OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
        FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = cDataFieldName NO-ERROR.
        IF AVAIL ttObject THEN
        DO:
           FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                          AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                          AND ttObjectAttribute.tAttributeLabel    = "Label":U NO-ERROR.
           IF AVAIL ttObjectAttribute THEN    
              ASSIGN cDataFieldLabel = ttObjectAttribute.tAttributeValue
                     lFoundLabel     = TRUE.
           ELSE
              ASSIGN lFoundLabel = FALSE.

           FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                          AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                          AND ttObjectAttribute.tAttributeLabel    = "ColumnLabel":U NO-ERROR.
           IF AVAIL ttObjectAttribute THEN    
              ASSIGN cDataFieldColLabel = ttObjectAttribute.tAttributeValue
                     lFoundColLabel     = TRUE.
           ELSE
              ASSIGN lFoundColLabel = FALSE.

           FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                          AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                          AND ttObjectAttribute.tAttributeLabel    = "Format":U NO-ERROR.
           IF AVAIL ttObjectAttribute THEN    
              ASSIGN cDataFieldFormat = ttObjectAttribute.tAttributeValue
                     lFoundFormat    = True.
           ELSE
              ASSIGN lFoundFormat  = FALSE.          

           FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                          AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                          AND ttObjectAttribute.tAttributeLabel    = "Help":U NO-ERROR.
           IF AVAIL ttObjectAttribute THEN    
              ASSIGN cDataFieldHelp = ttObjectAttribute.tAttributeValue
                     lFoundHelp     = true. 
           ELSE 
              ASSIGN lFoundHelp  = FALSE.  
        END. /* End if ttObject Avail */
        ELSE 
           ASSIGN lFoundColLabel = FALSE
                  lFoundLabel  = FALSE
                  lFoundFormat = FALSE
                  lFoundHelp   = FALSE.

      END.  /* if SmartData */

      IF srcSmartData THEN
        IF LOOKUP(dynamic-function("columnDataType" IN p_hSmartData,tmp-name),
                  'BLOB,CLOB':U) > 0 THEN
        DO:
          MESSAGE 
             tmp-name + ' is defined as a large object and cannot be added to a SmartDataBrowser.':U
             VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          NEXT AddFieldLoop.
        END.

      CREATE _BC.
      ASSIGN _BC._x-recid   = _query-u-rec
             _BC._DBNAME    = tmp-db
             _BC._TABLE     = tmp-tbl
             _BC._NAME      = tmp-name
             _BC._DISP-NAME = IF isSmartData THEN UniqueName
                                             ELSE (IF imode = "2":U AND tmp-db = "Temp-Tables":U THEN
                                                     tmp-tbl + ".":U + tmp-name  
                                                   /* If this is a buffer then we don't want to display 
                                                      "Temp-Tables, we only want to display the buffer 
                                                      name and field name */
                                                   ELSE IF imode = "3":U AND tmp-db = "Temp-Tables":U AND                   
                                                     CAN-FIND(_tt WHERE _tt._name = tmp-tbl AND _tt._table-type = "B":U) THEN
                                                       tmp-tbl + ".":U + tmp-name
                                                   ELSE ENTRY(i,cNewFieldList,CHR(10)))
             _BC._ENABLED   = IF isSmartData THEN TRUE ELSE FALSE
             _BC._INHERIT-VALIDATION = IF (isSmartData AND
                                           NOT CAN-DO(_AB_Tools,"Enable-ICF") AND
                                           tmp-db NE "Temp-Tables":U)
                                             THEN TRUE
                                             ELSE FALSE
             tmp-name       = ENTRY(1,_BC._NAME,"[":U).

      IF NOT srcSmartData THEN DO:
        RUN setDICTDBalias.ip (INPUT-OUTPUT tmp-db, 
                               INPUT-OUTPUT tmp-tbl, 
                               INPUT-OUTPUT tmp-name).

        /* Get dictionary info */
        RUN adeuib/_fldinfo.p (INPUT tmp-db,
                               INPUT tmp-tbl,
                               INPUT tmp-name,
                               OUTPUT _BC._DEF-LABEL,
                               OUTPUT _BC._DEF-LABEL-ATTR,
                               OUTPUT _BC._DEF-FORMAT,
                               OUTPUT _BC._DEF-FORMAT-ATTR,
                               OUTPUT _BC._DATA-TYPE,
                               OUTPUT _BC._DEF-HELP,
                               OUTPUT _BC._DEF-HELP-ATTR,
                               OUTPUT extnt,
                               OUTPUT intl,
                               OUTPUT _BC._DEF-DESC,
                               OUTPUT _BC._DEF-VALEXP,
                               OUTPUT valmsg,
                               OUTPUT valmsg-sa, 
                               OUTPUT _BC._MANDATORY).
 
        /*If isQuery and isSmartData are TRUE, it is because we are in a
          SDO, so we have to show the BLOB and CLOB fields.*/
        IF NOT isQuery AND NOT isSmartData AND
           CAN-DO("BLOB,CLOB":U, _BC._data-type) THEN 
        DO:
            MESSAGE _BC._NAME + ' is defined as a large object and cannot be added to a SmartDataBrowser.':U
             VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            DELETE _BC.
            NEXT AddFieldLoop.
        END.

        /* _s-schem.p returns the column-label if it exists */
        RUN adecomm/_s-schem.p (tmp-db, tmp-tbl, _BC._NAME, 
                                IF isSmartData THEN "FIELD:COL-LABEL":U
                                ELSE "FIELD:LABEL":U, OUTPUT cSchemaColLabel).
        IF isSmartData THEN
          _BC._DEF-COLLABEL = cSchemaColLabel.
        ELSE _BC._DEF-LABEL = cSchemaColLabel.

        ASSIGN _BC._LABEL  = IF isSmartData AND lFoundLabel THEN cDataFieldLabel ELSE _BC._DEF-LABEL
               _BC._COL-LABEL = IF isSmartData AND lFoundColLabel THEN cDataFieldColLabel ELSE _BC._DEF-COLLABEL
               _BC._FORMAT = IF isSmartData AND lFoundFormat THEN cDataFieldFormat ELSE _BC._DEF-FORMAT
               _BC._HELP   = IF isSmartData AND lFoundHelp THEN cDataFieldHelp ELSE _BC._DEF-HELP
               _BC._HAS-DATAFIELD-MASTER = IF isSmartData AND AVAIL ttObject THEN TRUE ELSE FALSE.
               data_type   = _BC._DATA-TYPE.

        IF nonAmerican THEN 
          RUN adecomm/_convert.p (INPUT "A-TO-N", 
                                  INPUT _BC._FORMAT,
                                  INPUT _numeric_separator,
                                  INPUT _numeric_decimal,
                                  OUTPUT bcformat).
        ELSE bcformat = _BC._FORMAT.

        /* Set up the WIDTH */
        ASSIGN _BC._WIDTH = IF _BC._DATA-TYPE BEGINS "DA" /* Date */
                              THEN FONT-TABLE:GET-TEXT-WIDTH-CHARS(_BC._FORMAT)
                            ELSE IF _BC._DATA-TYPE BEGINS "C" /* Character */
                              THEN LENGTH(STRING("A",_BC._FORMAT), "RAW":U)
                            ELSE IF _BC._DATA-TYPE BEGINS "L" /* Logical */
                              THEN MAXIMUM(FONT-TABLE:GET-TEXT-WIDTH-CHARS(STRING(YES,_BC._FORMAT)),
                                           FONT-TABLE:GET-TEXT-WIDTH-CHARS(STRING(NO, _BC._FORMAT)))
                            ELSE FONT-TABLE:GET-TEXT-WIDTH-CHARS(_BC._FORMAT).
        /* Adjust for the label */
        DO iw = 1 TO NUM-ENTRIES(_BC._LABEL,"!"):
          _BC._WIDTH = MAX(_BC._WIDTH,
                           FONT-TABLE:GET-TEXT-WIDTH-CHARS(ENTRY(iw,_BC._LABEL,"!":U))).
        END.
        /* This is the "new" default width so set it too */
        ASSIGN _BC._DEF-WIDTH = _BC._WIDTH.
      END. /* Not using SmartData or calculated field */
      ELSE DO: /* Building a SmartBrowse from info from SmartData */
        /* Valid data to be retrieved:
                DataType,DBName,Help,Label,
                   Modified,ScreenValue,ReadOnly,PrivateData,Width */
        ASSIGN _BC._DEF-LABEL  = dynamic-function("columnLabel" IN p_hSmartData,cColumnName) 
               _BC._DATA-TYPE  = dynamic-function("columnDataType" IN p_hSmartData,cColumnName) 
               _BC._DEF-FORMAT = dynamic-function("columnFormat" IN p_hSmartData,cColumnName) 
               _BC._DEF-HELP   = dynamic-function("columnHelp" IN p_hSmartData,cColumnName) 
               _BC._DEF-WIDTH  = MAX(dynamic-function("columnWidth" IN p_hSmartData,cColumnName),
                                     FONT-TABLE:GET-TEXT-WIDTH(ENTRY(1,_BC._DEF-LABEL,"!":U)))
               _BC._WIDTH      = _BC._DEF-WIDTH
               _BC._LABEL      = _BC._DEF-LABEL
               _BC._HELP       = _BC._DEF-HELP
               _BC._FORMAT     = _BC._DEF-FORMAT
               data_type       = _BC._DATA-TYPE.

        IF NUM-ENTRIES(_BC._DEF-LABEL,"!":U) > 1 THEN DO:
          DO iw = 2 TO NUM-ENTRIES(_BC._DEF-LABEL,"!":U):
            ASSIGN _BC._DEF-WIDTH = MAX(_BC._DEF-WIDTH, 
                                       FONT-TABLE:GET-TEXT-WIDTH(ENTRY(iw,_BC._DEF-LABEL,"!":U)))
                   _BC._WIDTH     = _BC._WIDTH.
          END.
        END.  /* IF Stacked Columns */
      END.  /* Using Smart Data to populate a browser */
    END.  /* If we don't have the _BC record already */
    ELSE _BC._SEQUENCE = -1.

    FIND LAST x_BC WHERE x_BC._x-recid = _query-u-rec NO-LOCK NO-ERROR.
    IF NOT AVAILABLE(x_BC) THEN
      ASSIGN _BC._SEQUENCE = 1.
    ELSE
      ASSIGN _BC._SEQUENCE = x_BC._SEQUENCE + 1.
    
    ASSIGN cur-record = RECID(_BC).
  END.  /* DO i = 1 to NUM-ENTRIES of cNewFieldList */

  /* Reopen browse */
  {&OPEN-QUERY-brw-flds}
  ASSIGN dummy = brw-flds:SET-REPOSITIONED-ROW(MIN(
                  (IF brw-flds:FOCUSED-ROW IN FRAME bc-editor <> ? THEN
                      brw-flds:FOCUSED-ROW IN FRAME bc-editor ELSE 0) +
                      NUM-ENTRIES(Fld-List,CHR(10)),brw-flds:NUM-ITERATIONS),
                             "CONDITIONAL") IN FRAME bc-editor NO-ERROR.
  IF dummy AND CAN-FIND(FIRST _BC WHERE _BC._x-recid = _query-u-rec) THEN DO:
    REPOSITION brw-flds TO RECID cur-record.
    ASSIGN dummy = brw-flds:SELECT-FOCUSED-ROW() IN FRAME bc-editor.
    RUN display_bc.ip.
  END.
  RUN set-first-last.ip.
END.  /* PROCEDURE add-fields.ip */ 

PROCEDURE advanced.ip.
  DEFINE VARIABLE cTemp       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp-db      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp-tbl     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp-name    AS CHARACTER NO-UNDO.

  /* Procedure to display and enable the Advanced dialog box. */
  DO WITH FRAME sdoadv-dlg:
    ASSIGN tmp-db   = _BC._DBNAME
           tmp-tbl  = _BC._TABLE
           tmp-name = _BC._NAME.

    IF tmp-db NE "_<CALC>" THEN DO:
        RUN setDICTDBalias.ip (INPUT-OUTPUT tmp-db,
                               INPUT-OUTPUT tmp-tbl, 
                               INPUT-OUTPUT tmp-name).

        /* Get dictionary info */

tmp-name = IF INDEX(tmp-name, '[') > 0 
           THEN SUBSTRING(tmp-name, 1, INDEX(tmp-name, '[') - 1)
           ELSE tmp-name.

        RUN adeuib/_fldinfo.p (INPUT tmp-db,
                               INPUT tmp-tbl,
                               INPUT tmp-name,
                               OUTPUT cTemp,             /* _BC._DEF-LABEL  */
                               OUTPUT cTemp,                /* _BC._DEF-LABEL-ATTR */
                               OUTPUT cTemp,                /* _BC._DEF-FORMAT */
                               OUTPUT ctemp,                /* _BC._DEF-FORMAT-ATTR */
                               OUTPUT cTemp,                /* _BC._DATA-TYPE  */
                               OUTPUT cTemp,                /* _BC._DEF-HELP   */
                               OUTPUT cTemp,                /* _BC._DEF-HELP-ATTR */
                               OUTPUT cTemp,                /* extnt           */
                               OUTPUT cTemp,                /* intl            */
                               OUTPUT cTemp,                /* _BC._DEF-DESC   */
                               OUTPUT _BC._DEF-VALEXP,
                               OUTPUT cTemp,                /* valmsg          */
                               OUTPUT cTemp,                /* valmsg-sa       */ 
                               OUTPUT cTemp).               /* _BC._MANDATORY  */
    END.  /* If not working with a calculated field */
    

    FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                         _TT._NAME = _BC._TABLE NO-ERROR.
    IF AVAIL _TT AND _TT._TABLE-TYPE = "B":U THEN lBufferType = TRUE.
    ELSE lBufferType = FALSE.
    /* If this is a SmartDataObject and Dynamics is running, label and format should 
       be enabled for calculated fields and temp-table fields, they should be disabled
       for datafields and buffer fields.  */
    lEnableDFInfo = NOT (isSmartData AND
                         _DynamicsIsRunning AND
                         ((_BC._DBNAME <> "_<CALC>":U) OR
                            (_BC._DBNAME = "_<CALC>":U AND isDynSDO)) AND
                         (_BC._DBNAME <> "Temp-Tables":U OR 
                           (_BC._DBNAME = "Temp-Tables":U AND lBufferType))).
    ASSIGN _BC._DEF-VALEXP:READ-ONLY               = TRUE
           _BC._HELP:SENSITIVE = lEnableDFInfo
           tog_inherit_validation = IF LOOKUP(_BC._DBNAME,"_<CALC>,Temp-Tables":U)
                                           > 0 THEN FALSE
                                    ELSE _BC._INHERIT-VALIDATION
           tog_inherit_validation:CHECKED = tog_inherit_validation
           tog_inherit_validation:SENSITIVE IN FRAME sdoadv-dlg = FALSE.
    DISPLAY fldBCDBNameLbl _BC._DBNAME fldBCTableLbl _BC._TABLE fldBCDataTypeLbl
            _BC._DATA-TYPE fldBCLABELLbl _BC._LABEL _BC._DEF-VALEXP _BC._HELP
         WITH FRAME sdoadv-dlg.
    IF LOOKUP(_BC._DBNAME,"_<CALC>,Temp-Tables":U) = 0 THEN
       ENABLE tog_inherit_validation WITH FRAME sdoadv-dlg.
    ENABLE btn_OK btn_CANCEL btn_HELP WITH FRAME sdoadv-dlg.
    WAIT-FOR GO OF FRAME sdoadv-dlg.
  END. /* DO WITH FRAME sdoadv-dlg */
END. /* Procedure advanced.ip. */


PROCEDURE set-first-last.ip:
  DEFINE BUFFER x_BC FOR _BC.
  
  FIND FIRST x_BC WHERE x_BC._x-recid = _query-u-rec NO-LOCK NO-ERROR.
  IF AVAILABLE x_BC THEN first-rec = RECID(x_BC).
                    ELSE first-rec = ?.
  FIND LAST x_BC WHERE x_BC._x-recid = _query-u-rec NO-LOCK NO-ERROR.
  IF AVAILABLE x_BC THEN last-rec = RECID(x_BC).
                    ELSE last-rec = ?.
  ASSIGN b_mv-dn:SENSITIVE IN FRAME bc-editor = (cur-record NE last-rec)
         b_mv-up:SENSITIVE IN FRAME bc-editor = (cur-record NE first-rec).
END. /* PROCEDURE set-first-last.ip */


PROCEDURE SetToggleState.ip:
  /* These two toggles should only be on when the browse column is made
     to be sensitive                                                    */
  IF _BC._ENABLED THEN
    ASSIGN tog_disable_auto_zap:SENSITIVE IN FRAME bc-editor = TRUE
           tog_column_read_only:SENSITIVE IN FRAME bc-editor = (_BC._DBNAME <> "_<CALC>":U)
           tog_auto_return:SENSITIVE IN FRAME bc-editor      = TRUE.
  ELSE /*  if ENABLE was turned off, return to default values.       */
    ASSIGN _BC._DISABLE-AUTO-ZAP                             = FALSE
           _BC._AUTO-RETURN                                  = FALSE
           _BC._COLUMN-READ-ONLY                             = FALSE
           tog_disable_auto_zap:SENSITIVE IN FRAME bc-editor = FALSE
           tog_disable_auto_zap:CHECKED   IN FRAME bc-editor = _BC._DISABLE-AUTO-ZAP
           tog_column_read_only:SENSITIVE IN FRAME bc-editor = FALSE
           tog_column_read_only:CHECKED   IN FRAME bc-editor = _BC._COLUMN-READ-ONLY
           tog_auto_return:SENSITIVE IN FRAME bc-editor      = FALSE
           tog_auto_return:CHECKED   IN FRAME bc-editor      = _BC._AUTO-RETURN.
END.


PROCEDURE display_bc.ip.
  DO WITH FRAME bc-editor:
    
    IF nonAmerican THEN
      RUN adecomm/_convert.p (INPUT "A-TO-N",
                              INPUT _BC._FORMAT,
                              INPUT _numeric_separator,
                              INPUT _numeric_decimal,
                              OUTPUT bcformat).
    ELSE bcformat = _BC._FORMAT.
    
    FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                         _TT._NAME = _BC._TABLE NO-ERROR.
    IF AVAIL _TT AND _TT._TABLE-TYPE = "B":U THEN lBufferType = TRUE.
    ELSE lBufferType = FALSE.

    /* If this is a SmartDataObject and Dynamics is running, label and format should 
       be enabled for calculated fields and temp-table fields, they should be disabled
       for datafields and buffer fields.  */
    lEnableDFInfo = NOT (isSmartData AND
                         _DynamicsIsRunning AND
                         ((_BC._DBNAME <> "_<CALC>":U) OR
                            (_BC._DBNAME = "_<CALC>":U AND isDynSDO)) AND
                         (_BC._DBNAME <> "Temp-Tables":U OR 
                           (_BC._DBNAME = "Temp-Tables":U AND lBufferType))).
    ASSIGN tog_enabled:CHECKED   = _BC._ENABLED
           tog_enabled:SENSITIVE = (_BC._DBNAME <> "_<CALC>":U OR isSmartData)
           tog_auto_resize:CHECKED   = _BC._AUTO-RESIZE
           tog_auto_resize:SENSITIVE = (_BC._DBNAME <> "_<CALC>":U)
           tog_visible:CHECKED   = _BC._VISIBLE AND _P.static_object
           tog_visible:SENSITIVE = ((_BC._DBNAME <> "_<CALC>":U) OR 
                                   (LOOKUP("@":U, _BC._DISP-NAME," ":U) > 0)) AND
                                   _P.static_object
           _BC._LABEL:SENSITIVE  = lEnableDFInfo
           _BC._COL-LABEL:SENSITIVE = lEnableDFInfo 
           bcformat:SENSITIVE    = NOT srcSmartdata AND lEnableDFInfo
           b_edit:SENSITIVE      = (_BC._DBNAME = "_<CALC>":U AND NOT isDynSDO)
           b_mv-dn:SENSITIVE     = (cur-record NE last-rec)
           b_mv-up:SENSITIVE     = (cur-record NE first-rec)
           data_type:SENSITIVE   = (_BC._DBNAME = "_<CALC>":U).
    
    IF isQuery THEN DO:
      ASSIGN _BC._DEF-DESC:READ-ONLY  = TRUE
             b_advanced:SENSITIVE     = TRUE
             _BC._DISP-NAME:SENSITIVE = isSmartData.
     
      IF _BC._DBNAME = "_<CALC>":U THEN DO:
        DISPLAY "":U @ _BC._DBNAME 
                "":U @ _BC._TABLE.
                /* "":U @ _BC._DBNAME. */

        ASSIGN
          _BC._DATA-TYPE:HIDDEN IN FRAME bc-editor  = IF isDynSDO THEN FALSE ELSE TRUE
          iw = data_type:LOOKUP(_BC._DATA-TYPE)
          data_type:SCREEN-VALUE IN FRAME bc-editor = data_type:ENTRY(iw)
          data_type:HIDDEN      IN FRAME bc-editor  = IF isDynSDO THEN TRUE ELSE FALSE.

        IF isDynSDO THEN
          DISPLAY _BC._DATA-TYPE.
      END.
      ELSE DO:
        ASSIGN
          data_type:HIDDEN      IN FRAME bc-editor = TRUE.
          
        DISPLAY _BC._DBNAME 
                _BC._TABLE 
                _BC._DATA-TYPE. 
      END.
      
      DISPLAY _BC._NAME              
              _BC._DEF-DESC
              _BC._DISP-NAME 
              _BC._LABEL 
              _BC._COL-LABEL
              bcformat 
              _BC._WIDTH.
       
      DISPLAY {&Mandatory} _BC._DISP-NAME WITH BROWSE brw-flds.
         
    END.  /* If isQuery */
    ELSE DO: /* Building a browse of some kind */
      ASSIGN tog_disable_auto_zap:CHECKED  = _BC._DISABLE-AUTO-ZAP
             tog_disable_auto_zap:SENSITIVE = tog_enabled:CHECKED AND
                                              tog_enabled:SENSITIVE
             tog_column_read_only:CHECKED  = _BC._COLUMN-READ-ONLY
             tog_column_read_only:SENSITIVE = tog_enabled:CHECKED AND
                                              tog_enabled:SENSITIVE
             tog_auto_return:CHECKED  = _BC._AUTO-RETURN
             tog_auto_return:SENSITIVE      = tog_enabled:CHECKED AND
                                              tog_enabled:SENSITIVE
             b_frm-hlp:SENSITIVE      = (_BC._DBNAME NE "_<CALC>":U AND
                                          NOT srcSmartData).
      DISPLAY _BC._LABEL
              bcformat 
              _BC._WIDTH 
              _BC._HELP.

      IF CAN-DO("DECIMAL,CHARACTER,INTEGER,INT64,DATE,LOGICAL":U, _BC._DATA-TYPE) THEN
         ASSIGN b_view-as:SENSITIVE = TRUE.
      ELSE  ASSIGN b_view-as:SENSITIVE = FALSE.

    END.  /* If building a browse of some kind */
  END. /* DO WITH FRAME bc-editor */
END.  /* Procedure display_bc.ip. */

PROCEDURE setWidth.ip:
  DEFINE INPUT PARAMETER pScreenValue         AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE scrVal                      AS CHARACTER   NO-UNDO.
  DEFINE BUFFER x_BC FOR _BC.

  DO WITH FRAME bc-editor:
     /* FOR the case where you have not yet checked the value of 
      * _BC._FORMAT:SCREEN-VALUE before assigning to _BC._FORMAT, 
      * you still want to change the _WIDTH as you are changing the 
      * _FORMAT but you do NOT want to assign the _FORMAT until it has passed
      * the format check, hence we use the _BC._FORMAT:SCREEN-VALUE
      */
     FIND x_BC WHERE RECID(x_BC) = cur-record NO-ERROR.
     IF RECID(_BC) = cur-record THEN
        ASSIGN scrVal = IF pScreenValue THEN bcformat:SCREEN-VALUE
                                        ELSE _BC._FORMAT.
     ELSE ASSIGN scrVal = x_BC._FORMAT.

     IF AVAILABLE x_BC AND ((x_BC._WIDTH eq x_BC._DEF-WIDTH) OR isQuery) THEN
     DO:
           ASSIGN x_BC._WIDTH = 
              IF x_BC._DATA-TYPE BEGINS "DA" /* Date */
              THEN FONT-TABLE:GET-TEXT-WIDTH-CHARS(scrVal, x_BC._FONT)
              ELSE IF x_BC._DATA-TYPE BEGINS "C" /* Character */
              THEN LENGTH(STRING("A",scrVal), "RAW":U)
              ELSE IF x_BC._DATA-TYPE BEGINS "L" /* Logical */
              THEN MAXIMUM(FONT-TABLE:GET-TEXT-WIDTH-CHARS(STRING(YES,scrVal)),
              FONT-TABLE:GET-TEXT-WIDTH-CHARS(STRING(NO, scrVal)))
              ELSE FONT-TABLE:GET-TEXT-WIDTH-CHARS(scrVal) NO-ERROR.
    
           /* Adjust for the label */
           DO iw = 1 TO NUM-ENTRIES(x_BC._LABEL,"!"):
              x_BC._WIDTH = MAX(x_BC._WIDTH,
                           FONT-TABLE:GET-TEXT-WIDTH-CHARS
                           (ENTRY(iw,x_BC._LABEL,"!":U))).
           END.
    
           /* This is the "new" default width so set it too */
           ASSIGN x_BC._DEF-WIDTH = x_BC._WIDTH.
 
           /* Only refresh the screen if we are still on the record */
           IF RECID(_BC) = cur-record THEN
           DO:
              ASSIGN _BC._WIDTH:SCREEN-VALUE = STRING(x_BC._WIDTH).
              DISPLAY _BC._WIDTH WITH FRAME bc-editor.
           END.
      END. /* If (width is the default width or isQuery) and available */
   END. /* In frame bc-editor */
END PROCEDURE. /* setWidth.ip */

PROCEDURE setDICTDBalias.ip:
  DEFINE INPUT-OUTPUT PARAMETER tmp-db     AS CHARACTER                             NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER tmp-tbl    AS CHARACTER                             NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER tmp-name   AS CHARACTER                             NO-UNDO.

   /* Working on a SmartData Object or regular browse */
   IF _BC._DBNAME = "Temp-Tables":U THEN DO:
          FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                               _TT._NAME = _BC._TABLE NO-ERROR.
          IF NOT AVAILABLE _TT THEN
            FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                                 _TT._LIKE-TABLE = _BC._TABLE.
          ASSIGN tmp-db  = _TT._LIKE-DB
                 tmp-tbl = _TT._LIKE-TABLE.
   END.  /* If this column is for a Temp-Table field */
   ELSE  /* A regular db field */
          ASSIGN tmp-db  = _BC._DBNAME
                 tmp-tbl = _BC._TABLE.
    
    /* Set the alias correctly, so we can call _fldinfo */
    /* There must be at least one DB connected. */
    if num-dbs ge 1 then
    do:
        if not valid-handle(ghBuffer) then
        do:
            create buffer ghBuffer for table 'DICTDB._Db' no-error.
            ghField = ghBuffer:buffer-field('_Db-name':u).
        end.    /* create buffer object */
        
        /* Refind the _Db record if not available, or if the
           available record isn't the DB we want as DICTDB.
           
           Note that there may be a bug in this code when
           a table name is shared between DBs.           
         */
        if not ghBuffer:available or
           ghField:buffer-value ne (if tmp-db eq ldbname('DICTDB':u) then ? else tmp-db) then
        do:
            /* If the buffer has changed, then create a new
               buffer for the new table. Get rid of the old one.
             */
            if valid-handle(ghBuffer) then
            do:
                /* Clean up old handles */
                delete object ghField no-error.
                ghField = ?.
                delete object ghBuffer no-error.
                ghBuffer = ?.
                
                /* Create new buffer */
                create buffer ghBuffer for table 'DICTDB._Db' no-error.
                ghField = ghBuffer:buffer-field('_Db-name':u).                
            end.
            
            if not valid-handle(ghQuery) then
                create query ghQuery.                            
            else
                ghQuery:query-close().
            
            /* The buffers may have changed. */
            ghQuery:set-buffers(ghBuffer).
            
            /* Note the fields() phrase. This is for performance reasons when running
               connected -N to a DB.
             */
            ghQuery:query-prepare('for each DICTDB._Db fields (_Db-name) where ':u
                                 + ' DICTDB._Db._db-name = ':u
                                 + quoter(if tmp-db eq ldbname('DICTDB':u) then ? else tmp-db) 
                                 + ' no-lock ':u).
            ghQuery:query-open().
            ghQuery:get-first().
        end.    /* set up the query */
        
        if not ghBuffer:available then
        do:
            if not can-find(first s_ttb_db) then
                run adecomm/_getdbs.p.
            
            find first s_ttb_db where s_ttb_db.ldbnm = tmp-db no-error.
            if available s_ttb_db then
                create alias DICTDB for database value(sdbname(s_ttb_db.sdbnm)).                    
        end.    /* record not available */
        else
        if ghField:buffer-value ne ? then
            create alias DICTDB for database value(sdbname(ghField:buffer-value)).
    end.    /* connected to some DB */
END PROCEDURE.    /* setDICTDBalias.ip */


