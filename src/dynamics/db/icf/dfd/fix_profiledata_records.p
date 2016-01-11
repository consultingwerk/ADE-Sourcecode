/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* fix_profiledata_records.p

   Ensures that object values stored in the profile_data_value field use '.'
   as decimal separator.
 */                 
DEFINE VARIABLE cDecimalSeparator AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUserObj          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCompanyObj       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewValue         AS CHARACTER  NO-UNDO.

DISABLE TRIGGERS FOR LOAD OF gsm_profile_data.

PUBLISH "DCU_SetStatus":U ("Fixing Delimiters in Profile Data Records").
FOR EACH gsm_profile_data EXCLUSIVE-LOCK
  WHERE (gsm_profile_data.profile_data_key BEGINS "SecAlloc|" 
         OR gsm_profile_data.profile_data_key BEGINS "SecEnq|")
    AND NUM-ENTRIES(gsm_profile_data.profile_data_value, CHR(4)) = 5:

  ASSIGN cUserObj    = ENTRY(3, gsm_profile_data.profile_data_value, CHR(4))
         cCompanyObj = ENTRY(4, gsm_profile_data.profile_data_value, CHR(4)).

  cDecimalSeparator = TRIM(cUserObj, "0123456789":U).
  IF LENGTH(cDecimalSeparator) = 0 THEN
      cDecimalSeparator = TRIM(cCompanyObj, "0123456789":U).
  IF cDecimalSeparator = ".":U OR LENGTH(cDecimalSeparator) = 0 THEN NEXT.

  IF LENGTH(cDecimalSeparator) = 1 THEN
  DO:
     ASSIGN cUserObj    = REPLACE(cUserObj, cDecimalSeparator, '.':U).
            cCompanyObj = REPLACE(cCompanyObj, cDecimalSeparator, '.':U).

     cNewValue   = gsm_profile_data.profile_data_value.
     ENTRY(3, cNewValue, CHR(4)) = cUserObj.
     ENTRY(4, cNewValue, CHR(4)) = cCompanyObj.

     PUBLISH "DCU_WriteLog":U ("Changing Profile Data Record " + STRING(gsm_profile_data.profile_data_obj) 
                              + " profile data value " + gsm_profile_data.profile_data_value + " to " 
                              + cNewValue ).
     ASSIGN
       gsm_profile_data.profile_data_value = cNewValue.
       .
  END.
  ELSE 
  DO:
    PUBLISH "DCU_SetStatus":U ("Error found while checking Profile Data Records ... Check log file").
    PUBLISH "DCU_WriteLog":U ("Error found while fixing profile data record "
            + STRING(gsm_profile_data.profile_data_obj)
            + " profile data value " + gsm_profile_data.profile_data_value + " does not have a decimal value" ).
  END.

END.
RETURN.

