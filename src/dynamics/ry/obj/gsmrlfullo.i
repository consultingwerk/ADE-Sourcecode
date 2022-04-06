  FIELD release_obj LIKE gsm_release.release_obj~
  FIELD release_number LIKE gsm_release.release_number~
  FIELD release_summary LIKE gsm_release.release_summary~
  FIELD release_notes LIKE gsm_release.release_notes~
  FIELD release_date LIKE gsm_release.release_date~
  FIELD release_time LIKE gsm_release.release_time~
  FIELD ReleaseTime AS CHARACTER FORMAT "x(8)" LABEL "Release time"~
  FIELD release_user LIKE gsm_release.release_user
