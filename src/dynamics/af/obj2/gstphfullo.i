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
  FIELD password_history_obj LIKE gst_password_history.password_history_obj VALIDATE ~
  FIELD user_obj LIKE gst_password_history.user_obj VALIDATE ~
  FIELD user_login_name LIKE gsm_user.user_login_name VALIDATE ~
  FIELD old_password LIKE gst_password_history.old_password VALIDATE ~
  FIELD password_change_date LIKE gst_password_history.password_change_date VALIDATE ~
  FIELD password_change_time LIKE gst_password_history.password_change_time VALIDATE ~
  FIELD fmt_password_change_time AS CHARACTER FORMAT "x(8)" LABEL "Changed Time"~
  FIELD changed_by_user_obj LIKE gst_password_history.changed_by_user_obj VALIDATE ~
  FIELD c_changed_by_user AS CHARACTER FORMAT "x(15)" LABEL "Changed By"
