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
