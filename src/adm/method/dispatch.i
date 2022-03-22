/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* dispatch.i - inline broker code for the dispatch method.
   Arguments are the object's procedure handle and the base event name. */

  DO:
    IF ({src/adm/method/get-attr.i {1} INITIALIZED} EQ "YES":U) OR
       (LOOKUP ({2}, adm-pre-initialize-events) NE 0 ) THEN
    DO:
      adm-dispatch-proc =
         IF CAN-DO({1}:INTERNAL-ENTRIES, "local-":U + {2}) THEN
         "local-":U + {2} 
         ELSE IF CAN-DO({1}:INTERNAL-ENTRIES,
          {src/adm/method/get-attr.i {1} adm-dispatch-qualifier}
             + '-':U + {2}) THEN 
          {src/adm/method/get-attr.i {1} adm-dispatch-qualifier}
             + '-':U + {2} 
         ELSE IF CAN-DO({1}:INTERNAL-ENTRIES, "adm-":U + {2}) THEN
             "adm-":U + {2}
         ELSE {2}.
      RUN VALUE(adm-dispatch-proc) IN {1} NO-ERROR.

      /* Log the method name etc. if monitoring */
      IF VALID-HANDLE(adm-watchdog-hdl) THEN
      DO:
        RUN receive-message IN adm-watchdog-hdl 
         (INPUT {1}, INPUT "":U,
              INPUT adm-dispatch-proc) NO-ERROR.  
      END.
    END.
  END.
