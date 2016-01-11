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
/* get rid of RVDB workspace check out items that are duff - left over due to
   an error.
   Basically, if the object is checked out in RVDB, but exists in RTB and is not
   checked out - we have a problem.
   In this case, zap the workspace checkout record, set the task-version_number
   to 0, and delete the item version record for the task version number.

*/

MESSAGE "Delete duff checkout records left over due to an error, plus" SKIP
        "tidy up associated tables" SKIP
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE lChoice AS LOGICAL.
IF NOT lChoice THEN RETURN.

DEFINE VARIABLE cRTBObject AS CHARACTER NO-UNDO.

FOR EACH rvt_workspace_checkout EXCLUSIVE-LOCK,
   FIRST rvm_workspace_item EXCLUSIVE-LOCK
   WHERE rvm_workspace_item.workspace_item_obj = rvt_workspace_checkout.workspace_item_obj,
   FIRST rvm_workspace NO-LOCK
   WHERE rvm_workspace.workspace_obj = rvm_workspace_item.workspace_obj,
   FIRST rvt_item_version EXCLUSIVE-LOCK
   WHERE rvt_item_version.configuration_type = rvm_workspace_item.configuration_type
     AND rvt_item_version.scm_object_name = rvm_workspace_item.scm_object_name
     AND rvt_item_version.product_module_obj = rvm_workspace_item.product_module_obj
     AND rvt_item_version.ITEM_version_number = rvm_workspace_item.task_version_number:

  /* get RTB object and see if checked out */
  ASSIGN
    cRTBObject = rvm_workspace_item.scm_object_name.
  IF NUM-ENTRIES(cRTBObject,".":U) > 1
  AND LENGTH(ENTRY(NUM-ENTRIES(cRTBObject,".":U),cRTBObject,".":U)) <= 3
  THEN ASSIGN cRTBObject = cRTBObject.
  ELSE ASSIGN cRTBObject = cRTBObject + ".ado":U.

  FIND FIRST rtb_object NO-LOCK
       WHERE rtb_object.OBJECT = cRTBObject
         AND rtb_object.wspace-id = rvm_workspace.workspace_code
         AND rtb_object.obj-type = "pcode":U
       NO-ERROR. 

  IF AVAILABLE rtb_object THEN
    FIND FIRST rtb_ver NO-LOCK
         WHERE rtb_ver.obj-type = rtb_object.obj-type
           AND rtb_ver.OBJECT = rtb_object.OBJECT
           AND rtb_ver.pmod = rtb_object.pmod
           AND rtb_ver.version = rvt_item_version.ITEM_version_number
         NO-ERROR.

  IF (AVAILABLE rtb_ver AND rtb_ver.obj-status <> "w":U) OR 
     (AVAILABLE rtb_object AND NOT AVAILABLE rtb_ver) THEN
  DO:
    DISPLAY 
      rvm_workspace.workspace_code
      rvt_item_version.task_number
      cRTBObject FORMAT "x(20)"
      rvm_workspace_item.scm_object_name
      rvm_workspace_item.task_version_number
      IF AVAILABLE rtb_ver THEN rtb_ver.obj-status ELSE "nostatus":U
      WITH WIDTH 200
      .

    /* update the records */
    DELETE rvt_workspace_checkout.
    ASSIGN
      rvm_workspace_item.task_product_module_obj = 0
      rvm_workspace_item.task_version_number = 0
      .
    DELETE rvt_item_version.
  
  END.

END.

MESSAGE "Completed tidy up of duff checkout records"
  VIEW-AS ALERT-BOX INFORMATION.

