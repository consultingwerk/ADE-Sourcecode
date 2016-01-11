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
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * analyze.i -  This include file defines preprocessor names for the items in 
 * ANALYZER output.  [For ref: see Interfeaf document language/analyze.doc]
 * Each line of analyzer output is read into _inp_line -- 
 * For each block of analyzer output, we explicitly name the analyzer data
 * contained in this line. 
 *
 * &TYPE can be passed to define the names for different sections
 *       eg. BUTTON, FILL-IN
 *
 * Created:  Wm.T.Wood   February 18, 1994
 * Modified: R Ryan      March 8, 1994
 *           gfs         3/8/96 - new slider attrs.
 *           gfs         11/20/96 - add tooltip
 *           gfs         12/20/96 - add NO-BOX for Editor
 *           gfs         02/11/98 - add new attrs NO-TAB-STOP, DROP-TARGET &
 *                                  DISABLE-AUTO-ZAP
 *           gfs         02/25/98 - added new browse attrs. (Validate,
 *                                  scrollbar-v, expandable & Row-Height)
 *           gfs         07/21/98 - added FLAT-BUTTON
 *           gfs         09/11/98 - added LIST-ITEM-PAIRS to combo & sellist
 *           gfs         10/13/98 - added Tooltip attrs.
 *           tsm         06/03/99 - added Stretch to Fit, Retain Shape, and
 *                                  Transparent image attributes
 *           tsm         06/07/99 - added Context-Help-ID attribute
 *           tsm         06/10/99 - added auto-completion and unique match
 *           tsm         06/16/99 - added no-auto-validate
 *           tsm         06/18/99 - added max-chars
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/* ANALYZER Header (AH) Data -- eg. Lines of form "FI" widget-name file-name */
&Global AH_type          _inp_line[1]
&Global AH_widget        _inp_line[2]

/* Widget-Specific Names -- Generally 1-16 are common data.  The rest is
   very widget dependent.   */

/* ANALYZER Common (AC) Data */
&Global AC_position-unit _inp_line[1]
&Global AC_X             _inp_line[2]
&Global AC_Y             _inp_line[3]

&Global AC_size-unit     _inp_line[4]
&Global AC_width         _inp_line[5]
&Global AC_height        _inp_line[6]

&Global AC_color-mode    _inp_line[7]
&Global AC_FGcolor       _inp_line[8]
&Global AC_BGcolor       _inp_line[9]
&Global AC_font          _inp_line[10]

&Global AC_help          _inp_line[11]
&Global AC_help-sa       _inp_line[12]

&Global AC_ldbname       _inp_line[13]
&Global AC_table         _inp_line[14]
&Global AC_buffer        _inp_line[15]
&Global AC_initial       _inp_line[16]

/* pseudo-common data -- many types use the following */
&Global ApC_label         _inp_line[17]
&Global ApC_label-sa      _inp_line[18]

&IF "{&TYPE}" eq "BROWSE" &THEN

/* ANALYZER Browser ABW data   */
&Global ABW_down           _inp_line[17]
&Global ABW_separators     _inp_line[18]
&Global ABW_multiple       _inp_line[19]
&Global ABW_num-of-cells   _inp_line[20]
&Global ABW_title          _inp_line[21]
&Global ABW_title-sa       _inp_line[22]
&Global ABW_title-colr-md  _inp_line[23]
&Global ABW_title-colr-fg  _inp_line[24]
&Global ABW_title-colr-bg  _inp_line[25]
&Global ABW_title-font     _inp_line[26]
&Global ABW_no-box         _inp_line[27]
&Global ABW_shared         _inp_line[28]
&Global ABW_no-labels      _inp_line[29]
&Global ABW_column-scroll  _inp_line[30]
&Global ABW_no-assign      _inp_line[31]
&Global ABW_no-row-markers _inp_line[32]
&Global ABW_label-font     _inp_line[33]
&Global ABW_label-fgcolor  _inp_line[35]
&Global ABW_label-bgcolor  _inp_line[36]
&Global ABW_tooltip        _inp_line[37]
&Global ABW_tooltip-attr   _inp_line[38]
&Global ABW_no-tab-stop    _inp_line[39]
&Global ABW_drop-target    _inp_line[40]
&Global ABW_validate       _inp_line[41]
&Global ABW_scrollbar-v    _inp_line[42]
&Global ABW_expandable     _inp_line[43]
&Global ABW_RowHeight-type _inp_line[44]
&Global ABW_RowHeight-val  _inp_line[45]
&Global ABW_context-help-id _inp_line[46]
&Global ABW_no-auto-validate _inp_line[47]
&Global ABW_no-empty_space  _inp_line[48]

&ELSEIF "{&TYPE}" eq "BUTTON" &THEN

/* ANALYZER Button(ABU) Data   */
&Global ABU_image-up        _inp_line[22]
&Global ABU_image-down      _inp_line[28]
&Global ABU_image-insent    _inp_line[34]
&Global ABU_auto-go         _inp_line[37]
&Global ABU_auto-end-key    _inp_line[38]
&Global ABU_default         _inp_line[39]
&Global ABU_tooltip         _inp_line[40]
&Global ABU_tooltip-attr    _inp_line[41]
&Global ABU_convert-3d-clr  _inp_line[42]
&Global ABU_focus           _inp_line[43]
&Global ABU_drop-target     _inp_line[44]
&Global ABU_no-tab-stop     _inp_line[45]
&Global ABU_flat            _inp_line[46]
&Global ABU_context-help-id _inp_line[47]


&ELSEIF "{&TYPE}" eq "COMBO-BOX" &THEN

/* ANALYZER Combo-Box Field (ACB) Data   */
&Global ACB_col-label       _inp_line[17]
&Global ACB_col-label-sa    _inp_line[18]
&Global ACB_label           _inp_line[19]
&Global ACB_label-sa        _inp_line[20]
&Global ACB_inner-chars     _inp_line[21]
&Global ACB_inner-lines     _inp_line[22]
&Global ACB_sub-type        _inp_line[23]
&Global ACB_sort            _inp_line[24]
&Global ACB_num-items       _inp_line[25]
&Global ACB_undo            _inp_line[26]
&Global ACB_extent          _inp_line[27]
&Global ACB_format          _inp_line[28]
&Global ACB_format-sa       _inp_line[29]
&Global ACB_data-type       _inp_line[30]
&Global ACB_no-label        _inp_line[31]
&Global ACB_tooltip         _inp_line[32]
&Global ACB_tooltip-attr    _inp_line[33]
&Global ACB_drop-target     _inp_line[34]
&Global ACB_no-tab-stop     _inp_line[35]
&Global ACB_list-item-pairs _inp_line[36]
&Global ACB_context-help-id _inp_line[37]
&Global ACB_auto-completion _inp_line[38]
&Global ACB_unique-match    _inp_line[39]
&Global ACB_max-chars       _inp_line[40]

&ELSEIF "{&TYPE}" eq "EDITOR" &THEN

/* ANALYZER Editor (AED) Data   */
&Global AED_col_label     _inp_line[17]
&Global AED_col-label-sa  _inp_line[18]
&Global AED_label         _inp_line[19]
&Global AED_label-sa      _inp_line[20]
&Global AED_max_chars     _inp_line[21]
&Global AED_h-scroll      _inp_line[22]
&Global AED_scrollbar-h   _inp_line[23]
&Global AED_scrollbar-v   _inp_line[24]
&Global AED_inner-lines   _inp_line[25]
&Global AED_inner-chars   _inp_line[26]
&Global AED_large         _inp_line[27]
&Global AED_undo          _inp_line[28]
&Global AED_extent        _inp_line[29]
&Global AED_no-word-wrap  _inp_line[30] 
&Global AED_tooltip       _inp_line[31]
&Global AED_tooltip-attr  _inp_line[32]
&Global AED_no-box        _inp_line[33]
&Global AED_drop-target   _inp_line[34]
&Global AED_no-tab-stop   _inp_line[35]
&Global AED_context-help-id _inp_line[36]

&ELSEIF "{&TYPE}" eq "FILL-IN" &THEN

/* ANALYZER Fill-in Field (AFF) Data   */
&Global AFF_literal       _inp_line[17]
&Global AFF_literal-sa    _inp_line[18]
&Global AFF_col-label     _inp_line[19]
&Global AFF_col-label-sa  _inp_line[20]
&Global AFF_label         _inp_line[21]
&Global AFF_label-sa      _inp_line[22]
&Global AFF_data-type     _inp_line[23]
&Global AFF_format        _inp_line[24]
&Global AFF_format-sa     _inp_line[25]
&Global AFF_valid-msg     _inp_line[26]
&Global AFF_valid-expr    _inp_line[27]
&Global AFF_no-label      _inp_line[28]
&Global AFF_extent        _inp_line[29]
&Global AFF_auto-return   _inp_line[30]
&Global AFF_deblank       _inp_line[31]
&Global AFF_blank         _inp_line[32]
&Global AFF_native        _inp_line[33]
&Global AFF_undo          _inp_line[34]
&Global AFF_tooltip       _inp_line[35]
&Global AFF_tooltip-attr  _inp_line[36]
&Global AFF_drop-target   _inp_line[37]
&Global AFF_no-tab-stop   _inp_line[38]
&Global AFF_disable-auto-zap _inp_line[39]
&Global AFF_context-help-id _inp_line[40]

&ELSEIF "{&TYPE}" eq "IMAGE" &THEN

/* ANALYZER IMAGE (AIM) Data   */
&Global AIM_image          _inp_line[17]
&Global AIM_tooltip        _inp_line[20]
&Global AIM_tooltip-attr   _inp_line[21]
&Global AIM_convert-3d-clr _inp_line[22]
&Global AIM_stretch-to-fit _inp_line[23]
&Global AIM_retain-shape   _inp_line[24]
&Global AIM_transparent    _inp_line[25]

&ELSEIF "{&TYPE}" eq "RADIO-SET" &THEN

/* ANALYZER Radio-Set (ARS) Data   */
&Global ARS_col-label     _inp_line[17]
&Global ARS_col-label-sa  _inp_line[18]
&Global ARS_label         _inp_line[19]
&Global ARS_label-sa      _inp_line[20]
&Global ARS_orientation   _inp_line[21]
&Global ARS_data-type     _inp_line[22]
&Global ARS_undo          _inp_line[23]
&Global ARS_extent        _inp_line[24]
&Global ARS_expand        _inp_line[25]
&Global ARS_tooltip       _inp_line[26]
&Global ARS_tooltip-attr  _inp_line[27]
&Global ARS_drop-target   _inp_line[28]
&Global ARS_no-tab-stop   _inp_line[29]
&Global ARS_context-help-id _inp_line[30]

&ELSEIF "{&TYPE}" eq "RECTANGLE" &THEN

/* ANALYZER Rectangle (ARC) Data   */
&Global ARC_edge-pixels   _inp_line[17]
&Global ARC_no-fill       _inp_line[18]
&Global ARC_tooltip       _inp_line[19]
&Global ARC_tooltip-attr  _inp_line[20]

&ELSEIF "{&TYPE}" eq "SELECTION-LIST" &THEN

/* ANALYZER Selection-List (ASE) Data   */
&Global ASE_col-label     _inp_line[17]
&Global ASE_col-label-sa  _inp_line[18]
&Global ASE_label         _inp_line[19]
&Global ASE_label-sa      _inp_line[20]
&Global ASE_inner-chars   _inp_line[21]
&Global ASE_inner-lines   _inp_line[22]
&Global ASE_multiple      _inp_line[23]
&Global ASE_no-drag       _inp_line[24]
&Global ASE_sort          _inp_line[25]
&Global ASE_num-items     _inp_line[26]
&Global ASE_scrollbar-h   _inp_line[27]
&Global ASE_scrollbar-v   _inp_line[28]
&Global ASE_undo          _inp_line[29]
&Global ASE_extent        _inp_line[30]
&Global ASE_tooltip       _inp_line[31]
&Global ASE_tooltip-attr  _inp_line[32]
&Global ASE_drop-target   _inp_line[33]
&Global ASE_no-tab-stop   _inp_line[34]
&Global ASE_list-item-pairs _inp_line[35]
&Global ASE_context-help-id _inp_line[36]

&ELSEIF "{&TYPE}" eq "SLIDER" &THEN

/* ANALYZER Slider (ASL) Data   */
&Global ASL_col-label        _inp_line[17]
&Global ASL_col-label-sa     _inp_line[18]
&Global ASL_label            _inp_line[19]
&Global ASL_label-sa         _inp_line[20]
&Global ASL_min-value        _inp_line[21]
&Global ASL_max-value        _inp_line[22]
&Global ASL_orientation      _inp_line[23]
&Global ASL_undo             _inp_line[24]
&Global ASL_extent           _inp_line[25]
&Global ASL_large-to-small   _inp_line[26]
&Global ASL_no-current-value _inp_line[27]
&Global ASL_tic-marks        _inp_line[28]
&Global ASL_frequency        _inp_line[29]
&Global ASL_tooltip          _inp_line[30]
&Global ASL_tooltip-attr     _inp_line[31]
&Global ASL_drop-target      _inp_line[32]
&Global ASL_no-tab-stop      _inp_line[33]
&Global ASL_context-help-id  _inp_line[34]

&ELSEIF "{&TYPE}" eq "TOGGLE-BOX" &THEN

/* ANALYZER Toggle-Box (ATB) Data   */
&Global ATB_undo            _inp_line[19]
&Global ATB_extent          _inp_line[20]
&Global ATB_tooltip         _inp_line[21]
&Global ATB_tooltip-attr    _inp_line[22]
&Global ATB_drop-target     _inp_line[23]
&Global ATB_no-tab-stop     _inp_line[24]
&Global ATB_context-help-id _inp_line[25]

&ELSEIF "{&TYPE}" eq "LITERAL" &THEN

/* ANALYZER Literal Text (ALI) Data   */
&Global ALI_literal       _inp_line[17]
&Global ALI_tooltip       _inp_line[19]
&Global ALI_tooltip-attr  _inp_line[20]

&ENDIF




