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
FUNCTION createBandAction RETURNS LOGICAL (
    pcBandName AS CHARACTER,
    pcActionReference AS CHARACTER,                                          
    piActionSequence AS INTEGER):

    FIND FIRST ryc_band
      WHERE ryc_band.band_name = pcBandName
      NO-ERROR.
    IF NOT AVAILABLE ryc_band
    THEN DO:
      MESSAGE "Unable to find band " pcBandName.
      RETURN FALSE.
    END.

    FIND FIRST ryc_action
      WHERE ryc_action.action_reference = pcActionReference
      NO-ERROR.
    IF NOT AVAILABLE ryc_action
    THEN DO:
      MESSAGE "Unable to find action " pcActionReference.
      RETURN FALSE.
    END.

    FIND FIRST ryc_band_action
      WHERE ryc_band_action.band_obj = ryc_band.band_obj
      AND   ryc_band_action.action_obj = ryc_action.action_obj
      NO-ERROR.
    IF AVAILABLE ryc_band_action
    THEN DO:
      MESSAGE "ERROR: Band " pcBandName " with Action " pcActionReference " already exist".
      RETURN FALSE.
    END.
    ELSE DO:
      CREATE ryc_band_action.
      ASSIGN
        ryc_band_action.band_obj = ryc_band.band_obj
        ryc_band_action.band_action_sequence = piActionSequence
        ryc_band_action.action_obj = ryc_action.action_obj.
        .
    END.

END FUNCTION.

/* get rid of existing stuff */
FOR EACH ryc_band:
  DELETE ryc_band.
END.
FOR EACH ryc_action:
  DELETE ryc_action.
END.


/* Adm2 standard buttons */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Exit":U
   ryc_action.action_label              = "E&xit":U
   ryc_action.action_accelerator        = "ALT-X":U
   ryc_action.action_menu_label         = "E&xit":U
   ryc_action.security_token            = "Exit":U
   ryc_action.action_tooltip            = "Exit":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/exit.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "exitObject":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   .                                           

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Add":U
   ryc_action.action_label              = "&Add":U
   ryc_action.action_accelerator        = "ALT-A":U
   ryc_action.action_menu_label         = "&Add record":U
   ryc_action.security_token            = "Add":U
   ryc_action.action_tooltip            = "Add record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/add.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "addRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Update,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Initial-TableIo,Add-Only"
   .                                        


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Update":U
   ryc_action.action_label              = "&Modify":U
   ryc_action.action_accelerator        = "ALT-M":U
   ryc_action.action_menu_label         = "&Modify record":U
   ryc_action.security_token            = "Modify":U
   ryc_action.action_tooltip            = "Modify record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/update.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "updateMode":U
   ryc_action.action_link               = "tableio-target":U
   ryc_action.action_parameter          = "UpdateBegin":U
   ryc_action.disable_state_list        = "Update,Add-Only,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Initial-TableIo":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Copy":U
   ryc_action.action_label              = "&Copy":U
   ryc_action.action_accelerator        = "ALT-C":U
   ryc_action.action_menu_label         = "&Copy record":U
   ryc_action.security_token            = "Copy":U
   ryc_action.action_tooltip            = "Copy record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/copyrec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "copyRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Update,Add-Only,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Initial-TableIo"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Delete":U
   ryc_action.action_label              = "&Delete":U
   ryc_action.action_accelerator        = "ALT-D":U
   ryc_action.action_menu_label         = "&Delete record":U
   ryc_action.security_token            = "Delete":U
   ryc_action.action_tooltip            = "Delete record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/deleterec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "deleteRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Update,Add-Only,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Initial-TableIo"
   .                                                 

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Save":U
   ryc_action.action_label              = "&Save":U
   ryc_action.action_accelerator        = "ALT-S":U
   ryc_action.action_menu_label         = "&Save record":U
   ryc_action.security_token            = "Save":U
   ryc_action.action_tooltip            = "Save record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/saverec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "updateRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Initial-TableIo,Add-Only,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Update"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Reset":U
   ryc_action.action_label              = "&Reset":U
   ryc_action.action_accelerator        = "ALT-R":U
   ryc_action.action_menu_label         = "&Reset record":U
   ryc_action.security_token            = "Reset":U
   ryc_action.action_tooltip            = "Reset record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/reset.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "resetRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Initial-TableIo,Add-Only,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Update"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Cancel":U
   ryc_action.action_label              = "Cance&l":U
   ryc_action.action_accelerator        = "ALT-L":U
   ryc_action.action_menu_label         = "Cance&l record":U
   ryc_action.security_token            = "Cancel":U
   ryc_action.action_tooltip            = "Cancel record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/cancel.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "cancelRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Initial-TableIo,Add-Only":U
   ryc_action.enable_state_list         = "Update"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Undo":U
   ryc_action.action_label              = "U&ndo":U
   ryc_action.action_accelerator        = "ALT-N":U
   ryc_action.action_menu_label         = "U&ndo":U
   ryc_action.security_token            = "Undo":U
   ryc_action.action_tooltip            = "Undo transaction":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/rollback.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "undoTransaction":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Disable-commit":U
   ryc_action.enable_state_list         = "Enable-commit"
   .                                              

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Commit":U
   ryc_action.action_label              = "Co&mmit":U
   ryc_action.action_accelerator        = "ALT-M":U
   ryc_action.action_menu_label         = "Co&mmit":U
   ryc_action.security_token            = "Commit":U
   ryc_action.action_tooltip            = "Commit transaction":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/commit.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "commitTransaction":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Disable-commit":U
   ryc_action.enable_state_list         = "Enable-commit"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2First":U
   ryc_action.action_label              = "&First":U
   ryc_action.action_accelerator        = "ALT-CURSOR-UP":U
   ryc_action.action_menu_label         = "&First":U
   ryc_action.security_token            = "First":U
   ryc_action.action_tooltip            = "First":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/first.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "navigation-target":U
   ryc_action.on_choose_action          = "fetchFirst":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "FirstRecord,OnlyRecord,Disable-Nav":U
   ryc_action.enable_state_list         = "LastRecord,NotFirstOrLast,Enable-Nav"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Prev":U
   ryc_action.action_label              = "&Prev":U
   ryc_action.action_accelerator        = "ALT-CURSOR-LEFT":U
   ryc_action.action_menu_label         = "&Prev":U
   ryc_action.security_token            = "Prev":U
   ryc_action.action_tooltip            = "Previous":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/prev.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "navigation-target":U
   ryc_action.on_choose_action          = "fetchPrev":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "FirstRecord,OnlyRecord,Disable-Nav":U
   ryc_action.enable_state_list         = "LastRecord,NotFirstOrLast,Enable-Nav"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Next":U
   ryc_action.action_label              = "&Next":U
   ryc_action.action_accelerator        = "ALT-CURSOR-RIGHT":U
   ryc_action.action_menu_label         = "&Next":U
   ryc_action.security_token            = "Next":U
   ryc_action.action_tooltip            = "Next":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/next.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "navigation-target":U
   ryc_action.on_choose_action          = "fetchNext":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "LastRecord,OnlyRecord,Disable-Nav":U
   ryc_action.enable_state_list         = "FirstRecord,NotFirstOrLast,Enable-Nav"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Last":U
   ryc_action.action_label              = "&Last":U
   ryc_action.action_accelerator        = "ALT-CURSOR-DOWN":U
   ryc_action.action_menu_label         = "&Last":U
   ryc_action.security_token            = "Last":U
   ryc_action.action_tooltip            = "Last":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/last.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "navigation-target":U
   ryc_action.on_choose_action          = "fetchLast":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "LastRecord,OnlyRecord,Disable-Nav":U
   ryc_action.enable_state_list         = "FirstRecord,NotFirstOrLast,Enable-Nav"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Adm2Filter":U
   ryc_action.action_label              = "Fil&ter...":U
   ryc_action.action_accelerator        = "ALT-T":U
   ryc_action.action_menu_label         = "Fil&ter...":U
   ryc_action.security_token            = "Filter":U
   ryc_action.action_tooltip            = "Filter":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/filter.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "startFilter":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "Enable-filter"
   .

/* extra MIP stuff for testing */



CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtOK":U
   ryc_action.action_label              = "&OK":U
   ryc_action.action_accelerator        = "ALT-O":U
   ryc_action.action_menu_label         = "&OK":U
   ryc_action.security_token            = "OK":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Ok":U
   ryc_action.disable_state_list        = "View,Updatable":U
   ryc_action.enable_state_list         = "Modified,New":U
   ryc_action.hide_state_list           = "View,Updatable":U
   ryc_action.view_state_list           = "Modified,New":U
   .                                    

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtTableioOK":U
   ryc_action.action_label              = "&OK":U
   ryc_action.action_accelerator        = "ALT-O":U
   ryc_action.action_menu_label         = "&OK":U
   ryc_action.security_token            = "OK":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "tableio-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Ok":U
   ryc_action.disable_state_list        = "View,Updatable":U
   ryc_action.enable_state_list         = "Modified,New":U
   ryc_action.hide_state_list           = "View,Updatable":U
   ryc_action.view_state_list           = "Modified,New":U
   .                                    


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtClear":U
   ryc_action.action_label              = "&Clear":U
   ryc_action.action_accelerator        = "ALT-C":U
   ryc_action.action_menu_label         = "&Clear":U
   ryc_action.security_token            = "Clear":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Clear":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   ryc_action.hide_state_list           = "View":U
   ryc_action.view_state_list           = "Modify,Create":U
   .                                    

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtSelect":U
   ryc_action.action_label              = "&Select":U
   ryc_action.action_accelerator        = "ALT-S":U
   ryc_action.action_menu_label         = "&Select Record":U
   ryc_action.security_token            = "Select":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Select":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtCancel":U
   ryc_action.action_label              = "&Cancel":U
   ryc_action.action_accelerator        = "ALT-C":U
   ryc_action.action_menu_label         = "&Cancel":U
   ryc_action.security_token            = "Cancel":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Cancel":U
   ryc_action.disable_state_list        = "View,Updatable":U
   ryc_action.enable_state_list         = "New,Modified"
   ryc_action.hide_state_list           = "View,Updatable":U
   ryc_action.view_state_list           = "New,Modified":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtTableioCancel":U
   ryc_action.action_label              = "&Cancel":U
   ryc_action.action_accelerator        = "ALT-C":U
   ryc_action.action_menu_label         = "&Cancel":U
   ryc_action.security_token            = "Cancel":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "tableio-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Cancel":U
   ryc_action.disable_state_list        = "View,Updatable":U
   ryc_action.enable_state_list         = "New,Modified"
   ryc_action.hide_state_list           = "View,Updatable":U
   ryc_action.view_state_list           = "New,Modified":U
   .


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtExit":U
   ryc_action.action_label              = "E&xit":U
   ryc_action.action_accelerator        = "ALT-X":U
   ryc_action.action_menu_label         = "E&xit":U
   ryc_action.security_token            = "Exit":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "exitObject":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "Modified,New":U
   ryc_action.view_state_list           = "View,Updatable":U
   .


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtTableioExit":U
   ryc_action.action_label              = "E&xit":U
   ryc_action.action_accelerator        = "ALT-X":U
   ryc_action.action_menu_label         = "E&xit":U
   ryc_action.security_token            = "Exit":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "exit":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "Modified,New":U
   ryc_action.view_state_list           = "View,Updatable":U
   .


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtApply":U
   ryc_action.action_label              = "&Apply":U
   ryc_action.action_accelerator        = "ALT-A":U
   ryc_action.action_menu_label         = "&Apply":U
   ryc_action.security_token            = "Apply":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Apply":U
   ryc_action.disable_state_list        = "Initial-TableIo":U
   ryc_action.enable_state_list         = "Update"
   ryc_action.hide_state_list           = "Create,View":U
   ryc_action.view_state_list           = "Modify":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtCreate":U
   ryc_action.action_label              = "Cre&ate":U
   ryc_action.action_accelerator        = "ALT-A":U
   ryc_action.action_menu_label         = "Cre&ate":U
   ryc_action.security_token            = "Create":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Create":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "TxtHelp":U
   ryc_action.action_label              = "&Help":U
   ryc_action.action_accelerator        = "ALT-H":U
   ryc_action.action_menu_label         = "&Help":U
   ryc_action.security_token            = "Help":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Help":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "IconHelp":U
   ryc_action.action_label              = "&Help":U
   ryc_action.action_accelerator        = "ALT-H":U
   ryc_action.action_menu_label         = "&Help":U
   ryc_action.security_token            = "Help":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/help.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Help":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .


/* support for browsers - Navigation Right */


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraCopy":U
   ryc_action.action_label              = "&Copy":U
   ryc_action.action_accelerator        = "ALT-C":U
   ryc_action.action_menu_label         = "&Copy record":U
   ryc_action.security_token            = "Copy":U
   ryc_action.action_tooltip            = "Copy record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/copyrec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Copy":U
   ryc_action.disable_state_list        = "NoRecordAvailable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  
CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraDelete":U
   ryc_action.action_label              = "&Delete":U
   ryc_action.action_accelerator        = "ALT-D":U
   ryc_action.action_menu_label         = "&Delete record":U
   ryc_action.security_token            = "Delete":U
   ryc_action.action_tooltip            = "Delete record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/deleterec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Delete":U
   ryc_action.disable_state_list        = "NoRecordAvailable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  
CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraAdd":U
   ryc_action.action_label              = "&Add":U
   ryc_action.action_accelerator        = "ALT-A":U
   ryc_action.action_menu_label         = "&Add record":U
   ryc_action.security_token            = "Add":U
   ryc_action.action_tooltip            = "Add record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/add.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Add":U
   ryc_action.disable_state_list        = "No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "NoRecordAvailable,FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  
CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraAdd1":U
   ryc_action.action_label              = "&Add":U
   ryc_action.action_accelerator        = "ALT-A":U
   ryc_action.action_menu_label         = "&Add record":U
   ryc_action.security_token            = "Add":U
   ryc_action.action_tooltip            = "Add record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/add.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Add":U
   ryc_action.disable_state_list        = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "NoRecordAvailable":U
   .  
CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraModify":U
   ryc_action.action_label              = "&Modify":U
   ryc_action.action_accelerator        = "ALT-M":U
   ryc_action.action_menu_label         = "&Modify record":U
   ryc_action.security_token            = "Modify":U
   ryc_action.action_tooltip            = "Modify record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/update.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Modify":U
   ryc_action.disable_state_list        = "NoRecordAvailable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraView":U
   ryc_action.action_label              = "&View":U
   ryc_action.action_accelerator        = "ALT-V":U
   ryc_action.action_menu_label         = "&View record":U
   ryc_action.security_token            = "View":U
   ryc_action.action_tooltip            = "View record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afopen.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "View":U
   ryc_action.disable_state_list        = "NoRecordAvailable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraFind":U
   ryc_action.action_label              = "Fi&nd...":U
   ryc_action.action_accelerator        = "ALT-N":U
   ryc_action.action_menu_label         = "Fi&nd record...":U
   ryc_action.security_token            = "Find":U
   ryc_action.action_tooltip            = "Find record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/affind.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Find":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "NoRecordAvailable,FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraFilter":U
   ryc_action.action_label              = "Fil&ter...":U
   ryc_action.action_accelerator        = "ALT-T":U
   ryc_action.action_menu_label         = "Fil&ter records...":U
   ryc_action.security_token            = "Filter":U
   ryc_action.action_tooltip            = "Filter records":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/affunnel.gif":U
   ryc_action.image2_up_filename        = "ry/img/affuntick.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Filter":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast,NoRecordAvailable":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraPreview":U
   ryc_action.action_label              = "Pre&view":U
   ryc_action.action_menu_label         = "Print Pre&view":U
   ryc_action.security_token            = "Preview":U
   ryc_action.action_tooltip            = "Print Preview":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afprintpre.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Preview":U
   ryc_action.disable_state_list        = "NoRecordAvailable":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraExport":U
   ryc_action.action_label              = "&Export...":U
   ryc_action.action_menu_label         = "&Export...":U
   ryc_action.security_token            = "Export":U
   ryc_action.action_tooltip            = "Export":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/aftoexcel.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Export":U
   ryc_action.disable_state_list        = "NoRecordAvailable":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraAudit":U
   ryc_action.action_label              = "&Audit...":U
   ryc_action.action_menu_label         = "&Audit...":U
   ryc_action.security_token            = "Audit":U
   ryc_action.action_tooltip            = "Audit":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afauditlog.gif":U
   ryc_action.image2_up_filename        = "ry/img/afaudtick.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Audit":U
   ryc_action.disable_state_list        = "NoRecordAvailable":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraComments":U
   ryc_action.action_label              = "Co&mments...":U     
   ryc_action.action_menu_label         = "Co&mments...":U
   ryc_action.security_token            = "Comments":U
   ryc_action.action_tooltip            = "Comments":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
    ryc_action.image1_up_filename       = "ry/img/afcomment.gif":U
    ryc_action.image2_up_filename       = "ry/img/afcomtick.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Comments":U
   ryc_action.disable_state_list        = "NoRecordAvailable":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraHistory":U
   ryc_action.action_label              = "Status &History...":U     
   ryc_action.action_menu_label         = "Status &History...":U
   ryc_action.security_token            = "Status History":U
   ryc_action.action_tooltip            = "Status History":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/gs_status.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "History":U
   ryc_action.disable_state_list        = "NoRecordAvailable":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraReLogon":U
   ryc_action.action_label              = "Re-&Logon...":U     
   ryc_action.action_menu_label         = "Re-&Logon...":U
   ryc_action.security_token            = "Re-Logon":U
   ryc_action.action_tooltip            = "Re-Logon":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/gs_pword.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Re-Logon":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraSuspend":U
   ryc_action.action_label              = "&Suspend...":U     
   ryc_action.action_menu_label         = "&Suspend...":U
   ryc_action.security_token            = "Suspend":U
   ryc_action.action_tooltip            = "Suspend":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/gs_secure.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Suspend":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraTranslate":U
   ryc_action.action_label              = "&Translate...":U     
   ryc_action.action_menu_label         = "&Translate...":U
   ryc_action.security_token            = "Translate":U
   ryc_action.action_tooltip            = "Translate":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/gs_lang.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Translate":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraNotepad":U
   ryc_action.action_label              = "&Notepad...":U     
   ryc_action.action_menu_label         = "&Notepad...":U
   ryc_action.security_token            = "Notepad":U
   ryc_action.action_tooltip            = "Notepad":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afnotepad.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Notepad":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraWordpad":U
   ryc_action.action_label              = "&Wordpad...":U     
   ryc_action.action_menu_label         = "&Wordpad...":U
   ryc_action.security_token            = "Wordpad":U
   ryc_action.action_tooltip            = "Wordpad":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afwordpad.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Wordpad":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraCalculator":U
   ryc_action.action_label              = "&Calculator...":U     
   ryc_action.action_menu_label         = "&Calculator...":U
   ryc_action.security_token            = "Calculator":U
   ryc_action.action_tooltip            = "Calculator":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afcalc.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Calculator":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraWord":U
   ryc_action.action_label              = "&Word...":U     
   ryc_action.action_menu_label         = "&Word...":U
   ryc_action.security_token            = "Word":U
   ryc_action.action_tooltip            = "Word":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afword.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Word":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraExcel":U
   ryc_action.action_label              = "E&xcel...":U     
   ryc_action.action_menu_label         = "E&xcel...":U
   ryc_action.security_token            = "Excel":U
   ryc_action.action_tooltip            = "Excel":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afexcel.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Excel":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraStatus":U
   ryc_action.action_label              = "&Status...":U     
   ryc_action.action_menu_label         = "&Status...":U
   ryc_action.security_token            = "Status":U
   ryc_action.action_tooltip            = "Status":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afstatus.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Status":U
   ryc_action.disable_state_list        = "NoRecordAvailable":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraLookup":U
   ryc_action.action_label              = "&Lookup...":U     
   ryc_action.action_accelerator        = "F4":U
   ryc_action.action_menu_label         = "&Lookup...":U
   ryc_action.security_token            = "Lookup":U
   ryc_action.action_tooltip            = "Lookup":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/aflkfind.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Lookup":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .     

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraSpell":U
   ryc_action.action_label              = "&Spell":U     
   ryc_action.action_accelerator        = "F7":U
   ryc_action.action_menu_label         = "&Spell":U
   ryc_action.security_token            = "Spell":U
   ryc_action.action_tooltip            = "Spell":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afspell.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Spell":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .       

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraEmail":U
   ryc_action.action_label              = "&Email...":U     
   ryc_action.action_menu_label         = "&Email...":U
   ryc_action.security_token            = "Email":U
   ryc_action.action_tooltip            = "Email":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afmail.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Email":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraInternet":U
   ryc_action.action_label              = "&Internet...":U     
   ryc_action.action_menu_label         = "&Internet...":U
   ryc_action.security_token            = "Internet":U
   ryc_action.action_tooltip            = "Internet":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afinternet.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Internet":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FilterOK":U
   ryc_action.action_label              = "&OK":U
   ryc_action.action_accelerator        = "ALT-O":U
   ryc_action.action_menu_label         = "&OK":U
   ryc_action.security_token            = "OK":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Ok":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .                                    

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FilterClear":U
   ryc_action.action_label              = "C&lear":U
   ryc_action.action_accelerator        = "ALT-L":U
   ryc_action.action_menu_label         = "C&lear":U
   ryc_action.security_token            = "Clear":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Clear":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .                                    

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FilterCancel":U
   ryc_action.action_label              = "&Cancel":U
   ryc_action.action_accelerator        = "ALT-C":U
   ryc_action.action_menu_label         = "&Cancel":U
   ryc_action.security_token            = "Cancel":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Cancel":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FilterExit":U
   ryc_action.action_label              = "E&xit":U
   ryc_action.action_accelerator        = "ALT-X":U
   ryc_action.action_menu_label         = "E&xit":U
   ryc_action.security_token            = "Exit":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "exitObject":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FilterApply":U
   ryc_action.action_label              = "&Apply":U
   ryc_action.action_accelerator        = "ALT-A":U
   ryc_action.action_menu_label         = "&Apply":U
   ryc_action.security_token            = "Apply":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = NO
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_parameter          = "Apply":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = ""
   ryc_action.hide_state_list           = "":U
   ryc_action.view_state_list           = "":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraIconExit":U
   ryc_action.action_label              = "E&xit":U     
   ryc_action.action_accelerator        = "ALT-X":U
   ryc_action.action_menu_label         = "E&xit":U
   ryc_action.security_token            = "Exit":U
   ryc_action.action_tooltip            = "Exit":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/exit.gif"
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "exitObject":U
   ryc_action.action_link               = "":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraMenuExit":U
   ryc_action.action_label              = "E&xit":U     
   ryc_action.action_accelerator        = "ALT-X":U
   ryc_action.action_menu_label         = "E&xit":U
   ryc_action.security_token            = "Exit":U
   ryc_action.action_tooltip            = "Exit":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = ""
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "exitObject":U
   ryc_action.action_link               = "":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "MultiWindow":U
   ryc_action.action_label              = "&Multiple Windows":U     
   ryc_action.action_menu_label         = "&Multiple Windows":U
   ryc_action.security_token            = "MultiWindow":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PROPERTY":U
   ryc_action.on_choose_action          = "MultiInstanceActivated":U
   ryc_action.action_link               = "":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraPref":U
   ryc_action.action_label              = "&Preferences...":U     
   ryc_action.action_menu_label         = "&Preferences...":U
   ryc_action.security_token            = "Preferences":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Preferences":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraPrintSetup":U
   ryc_action.action_label              = "Print &Setup...":U     
   ryc_action.action_menu_label         = "Print &Setup...":U
   ryc_action.security_token            = "PrintSetup":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "PrintSetup":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "AstraPrint":U
   ryc_action.action_label              = "&Print":U     
   ryc_action.action_menu_label         = "&Print":U
   ryc_action.security_token            = "Print":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "Print":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "HelpTopics":U
   ryc_action.action_label              = "&Help Topics":U     
   ryc_action.action_menu_label         = "&Help Topics":U
   ryc_action.security_token            = "HelpTopics":U
   ryc_action.action_tooltip            = "Help topics":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "HelpTopics":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "HelpContents":U
   ryc_action.action_label              = "Help &Contents":U     
   ryc_action.action_menu_label         = "Help &Contents":U
   ryc_action.security_token            = "HelpContents":U
   ryc_action.action_tooltip            = "Help contents":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "HelpContents":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "HelpHelp":U
   ryc_action.action_label              = "How to &Use Help":U     
   ryc_action.action_menu_label         = "How to &Use Help":U
   ryc_action.security_token            = "HelpHelp":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "HelpHelp":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "HelpAbout":U
   ryc_action.action_label              = "Help &About":U     
   ryc_action.action_menu_label         = "Help &About":U
   ryc_action.security_token            = "HelpAbout":U
   ryc_action.action_tooltip            = "":U
   ryc_action.place_action_on_toolbar   = NO
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "toolbar":U
   ryc_action.action_link               = "toolbar-target":U
   ryc_action.action_parameter          = "HelpAbout":U
   ryc_action.disable_state_list        = "":U
   ryc_action.enable_state_list         = "":U
   .  

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FolderAdd":U
   ryc_action.action_label              = "&Add":U
   ryc_action.action_accelerator        = "ALT-A":U
   ryc_action.action_menu_label         = "&Add record":U
   ryc_action.security_token            = "Add":U
   ryc_action.action_tooltip            = "Add record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/add.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "addRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Modified,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "New,Updatable,View,Initial-tableio"
   .                                        


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FolderUpdate":U
   ryc_action.action_label              = "&Modify":U
   ryc_action.action_accelerator        = "ALT-M":U
   ryc_action.action_menu_label         = "&Modify record":U
   ryc_action.security_token            = "Modify":U
   ryc_action.action_tooltip            = "Modify record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/update.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "updateMode":U
   ryc_action.action_link               = "tableio-target":U
   ryc_action.action_parameter          = "Enable":U
   ryc_action.disable_state_list        = "Modified,Updatable,New,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "View":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FolderCopy":U
   ryc_action.action_label              = "&Copy":U
   ryc_action.action_accelerator        = "ALT-C":U
   ryc_action.action_menu_label         = "&Copy record":U
   ryc_action.security_token            = "Copy":U
   ryc_action.action_tooltip            = "Copy record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/copyrec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "copyRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Modified,New,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "View,Updatable,initial-tableio":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FolderDelete":U
   ryc_action.action_label              = "&Delete":U
   ryc_action.action_menu_label         = "&Delete record":U
   ryc_action.security_token            = "Delete":U
   ryc_action.action_tooltip            = "Delete record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/deleterec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "deleteRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Modified,New,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "View,Updatable,initial-tableio":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FolderSave":U
   ryc_action.action_label              = "&Save":U
   ryc_action.action_accelerator        = "ALT-S":U
   ryc_action.action_menu_label         = "&Save record":U
   ryc_action.security_token            = "Save":U
   ryc_action.action_tooltip            = "Save record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/saverec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "updateRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "View,Updatable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Modified,New"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FolderReset":U
   ryc_action.action_label              = "&Reset":U
   ryc_action.action_accelerator        = "ALT-R":U
   ryc_action.action_menu_label         = "&Reset record":U
   ryc_action.security_token            = "Reset":U
   ryc_action.action_tooltip            = "Reset record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/reset.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "resetRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "View,Updatable,New,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Modified"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FolderView":U
   ryc_action.action_label              = "&View":U
   ryc_action.action_accelerator        = "ALT-V":U
   ryc_action.action_menu_label         = "&View record":U
   ryc_action.security_token            = "View":U
   ryc_action.action_tooltip            = "View record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afopen.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "updateMode":U
   ryc_action.action_parameter          = "View":U
   ryc_action.disable_state_list        = "Modified,New,View,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Updatable"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "FolderUndo":U
   ryc_action.action_label              = "&Undo":U
   ryc_action.action_accelerator        = "ALT-U":U
   ryc_action.action_menu_label         = "&Undo":U
   ryc_action.security_token            = "Undo":U
   ryc_action.action_tooltip            = "Undo transaction":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/rollback.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "undoTransaction":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "New,View,Updatable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Modified"
   .                                              

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2Add":U
   ryc_action.action_label              = "&Add":U
   ryc_action.action_accelerator        = "ALT-A":U
   ryc_action.action_menu_label         = "&Add record":U
   ryc_action.security_token            = "Add":U
   ryc_action.action_tooltip            = "Add record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/add.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "addRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "Modified,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "NoRecordAvailable,FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast,New,Updatable,View,Initial-tableio"
   .                                        


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2Update":U
   ryc_action.action_label              = "&Modify":U
   ryc_action.action_accelerator        = "ALT-M":U
   ryc_action.action_menu_label         = "&Modify record":U
   ryc_action.security_token            = "Modify":U
   ryc_action.action_tooltip            = "Modify record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/update.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "updateMode":U
   ryc_action.action_link               = "tableio-target":U
   ryc_action.action_parameter          = "Enable":U
   ryc_action.disable_state_list        = "NoRecordAvailable,Modified,Updatable,New,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast,View":U
   .  


CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2Copy":U
   ryc_action.action_label              = "&Copy":U
   ryc_action.action_accelerator        = "ALT-C":U
   ryc_action.action_menu_label         = "&Copy record":U
   ryc_action.security_token            = "Copy":U
   ryc_action.action_tooltip            = "Copy record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/copyrec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "copyRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "NoRecordAvailable,Modified,New,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast,View,Updatable":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2Delete":U
   ryc_action.action_label              = "&Delete":U
   ryc_action.action_menu_label         = "&Delete record":U
   ryc_action.security_token            = "Delete":U
   ryc_action.action_tooltip            = "Delete record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/deleterec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "deleteRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "NoRecordAvailable,Modified,New,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast,View,Updatable":U
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2Save":U
   ryc_action.action_label              = "&Save":U
   ryc_action.action_accelerator        = "ALT-S":U
   ryc_action.action_menu_label         = "&Save record":U
   ryc_action.security_token            = "Save":U
   ryc_action.action_tooltip            = "Save record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/saverec.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "updateRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "NoRecordAvailable,View,Updatable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Modified,New"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2Cancel":U
   ryc_action.action_label              = "Cance&l":U
   ryc_action.action_accelerator        = "ALT-L":U
   ryc_action.action_menu_label         = "Cance&l record":U
   ryc_action.security_token            = "Cancel":U
   ryc_action.action_tooltip            = "Cancel record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/cancel.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "cancelRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "NoRecordAvailable,View,Updatable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "New"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2Reset":U
   ryc_action.action_label              = "&Reset":U
   ryc_action.action_accelerator        = "ALT-R":U
   ryc_action.action_menu_label         = "&Reset record":U
   ryc_action.security_token            = "Reset":U
   ryc_action.action_tooltip            = "Reset record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/reset.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "resetRecord":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "NoRecordAvailable,View,Updatable,New,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Modified"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2View":U
   ryc_action.action_label              = "&View":U
   ryc_action.action_accelerator        = "ALT-V":U
   ryc_action.action_menu_label         = "&View record":U
   ryc_action.security_token            = "View":U
   ryc_action.action_tooltip            = "View record":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/afopen.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "updateMode":U
   ryc_action.action_parameter          = "View":U
   ryc_action.disable_state_list        = "NoRecordAvailable,Modified,New,View,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "FirstRecord,OnlyRecord,LastRecord,NotFirstOrLast,Updatable"
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference          = "Folder2Undo":U
   ryc_action.action_label              = "&Undo":U
   ryc_action.action_accelerator        = "ALT-U":U
   ryc_action.action_menu_label         = "&Undo":U
   ryc_action.security_token            = "Undo":U
   ryc_action.action_tooltip            = "Undo transaction":U
   ryc_action.place_action_on_toolbar   = YES
   ryc_action.place_action_on_menu      = YES
   ryc_action.image1_up_filename        = "ry/img/rollback.gif":U
   ryc_action.action_type_code          = "PUBLISH":U
   ryc_action.on_choose_action          = "undoTransaction":U
   ryc_action.action_parameter          = "":U
   ryc_action.disable_state_list        = "NoRecordAvailable,New,View,Updatable,No-Tabs-Enabled":U
   ryc_action.enable_state_list         = "Modified"
   .                                              

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "BrowseTableio":U
  ryc_band.band_sequence                = 6
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

createBandAction("BrowseTableio", "AstraAdd",       1).                                                 
createBandAction("BrowseTableio", "AstraDelete",    2).  
createBandAction("BrowseTableio", "AstraCopy",      3).  
createBandAction("BrowseTableio", "AstraModify",    4).  
createBandAction("BrowseTableio", "AstraView",      5).                     

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "BrowseTableio1":U
  ryc_band.band_sequence                = 6
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

createBandAction("BrowseTableio1", "AstraAdd1",      1).                                                 
createBandAction("BrowseTableio1", "AstraDelete",    2).  
createBandAction("BrowseTableio1", "AstraModify",    4).  
createBandAction("BrowseTableio1", "AstraView",      5).                     

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "BrowseTableioView":U
  ryc_band.band_sequence                = 6
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

createBandAction("BrowseTableioView", "AstraView",      5).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "Adm2NavRight":U
  ryc_band.band_sequence                = 5 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "navigation-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

createBandAction("Adm2NavRight", "Adm2First",   1).  
createBandAction("Adm2NavRight", "Adm2Prev",    2).
createBandAction("Adm2NavRight", "Adm2Next",    3).
createBandAction("Adm2NavRight", "Adm2Last",    4).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "TxtAction":U
  ryc_band.band_sequence                = 998 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .


createBandAction("TxtAction", "TxtOk",      1).
createBandAction("TxtAction", "TxtCancel",  2).
createBandAction("TxtAction", "TxtExit",    3).
/* createBandAction("TxtAction", "TxtApply",   4). */
/* createBandAction("TxtAction", "TxtCreate",  5). */
createBandAction("TxtAction", "TxtHelp",    4).
createBandAction("TxtAction", "AstraTranslate", 5).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "TxtLookup":U
  ryc_band.band_sequence                = 998 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

createBandAction("TxtLookup", "TxtSelect",      1).
createBandAction("TxtLookup", "AstraTranslate", 2).
createBandAction("TxtLookup", "TxtExit",        3).
createBandAction("TxtLookup", "TxtHelp",        4).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "TxtTableio":U
  ryc_band.band_sequence                = 998 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .


createBandAction("TxtTableio", "TxtTableioOk",      1).
createBandAction("TxtTableio", "TxtTableioCancel",  2).
createBandAction("TxtTableio", "TxtExit",    3).
/* createBandAction("TxtAction", "TxtApply",   4). */
/* createBandAction("TxtAction", "TxtCreate",  5). */
createBandAction("TxtTableio", "TxtHelp",    4).


CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "Adm2Function":U
  ryc_band.band_sequence                = 4
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "":U
  .

createBandAction("Adm2Function", "Adm2Filter", 1).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "Adm2Navigation":U
  ryc_band.band_sequence                = 3
  ryc_band.band_submenu_label           = "&File,Navigation":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "navigation-target":U
  .

createBandAction("Adm2Navigation", "Adm2First", 1).  
createBandAction("Adm2Navigation", "Adm2Prev",  2).
createBandAction("Adm2Navigation", "Adm2Next",  3).
createBandAction("Adm2Navigation", "Adm2Last",  4).


CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "Adm2Transaction":U
  ryc_band.band_sequence                = 2
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "commit-target":U
  .

createBandAction("Adm2Transaction", "Adm2Undo",     1).
createBandAction("Adm2Transaction", "Adm2Commit",   2).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "Adm2File":U
  ryc_band.band_sequence                = 1 
  ryc_band.band_submenu_label           = "&File":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "":U
  .


CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "Adm2Exit":U
  ryc_band.band_sequence                = 999 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "":U
  .

createBandAction("Adm2Exit", "Adm2Exit", 1).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "Adm2TableIo":U
  ryc_band.band_sequence                = 1 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "tableio-target":U
  .

createBandAction("Adm2Tableio", "Adm2Add",      1).
/* createBandAction("Adm2Tableio", "Adm2Update", 2). */
createBandAction("Adm2Tableio", "Adm2Copy",     3).
createBandAction("Adm2Tableio", "Adm2Delete",   4).  
createBandAction("Adm2Tableio", "Adm2Save",     5).
createBandAction("Adm2Tableio", "Adm2Reset",    6).
createBandAction("Adm2Tableio", "Adm2Cancel",   7).
createBandAction("Adm2Tableio", "Adm2Update",   8).



CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "BrowseFunction":U
  ryc_band.band_sequence                = 11
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "tableio-target":U
  .

createBandAction("BrowseFunction", "AstraPreview",  1).
createBandAction("BrowseFunction", "AstraExport",   2).
createBandAction("BrowseFunction", "AstraAudit",    3).
createBandAction("BrowseFunction", "AstraComments", 4).
createBandAction("BrowseFunction", "AstraStatus",   5).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "BrowseFunction4Function":U
  ryc_band.band_sequence                = 11
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "tableio-target":U
  .

createBandAction("BrowseFunction4Function", "AstraPreview",  1).
createBandAction("BrowseFunction4Function", "AstraExport",   2).


CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "BrowseSearch":U
  ryc_band.band_sequence                = 10
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "CEN":U
  ryc_band.band_link                    = "tableio-target":U
  .


createBandAction("BrowseSearch", "AstraFind",     1).
createBandAction("BrowseSearch", "AstraFilter",    2).



CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "FolderFunction":U
  ryc_band.band_sequence                = 7 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "CEN":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

/* createBandAction("FolderFunction", "AstraLookup",    1). */
createBandAction("FolderFunction", "AstraSpell",     2).
createBandAction("FolderFunction", "AstraTranslate", 3).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraFilter":U
  ryc_band.band_sequence                = 997
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "toolbar-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

createBandAction("AstraFilter", "FilterOk",     1).
createBandAction("AstraFilter", "FilterCancel", 2).
createBandAction("AstraFilter", "FilterApply",  3).
createBandAction("AstraFilter", "FilterClear",  4).
createBandAction("AstraFilter", "TxtHelp",   5).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraFile":U
  ryc_band.band_sequence                = 100 
  ryc_band.band_submenu_label           = "&File":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "":U
  .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "MenuFunction":U
  ryc_band.band_sequence                = 110
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

createBandAction("MenuFunction", "AstraReLogon",   1).
createBandAction("MenuFunction", "AstraSuspend",   2).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraSystem":U
  ryc_band.band_sequence                = 120
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "toolbar-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "":U
  .
createBandAction("AstraSystem", "AstraPref",         1).                                                 
createBandAction("AstraSystem", "AstraPrintSetup",   2).                                                 
createBandAction("AstraSystem", "AstraTranslate",    3).                                                 

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraWindows":U
  ryc_band.band_sequence                = 140
  ryc_band.band_submenu_label           = "&File,Desktop":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "tableio-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "view":U
  .

createBandAction("AstraWindows", "AstraNotepad",    1).
createBandAction("AstraWindows", "AstraWordpad",    2).
createBandAction("AstraWindows", "AstraCalculator", 3).
createBandAction("AstraWindows", "AstraEmail",      4).
createBandAction("AstraWindows", "AstraInternet",   5).
createBandAction("AstraWindows", "AstraWord",       6).
createBandAction("AstraWindows", "AstraExcel",      7).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "DynamicMenu":U
  ryc_band.band_sequence                = 200 
  ryc_band.band_submenu_label           = "":U
  ryc_band.band_alignment               = "CEN":U
  ryc_band.band_link                    = "":U
  ryc_band.inherit_menu_icons           = YES
  ryc_band.initial_state                = "":U
  .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraWindow":U
  ryc_band.band_sequence                = 300
  ryc_band.band_submenu_label           = "&Window":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "":U
  .
createBandAction("AstraWindow", "MultiWindow",    1).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraHelp":U
  ryc_band.band_sequence                = 320
  ryc_band.band_submenu_label           = "&Help":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "toolbar-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "":U
  .

createBandAction("AstraHelp", "HelpTopics",      1).                                                 
createBandAction("AstraHelp", "HelpContents",    2).                                                 
createBandAction("AstraHelp", "HelpHelp",        3).                                                 

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraAbout":U
  ryc_band.band_sequence                = 330
  ryc_band.band_submenu_label           = "&Help":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "toolbar-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "":U
  .

createBandAction("AstraAbout", "HelpAbout",       1).                                                 

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraIconExit":U
  ryc_band.band_sequence                = 999
  ryc_band.band_submenu_label           = "&File":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "toolbar-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "":U
  .
createBandAction("AstraIconExit", "AstraIconExit",      1).                                                 


CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "AstraMenuExit":U
  ryc_band.band_sequence                = 999
  ryc_band.band_submenu_label           = "&File":U
  ryc_band.band_alignment               = "RIG":U
  ryc_band.band_link                    = "toolbar-target":U
  ryc_band.inherit_menu_icons           = NO
  ryc_band.initial_state                = "":U
  .
createBandAction("AstraMenuExit", "AstraMenuExit",      1). 

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "FolderTableIo":U
  ryc_band.band_sequence                = 1 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "tableio-target":U
  .

createBandAction("FolderTableio", "FolderAdd",      1).
createBandAction("FolderTableio", "FolderCopy",     2).
/* createBandAction("FolderTableio", "FolderDelete",   3). */
createBandAction("FolderTableio", "FolderSave",     4).
createBandAction("FolderTableio", "FolderReset",    5).
createBandAction("FolderTableio", "FolderView",     6).
createBandAction("FolderTableio", "FolderUpdate",   7).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                    = "Folder2Tableio":U
  ryc_band.band_sequence                = 1 
  ryc_band.band_submenu_label           = "RULE":U
  ryc_band.band_alignment               = "LEF":U
  ryc_band.band_link                    = "tableio-target":U
  .

createBandAction("Folder2Tableio", "Folder2Add",      1).
createBandAction("Folder2Tableio", "Folder2Copy",     2).
createBandAction("Folder2Tableio", "Folder2Delete",   3).
createBandAction("Folder2Tableio", "Folder2Save",     4).
createBandAction("Folder2Tableio", "Folder2Reset",    5).
createBandAction("Folder2Tableio", "Folder2Cancel",   6).
createBandAction("Folder2Tableio", "Folder2View",     7).
createBandAction("Folder2Tableio", "Folder2Update",   8).

/* WEB TOOLBAR PANELS */
/**********************/

/* Web Toolbar Product Panel */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbProduct":U
   ryc_action.action_label                = "":U
   ryc_action.action_tooltip              = "":U
   ryc_action.image1_up_filename          = "/af/wimg/a_032_trans.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/a_032_trans.gif":U
   ryc_action.on_choose_action            = "fnHelpOpen(" + '"':U + "/af/hlp/astraweb/htm/helpcontents1.htm" + '"':U + ")":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarProduct":U
  ryc_band.band_sequence                  = 1
  ryc_band.band_alignment                 = "LEF":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarProduct", "wbProduct", 1).

/* Web Toolbar Frame Panel */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbMenu":U
   ryc_action.action_label                = "Menu":U
   ryc_action.action_tooltip              = "Toggle the menu frame on/off":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_menu.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_menu.gif":U
   ryc_action.on_choose_action            = "fnMenuToggle()":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbInfo":U
   ryc_action.action_label                = "Info":U
   ryc_action.action_tooltip              = "Toggle the info frame on/off":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_align.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_align.gif":U
   ryc_action.on_choose_action            = "fnInfoToggle()":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarFrame":U
  ryc_band.band_sequence                  = 2
  ryc_band.band_alignment                 = "LEF":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarFrame", "wbMenu",  1).
createBandAction("WebToolbarFrame", "wbInfo",  2).

/* Web Toolbar Form Functions */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbCalculator":U
   ryc_action.action_label                = "Calculator":U
   ryc_action.action_tooltip              = "Pop-up calculator":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_help.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_help.gif":U
   ryc_action.on_choose_action            = "fnFilterToggle()":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarFormFunc":U
  ryc_band.band_sequence                  = 1
  ryc_band.band_alignment                 = "CEN":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarFormFunc", "wbCalculator",  1).

/* Web Toolbar Browse Functions */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbFilter":U
   ryc_action.action_label                = "Filter":U
   ryc_action.action_tooltip              = "Toggle to view/hide filter criteria":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_filter_off.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_filter_off.gif":U
   ryc_action.image2_up_filename          = "/af/wimg/pnl_ac_filter_on.gif":U
   ryc_action.image2_insensitive_filename = "/af/wimg/pnl_in_filter_on.gif":U
   ryc_action.on_choose_action            = "fnFilterToggle()":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbRefresh":U
   ryc_action.action_label                = "Refresh":U
   ryc_action.action_tooltip              = "Refresh the browser":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_refresh.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_refresh.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarBrowseFunc":U
  ryc_band.band_sequence                  = 2
  ryc_band.band_alignment                 = "CEN":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarBrowseFunc", "wbFilter",  1).
createBandAction("WebToolbarBrowseFunc", "wbRefresh", 2).

/* Web Toolbar Navigation panel */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbFirst":U
   ryc_action.action_label                = "First":U
   ryc_action.action_tooltip              = "First record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_first.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_first.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbPrevious":U
   ryc_action.action_label                = "Prev":U
   ryc_action.action_tooltip              = "Previous record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_prev.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_prev.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbNext":U
   ryc_action.action_label                = "Next":U
   ryc_action.action_tooltip              = "Next record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_next.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_next.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbLast":U
   ryc_action.action_label                = "Last":U
   ryc_action.action_tooltip              = "Last record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_last.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_last.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarNav":U
  ryc_band.band_sequence                  = 3
  ryc_band.band_alignment                 = "CEN":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarNav", "wbFirst",    1).
createBandAction("WebToolbarNav", "wbPrevious", 2).
createBandAction("WebToolbarNav", "wbNext",     3).
createBandAction("WebToolbarNav", "wbLast",     4).

/* Web Toolbar Function Panel */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbAdd":U
   ryc_action.action_label                = "Add":U
   ryc_action.action_tooltip              = "Add a record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_add.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_add.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbDelete":U
   ryc_action.action_label                = "Delete":U
   ryc_action.action_tooltip              = "Delete the record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_del.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_del.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbCopy":U
   ryc_action.action_label                = "Copy":U
   ryc_action.action_tooltip              = "Copy the record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_copy.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_copy.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbModify":U
   ryc_action.action_label                = "Modify":U
   ryc_action.action_tooltip              = "Modify the record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_mod.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_mod.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbView":U
   ryc_action.action_label                = "View":U
   ryc_action.action_tooltip              = "View the record":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_view.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_view.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarFunc":U
  ryc_band.band_sequence                  = 1
  ryc_band.band_alignment                 = "RIG":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarFunc", "wbAdd",    1).
createBandAction("WebToolbarFunc", "wbDelete", 2).
createBandAction("WebToolbarFunc", "wbCopy",   3).
createBandAction("WebToolbarFunc", "wbModify", 4).
createBandAction("WebToolbarFunc", "wbView",   5).

/* Web Toolbar Update & Select panels */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbOK":U
   ryc_action.action_label                = "OK":U
   ryc_action.action_tooltip              = "Accept this action":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_ok.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_ok.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbCancel":U
   ryc_action.action_label                = "Cancel":U
   ryc_action.action_tooltip              = "Cancel this action":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_cancel.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_cancel.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbApply":U
   ryc_action.action_label                = "Apply":U
   ryc_action.action_tooltip              = "Apply updates":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_commit.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_commit.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarUpdate":U
  ryc_band.band_sequence                  = 2
  ryc_band.band_alignment                 = "RIG":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarUpdate", "wbOK",     1).
createBandAction("WebToolbarUpdate", "wbCancel", 2).
createBandAction("WebToolbarUpdate", "wbApply",  3).

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarSelect":U
  ryc_band.band_sequence                  = 3
  ryc_band.band_alignment                 = "RIG":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarSelect", "wbOK",     1).
createBandAction("WebToolbarSelect", "wbCancel", 2).

/* Web Lookup OK / Cancel Panel */
/* Note that this is different because it fires custom JavaScript functions */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbLookupOK":U
   ryc_action.action_label                = "OK":U
   ryc_action.action_tooltip              = "Accept this action":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_ok.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_ok.gif":U
   ryc_action.on_choose_action            = "fnReturnLookup()":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbLookupCancel":U
   ryc_action.action_label                = "Cancel":U
   ryc_action.action_tooltip              = "Cancel this action":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_cancel.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_cancel.gif":U
   ryc_action.on_choose_action            = "parent.window.close()":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarLookup":U
  ryc_band.band_sequence                  = 2
  ryc_band.band_alignment                 = "RIG":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarLookup", "wbLookupOK",     1).
createBandAction("WebToolbarLookup", "wbLookupCancel", 2).

/* Web Toolbar Control Panel */

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbBack":U
   ryc_action.action_label                = "Back":U
   ryc_action.action_tooltip              = "Back":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_back.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_back.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbExit":U
   ryc_action.action_label                = "Exit":U
   ryc_action.action_tooltip              = "Exit":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_exit.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_exit.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_action.
ASSIGN
   ryc_action.action_reference            = "wbHelp":U
   ryc_action.action_label                = "Help":U
   ryc_action.action_tooltip              = "Debugging information":U
   ryc_action.image1_up_filename          = "/af/wimg/pnl_ac_help2.gif":U
   ryc_action.image1_insensitive_filename = "/af/wimg/pnl_in_help2.gif":U
   ryc_action.system_owned                = YES
   .

CREATE ryc_band.
ASSIGN
  ryc_band.band_name                      = "WebToolbarControl":U
  ryc_band.band_sequence                  = 4
  ryc_band.band_alignment                 = "RIG":U
  ryc_band.system_owned                   = YES
  .

createBandAction("WebToolbarControl", "wbBack", 1).
createBandAction("WebToolbarControl", "wbExit", 2).
createBandAction("WebToolbarControl", "wbHelp", 3).

