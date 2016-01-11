/* Fix values of page reference fields to ensure they have a unique value after 
   delta 11 and bafore delta 12
   Anthony D Swindells 3rd July 2002
*/
DISABLE TRIGGERS FOR LOAD OF ryc_page.
FOR EACH ryc_page EXCLUSIVE-LOCK
   WHERE ryc_page.PAGE_reference = "":U OR ryc_page.PAGE_reference = ?:

  ASSIGN ryc_page.PAGE_reference = ryc_page.PAGE_label + STRING(ryc_page.PAGE_sequence,"99":U).

END.
