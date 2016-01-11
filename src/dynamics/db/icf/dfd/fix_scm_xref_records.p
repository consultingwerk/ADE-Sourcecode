/* fix_scm_xref_records.p

   Ensures that object values stored in owning_reference field use '.'
   as decimal separator.
 */                 
DEFINE VARIABLE cDecimalSeparator AS CHARACTER  NO-UNDO.

DISABLE TRIGGERS FOR LOAD OF gsm_scm_xref.

PUBLISH "DCU_SetStatus":U ("Fixing Delimiters in SCM Xref Records").
FOR EACH gsm_scm_xref EXCLUSIVE-LOCK
  WHERE gsm_scm_xref.owning_reference <> ""
    AND gsm_scm_xref.owning_reference <> ?:

  cDecimalSeparator = TRIM(gsm_scm_xref.owning_reference, "0123456789":U).
  IF cDecimalSeparator = ".":U OR LENGTH(cDecimalSeparator) = 0 THEN NEXT.

  IF LENGTH(cDecimalSeparator) = 1 AND cDecimalSeparator <> CHR(3) THEN
  DO:
    PUBLISH "DCU_WriteLog":U ("Changing SCM Xref Record " + STRING(gsm_scm_xref.scm_xref_obj) 
                              + " owning_reference " + gsm_scm_xref.owning_reference + " to " 
                              + REPLACE(gsm_scm_xref.owning_reference, cDecimalSeparator, ".":U) ).
    ASSIGN
      gsm_scm_xref.owning_reference = REPLACE(gsm_scm_xref.owning_reference, cDecimalSeparator, ".":U).
      .
  END.
  ELSE 
  DO:
    PUBLISH "DCU_SetStatus":U ("Error found while checking SCM Xref Records ... Check log file").
    PUBLISH "DCU_WriteLog":U ("Error found while fixing scm xref record " + STRING(gsm_scm_xref.scm_xref_obj) + " owning_reference " + gsm_scm_xref.owning_reference + " does not have a decimal value" ).
  END.

END.
RETURN.

