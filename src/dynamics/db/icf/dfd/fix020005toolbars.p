/**************************************************** **************
 *  File    : fix020005toolbars 
 *  Purpose : Fixes Issue 2853, which prevented converted toolbars
 *            from being modified. It resulted in a message
 *            'Security Object obj cannot be zero'
********************************************************************/              
SESSION:SET-WAIT-STATE("general").
FOR EACH gsc_object_type NO-LOCK
      WHERE gsc_object_type.OBJECT_type_code = "SmartToolbar":U,
    EACH gsc_object EXCLUSIVE-LOCK
      WHERE gsc_object_type.object_type_obj = gsc_object.object_type_obj
        AND gsc_object.security_object_obj = 0: 
  IF NOT LOCKED gsc_object THEN
    ASSIGN gsc_object.security_object_obj = gsc_object.object_obj.
END.
SESSION:SET-WAIT-STATE("").

MESSAGE "Toolbar Fix 020005 complete"
  VIEW-AS ALERT-BOX INFO BUTTONS OK.
