/* Purpose: To ensure that ryc_page.page_reference field is correctly in synch
            between main and customized containers where a page on the main
            container has been customized. Customization used to rely on the
            ryc_page.page_sequence field to act as a link between the two
            containers, but the ryc_page.page_reference field has been introduced
            for that purpose to allow both containers to have control over their
            own page sequence */
DEFINE BUFFER ryc_customization_result FOR ryc_customization_result.
DEFINE BUFFER ryc_cust_smartobject     FOR ryc_smartobject.
DEFINE BUFFER ryc_smartobject          FOR ryc_smartobject.
DEFINE BUFFER ryc_cust_page            FOR ryc_page.
DEFINE BUFFER ryc_page                 FOR ryc_page.

ERROR-STATUS:ERROR = FALSE.

PUBLISH "DCU_WriteLog":U ("--- Starting synchronization of customized pages' references":U).

FOR EACH ryc_smartobject NO-LOCK
   WHERE ryc_smartobject.customization_result_obj = 0.00,
    EACH ryc_cust_smartobject NO-LOCK
   WHERE ryc_cust_smartobject.object_filename           = ryc_smartobject.object_filename
     AND ryc_cust_smartobject.customization_result_obj <> 0.00,
   FIRST ryc_customization_result NO-LOCK
   WHERE ryc_customization_result.customization_result_obj = ryc_cust_smartobject.customization_result_obj,
    EACH ryc_cust_page EXCLUSIVE-LOCK
   WHERE ryc_cust_page.container_smartobject_obj = ryc_cust_smartobject.smartobject_obj,
   FIRST ryc_page NO-LOCK
   WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj
     AND ryc_page.page_sequence             = ryc_cust_page.page_sequence:

  ryc_cust_page.page_reference = ryc_page.page_reference NO-ERROR.

  IF NOT ERROR-STATUS:ERROR THEN
    VALIDATE ryc_cust_page NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
  DO:
    PUBLISH "DCU_WriteLog":U ("Could not synchronize customized page's reference.":U
                              + " Container: ":U     + ryc_smartobject.object_filename
                              + " Customization: ":U + ryc_customization_result.customization_result_code
                              + " Page Sequence: ":U + STRING(ryc_cust_page.page_sequence)).

    ERROR-STATUS:ERROR = FALSE.
  END.
END.

PUBLISH "DCU_WriteLog":U ("--- Synchronization of customized pages' references complete.":U).

