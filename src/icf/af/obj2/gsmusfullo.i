  FIELD user_obj LIKE gsm_user.user_obj VALIDATE ~
  FIELD confirm_password AS CHARACTER FORMAT "x(35)" LABEL "Confirm Password"~
  FIELD c_profile_user AS CHARACTER FORMAT "x(15)" LABEL "Based on Profile"~
  FIELD fmt_user_create_time AS CHARACTER FORMAT "x(8)" LABEL "User Creation Time"~
  FIELD fmt_user_login_time AS CHARACTER FORMAT "x(8)" LABEL "Last Login Time"~
  FIELD fmt_password_fail_time AS CHARACTER FORMAT "x(8)" LABEL "Password Fail Time"~
  FIELD fmt_password_create_time AS CHARACTER FORMAT "x(8)" LABEL "Password Creation Time"~
  FIELD fmt_password_expire_time AS CHARACTER FORMAT "x(8)" LABEL "Password Expiry Time"~
  FIELD user_category_obj LIKE gsm_user.user_category_obj VALIDATE ~
  FIELD user_category_code LIKE gsm_user_category.user_category_code VALIDATE ~
  FIELD user_full_name LIKE gsm_user.user_full_name~
  FIELD user_login_name LIKE gsm_user.user_login_name~
  FIELD user_creation_date LIKE gsm_user.user_creation_date~
  FIELD user_creation_time LIKE gsm_user.user_creation_time~
  FIELD profile_user LIKE gsm_user.profile_user~
  FIELD created_from_profile_user_obj LIKE gsm_user.created_from_profile_user_obj VALIDATE ~
  FIELD external_userid LIKE gsm_user.external_userid~
  FIELD user_password LIKE gsm_user.user_password~
  FIELD password_minimum_length LIKE gsm_user.password_minimum_length~
  FIELD password_preexpired LIKE gsm_user.password_preexpired~
  FIELD password_fail_count LIKE gsm_user.password_fail_count~
  FIELD password_fail_date LIKE gsm_user.password_fail_date~
  FIELD password_fail_time LIKE gsm_user.password_fail_time~
  FIELD password_creation_date LIKE gsm_user.password_creation_date~
  FIELD password_creation_time LIKE gsm_user.password_creation_time~
  FIELD password_expiry_date LIKE gsm_user.password_expiry_date~
  FIELD password_expiry_time LIKE gsm_user.password_expiry_time~
  FIELD update_password_history LIKE gsm_user.update_password_history~
  FIELD check_password_history LIKE gsm_user.check_password_history~
  FIELD last_login_date LIKE gsm_user.last_login_date~
  FIELD last_login_time LIKE gsm_user.last_login_time~
  FIELD language_obj LIKE gsm_user.language_obj VALIDATE ~
  FIELD language_code LIKE gsc_language.language_code VALIDATE ~
  FIELD disabled LIKE gsm_user.disabled~
  FIELD password_expiry_days LIKE gsm_user.password_expiry_days~
  FIELD maintain_system_data LIKE gsm_user.maintain_system_data~
  FIELD default_login_company_obj LIKE gsm_user.default_login_company_obj VALIDATE ~
  FIELD user_email_address LIKE gsm_user.user_email_address~
  FIELD development_user LIKE gsm_user.development_user~
  FIELD oldPasswordExpiryDate AS DATE FORMAT "99/99/9999"
