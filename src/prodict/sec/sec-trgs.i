
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

  File: prodict/sec/sec-trgs.i

  Description: Common User Interface Triggers for Security Toolbar buttons.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 4, 2005
  History:
    kmcintos June 7, 2005  Added context sensitive help for security dialogs.
    
------------------------------------------------------------------------*/
{prodict/admnhlp.i}

DEFINE VARIABLE giContextId AS INTEGER     NO-UNDO.

ON CHOOSE OF btnCancel IN FRAME {&frame_name} DO:
  RUN cancelRecord.
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Cancel" ).
END.

ON CHOOSE OF btnCreate IN FRAME {&frame_name} DO:
  RUN newRecord.
  IF RETURN-VALUE = "Retry" THEN
    RETURN NO-APPLY.
  IF RETURN-VALUE = "Fatal" THEN DO:
    RUN cancelRecord.
    RETURN NO-APPLY.
  END.
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Create" ).
END.

ON CHOOSE OF btnDelete IN FRAME {&frame_name} DO:
  RUN deleteRecord.
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Delete" ).
END.

ON CHOOSE OF btnSave   IN FRAME {&frame_name} DO:
  
  RUN saveRecord.
  
  IF RETURN-VALUE = "Retry" THEN
    RETURN NO-APPLY.
  IF RETURN-VALUE = "Fatal" THEN DO:
    RUN cancelRecord.
    RETURN NO-APPLY.
  END.
                  
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Save" ).
  
  APPLY "ENTRY" TO btnDone IN FRAME {&FRAME-NAME}.
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ON CHOOSE OF btnHelp   IN FRAME {&frame_name} OR 
     HELP OF FRAME {&frame_name} DO:
    
    DEFINE VARIABLE cUtility AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSlash   AS CHARACTER   NO-UNDO.

    cSlash = &IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN "~\" &ELSE "~/" &ENDIF.

    cUtility = ENTRY(NUM-ENTRIES(THIS-PROCEDURE:FILE-NAME,cSlash),
                     THIS-PROCEDURE:FILE-NAME,
                     cSlash).

    CASE cUtility:
      WHEN "_sec-perm.p" THEN
        giContextId = {&Edit_Audit_Permissions_Dialog_Box}.
      WHEN "_sec-sys.p" THEN
        giContextId = {&Authentication_Systems_Dialog_Box}.
      WHEN "_sec-dom.p" THEN
        giContextId = {&Authentication_System_Domains_Dialog_Box}.
      OTHERWISE
        giContextId = 0.
    END CASE.

    IF giContextId > 0 THEN
      RUN adecomm/_adehelp.p ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT giContextId,
                               INPUT ? ).
    ELSE
      MESSAGE "Help for File: {&FILE-NAME}" 
          VIEW-AS ALERT-BOX INFORMATION.
  END.
&ENDIF
  
ON CHOOSE OF btnDone   IN FRAME {&frame_name} DO:
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Done" ).
    
  APPLY "WINDOW-CLOSE" TO FRAME {&frame_name}.
END.
