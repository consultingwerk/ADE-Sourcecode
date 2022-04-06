  FIELD password_history_obj LIKE gst_password_history.password_history_obj VALIDATE ~
  FIELD user_obj LIKE gst_password_history.user_obj VALIDATE ~
  FIELD user_login_name LIKE gsm_user.user_login_name VALIDATE ~
  FIELD old_password LIKE gst_password_history.old_password VALIDATE ~
  FIELD password_change_date LIKE gst_password_history.password_change_date VALIDATE ~
  FIELD password_change_time LIKE gst_password_history.password_change_time VALIDATE ~
  FIELD fmt_password_change_time AS CHARACTER FORMAT "x(8)" LABEL "Changed Time"~
  FIELD changed_by_user_obj LIKE gst_password_history.changed_by_user_obj VALIDATE ~
  FIELD c_changed_by_user AS CHARACTER FORMAT "x(15)" LABEL "Changed By"
