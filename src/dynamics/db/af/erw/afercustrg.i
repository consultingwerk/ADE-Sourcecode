%If(%Or(%==(%DiagramProp("DBlogical"),"ICFDB"),%==(%DiagramProp("DBlogical"),"RVDB"))) {
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
* Contributors: MIP Holdings (Pty) Ltd ("MIP")                       *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
}
TRIGGER PROCEDURE FOR %Action OF %TableName %If(%==(%Action, WRITE)) {OLD BUFFER o_%TableName}.

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   %TableName           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE %TableName
&SCOPED-DEFINE TRIGGER_FLA %EntityProp("TableFLA")
%If(%==("%EntityProp(TableObj)", "%EntityProp(XYZ)")) {&SCOPED-DEFINE TRIGGER_OBJ %lower(%Substr(%TableName,%DiagramProp("TableSubstr")))_obj}
%If(%!=("%EntityProp(TableObj)", "%EntityProp(XYZ)")) {&SCOPED-DEFINE TRIGGER_OBJ %EntityProp("TableObj")}

DEFINE BUFFER lb_table FOR %TableName.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR %TableName.     /* Used for lock upgrades */

%If(%!==(%Action, WRITE)) {DEFINE BUFFER o_%TableName FOR %TableName.}

/* Standard top of %Action trigger code */
%If(%==(%Action, CREATE)) {{af/sup/aftrigtopc.i}}%If(%==(%Action, DELETE)) {{af/sup/aftrigtopd.i}}%If(%==(%Action, WRITE)) {{af/sup/aftrigtopw.i}}

%If(%==(%Action, WRITE)){
/* properform fields if enabled for table */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = '%EntityProp("TableFLA")':U
              AND gsc_entity_mnemonic.auto_properform_strings = YES) THEN
  RUN af/app/afpropfrmp.p (INPUT BUFFER %TableName:HANDLE).
}  

%If(%==(%Action, DELETE)) { 
%If(%!=("%EntityProp(ScmField)", "%EntityProp(XYZ)")) {%If(%==("%EntityProp(TableFLA)", "%EntityProp(ReplicateFLA)")) {
/* Code to update action underway table - used in replication trigger delete cascades */
IF VALID-HANDLE(gshSessionManager)
THEN DO:
  RUN setActionUnderway IN gshSessionManager
                       (INPUT "DYN":U
                       ,INPUT "DEL":U
                       ,INPUT STRING(%TableName.%EntityProp(ScmField))
                       ,INPUT "%EntityProp(TableFLA)":U
                       ,INPUT STRING(%TableName.%EntityProp(ReplicateKey))
                       ).
END.}}
}

%ForEachChildRel() {%RelTemplate}
%ForEachParentRel() {%RelTemplate}

%If(%!==("%EntityProp(TableObj)", "none")) {
%If(%==(%Action, DELETE)) {
/* Generic comments deletion */
DEFINE BUFFER lbx_gsm_comment FOR gsm_comment.
DEFINE BUFFER lby_gsm_comment FOR gsm_comment.
IF CAN-FIND(FIRST lbx_gsm_comment 
            WHERE lbx_gsm_comment.owning_obj = %TableName.{&TRIGGER_OBJ}) THEN
    FOR EACH lbx_gsm_comment NO-LOCK
       WHERE lbx_gsm_comment.owning_obj = %TableName.{&TRIGGER_OBJ}
       ON STOP UNDO, RETURN ERROR "AF^104^%TriggerName.p^delete gsm_comment":U:
        FIND FIRST lby_gsm_comment EXCLUSIVE-LOCK
             WHERE ROWID(lby_gsm_comment) = ROWID(lbx_gsm_comment)
             NO-ERROR.
        IF AVAILABLE lby_gsm_comment THEN
          DO:
            {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_comment"}
          END.
    END.
/* Generic security allocation deletion */
DEFINE BUFFER lbx_gsm_user_allocation FOR gsm_user_allocation.
DEFINE BUFFER lby_gsm_user_allocation FOR gsm_user_allocation.
IF CAN-FIND(FIRST lbx_gsm_user_allocation 
            WHERE lbx_gsm_user_allocation.owning_obj = %TableName.{&TRIGGER_OBJ}) THEN
    FOR EACH lbx_gsm_user_allocation NO-LOCK
       WHERE lbx_gsm_user_allocation.owning_obj = %TableName.{&TRIGGER_OBJ}
       ON STOP UNDO, RETURN ERROR "AF^104^%TriggerName.p^delete gsm_user_allocation":U:
        FIND FIRST lby_gsm_user_allocation EXCLUSIVE-LOCK
             WHERE ROWID(lby_gsm_user_allocation) = ROWID(lbx_gsm_user_allocation)
             NO-ERROR.
        IF AVAILABLE lby_gsm_user_allocation THEN
          DO:
            {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_user_allocation"}
          END.
    END.
/* Generic multi-media deletion */
DEFINE BUFFER lbx_gsm_multi_media FOR gsm_multi_media.
DEFINE BUFFER lby_gsm_multi_media FOR gsm_multi_media.
IF CAN-FIND(FIRST lbx_gsm_multi_media 
            WHERE lbx_gsm_multi_media.owning_obj = %TableName.{&TRIGGER_OBJ}) THEN
    FOR EACH lbx_gsm_multi_media NO-LOCK
       WHERE lbx_gsm_multi_media.owning_obj = %TableName.{&TRIGGER_OBJ}
       ON STOP UNDO, RETURN ERROR "AF^104^%TriggerName.p^delete gsm_multi_media":U:
        FIND FIRST lby_gsm_multi_media EXCLUSIVE-LOCK
             WHERE ROWID(lby_gsm_multi_media) = ROWID(lbx_gsm_multi_media)
             NO-ERROR.
        IF AVAILABLE lby_gsm_multi_media THEN
          DO:
            {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_multi_media"}
          END.
    END.
}
}

%If(%!==("%EntityProp(TableObj)", "none")) {%If(%==(%Action, CREATE)) {ASSIGN %TableName.{&TRIGGER_OBJ} = getNextObj() NO-ERROR.
IF ERROR-STATUS:ERROR THEN 
DO:
    ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 31 lv-include = "%TableName|the specified object number.  Please ensure your database sequences have been set correctly":U.
    RUN error-message (lv-errgrp, lv-errnum, lv-include).
END.
}}

%If(%!==("%EntityProp(TableObj)", "none")) {%If(%==(%Action, WRITE)) {IF NOT NEW %TableName AND %TableName.{&TRIGGER_OBJ} <> o_%TableName.{&TRIGGER_OBJ} THEN
    DO:
        ASSIGN lv-error = YES lv-errgrp = "AF":U lv-errnum = 13 lv-include = "table object number":U.
        RUN error-message (lv-errgrp,lv-errnum,lv-include).
    END.
}}
%If(%==(%Action, WRITE)) {%If(%==(%EntityProp("CustomWrite"), YES)){/* Customisations to %Action trigger */
{%If(%!=(%DiagramProp("TriggerRel"),%DiagramProp("XYZ"))) {%DiagramProp("TriggerRel")%triggername.i} %ELSE {%triggername.i}}}}
%If(%==(%Action, DELETE)) {%If(%==(%EntityProp("CustomDelete"), YES)){/* Customisations to %Action trigger */
{%If(%!=(%DiagramProp("TriggerRel"),%DiagramProp("XYZ"))) {%DiagramProp("TriggerRel")%triggername.i} %ELSE {%triggername.i}}}}
%If(%==(%Action, CREATE)) {%If(%==(%EntityProp("CustomCreate"), YES)){/* Customisations to %Action trigger */
{%If(%!=(%DiagramProp("TriggerRel"),%DiagramProp("XYZ"))) {%DiagramProp("TriggerRel")%triggername.i} %ELSE {%triggername.i}}}}

%If(%!==("%EntityProp(TableObj)", "none")) {
/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = '%EntityProp("TableFLA")':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "%Action":U, INPUT "%EntityProp("TableFLA")":U, INPUT BUFFER %TableName:HANDLE, INPUT BUFFER o_%TableName:HANDLE).}

/* Standard bottom of %Action trigger code */
%If(%==(%Action, CREATE)) {{af/sup/aftrigendc.i}}%If(%==(%Action, DELETE)) {{af/sup/aftrigendd.i}}%If(%==(%Action, WRITE)) {{af/sup/aftrigendw.i}}
