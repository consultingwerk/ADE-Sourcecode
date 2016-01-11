&GLOBAL-DEFINE FRAME-NAME cascRevoke
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

  File: prodict/sec/_cascrvk.p

  Description: Dialog for selecting permissions, for revocation,
               as a result of revoking the permissions of the user
               who granted them.

  Input Parameters:
      INPUT pcGrantor   -   UserId of the parent user who's permission 
                            is being revoked.

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: May 16, 2005

  History: 
    kmcintos May 25, 2005  Ensured that child record is not the same as the 
                           current record, in getRevokeList 20050524-014.
    kmcintos May 27, 2005  Removed SIZE phrase from dialog 20050526-024.
    kmcintos May 27, 2005  Using guid to remove first record from revoke list 
                           20050526-026.
    kmcintos June 7, 2005  Added context sensitive help to dialog.
    kmcintos Aud 18, 2005  Removed check for "IF Granter" 20050620-003.
           
------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcGrantor    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcPermission AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcGuid       AS CHARACTER   NO-UNDO.

DEFINE VARIABLE lRvkAll      AS LOGICAL     NO-UNDO INITIAL TRUE.
DEFINE VARIABLE lRvkNone     AS LOGICAL     NO-UNDO INITIAL FALSE.
DEFINE VARIABLE lRvkSel      AS LOGICAL     NO-UNDO INITIAL FALSE.

DEFINE VARIABLE cWarningLine AS CHARACTER   NO-UNDO EXTENT 5.
DEFINE VARIABLE gcSort       AS CHARACTER   NO-UNDO 
                                INITIAL "selGrantor".

DEFINE VARIABLE giRevoke     AS INTEGER     NO-UNDO.

{prodict/sec/sec-func.i}
{prodict/admnhlp.i}

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE ttRevoke NO-UNDO
    FIELD selGrantee   AS CHARACTER FORMAT "x(12)" LABEL "UserID"
    FIELD selGrantor   AS CHARACTER FORMAT "x(12)" LABEL "Granted by"
    FIELD selIntPerm   AS CHARACTER
    FIELD selPerm      AS CHARACTER FORMAT "x(50)" LABEL "Permission"
    FIELD selGuid      AS CHARACTER
    FIELD selForRevoke AS LOGICAL   FORMAT "Revoke/Retain" 
                                    LABEL "Revoke/Retain "
                                    INITIAL TRUE
    INDEX selGuid   AS PRIMARY UNIQUE selGuid.

DEFINE BUFFER bfRevoke FOR ttRevoke.

DEFINE QUERY qRevoke FOR ttRevoke SCROLLING.

DEFINE BROWSE bRevoke QUERY qRevoke
    DISPLAY selForRevoke
            selGrantee
            selPerm 
            selGrantor
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      ENABLE selForRevoke &ENDIF
    WITH &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 7 &ELSE NO-BOX 3 &ENDIF DOWN 
         WIDTH 77 NO-ROW-MARKERS NO-SEPARATORS
         MULTIPLE.

DEFINE BUTTON btnRvkAll  LABEL "Revoke &All"      SIZE 18 BY .93.
DEFINE BUTTON btnRvkNone LABEL "Revoke &None"     SIZE 18 BY .93.
DEFINE BUTTON btnRvkSel  LABEL "Re&voke Selected" SIZE 18 BY .93.
DEFINE BUTTON btnRtnSel  LABEL "Re&tain Selected" SIZE 18 BY .93.

DEFINE BUTTON btnDone    LABEL "Done" AUTO-GO SIZE 11 BY .93.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  DEFINE BUTTON btnHelp LABEL "&Help"         SIZE 11 BY .93.
&ENDIF

RUN getRevokeList ( INPUT pcGrantor,
                    INPUT pcPermission,
                    INPUT pcGuid ).

FORM cWarningLine[1]  VIEW-AS TEXT FORMAT "x(75)" 
                      &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
                        AT ROW 1.5 COL 2 &ELSE AT 2 &ENDIF SKIP
     cWarningLine[2]  VIEW-AS TEXT FORMAT "x(75)" AT 2 
                      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP(1) &ENDIF
     cWarningLine[3]  VIEW-AS TEXT FORMAT "x(75)" 
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
       AT ROW 3 COL 2 &ELSE AT 2 &ENDIF SKIP
     cWarningLine[4]  VIEW-AS TEXT FORMAT "x(75)" AT 2 
                      &IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN SKIP(1) 
                        &ELSE SKIP &ENDIF
     bRevoke    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
                  AT ROW 4.5  COL 2 &ELSE AT 2 &ENDIF SKIP(1)
     btnRvkAll  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                  AT ROW 12 COL 2 &ELSE AT 2 &ENDIF 
     btnRvkNone AT 21
     btnRvkSel  AT 40 
     btnRtnSel  AT 59 SKIP(1)
     btnDone    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                  AT ROW 13.5 COL 34 &ELSE AT 34 &ENDIF
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
       btnHelp AT ROW 13.5 COL 66 &ENDIF
  WITH FRAME cascRevoke CENTERED DEFAULT-BUTTON btnDone
       TITLE "Cascade Revoke Permissions" NO-LABELS USE-TEXT
       &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
         VIEW-AS DIALOG-BOX THREE-D
       &ENDIF.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
  ON START-SEARCH OF bRevoke DO:
    DEFINE VARIABLE cCol AS CHARACTER NO-UNDO.
    
    cCol = SELF:CURRENT-COLUMN:NAME.
    IF gcSort EQ cCol THEN gcSort = cCol + " DESC".
    ELSE gcSort = cCol.
    RUN openQuery.
    
    APPLY "END-SEARCH" TO SELF.
  END.

  ON HELP   OF FRAME {&FRAME-NAME} OR
     CHOOSE OF btnHelp IN FRAME {&FRAME-NAME}
    RUN adecomm/_adehelp.p ( INPUT "admn", 
                             INPUT "CONTEXT", 
                             INPUT {&Cascade_Revoke_Permissions_Dialog_Box},
                             INPUT ? ).
&ENDIF

ON CHOOSE OF btnRvkAll IN FRAME {&FRAME-NAME} DO:
  BROWSE bRevoke:DESELECT-ROWS() NO-ERROR.
  
  ASSIGN SELF:SENSITIVE       = FALSE
         lRvkAll              = TRUE
         lRvkNone             = FALSE
         btnRvkNone:SENSITIVE = TRUE.

  FOR EACH ttRevoke TRANSACTION:
    selForRevoke = TRUE.
  END.
  RUN openQuery.
END.

ON CHOOSE OF btnRvkNone IN FRAME {&FRAME-NAME} DO:
  BROWSE bRevoke:DESELECT-ROWS() NO-ERROR.

  ASSIGN SELF:SENSITIVE      = FALSE
         lRvkNone            = TRUE
         lRvkAll             = FALSE
         btnRvkAll:SENSITIVE = TRUE.

  FOR EACH ttRevoke TRANSACTION:
    selForRevoke = FALSE.
  END.
  RUN openQuery.
END.

ON CHOOSE OF btnRvkSel IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE iSelect AS INTEGER     NO-UNDO.
  
  DO iSelect = 1 TO bRevoke:NUM-SELECTED-ROWS 
      TRANSACTION:
    bRevoke:FETCH-SELECTED-ROW(iSelect).
    IF NOT AVAILABLE ttrevoke THEN NEXT.
    selForRevoke = TRUE.
    bRevoke:REFRESH().
  END.
  
END.

ON CHOOSE OF btnRtnSel IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE iSelect AS INTEGER     NO-UNDO.
  
  DO iSelect = 1 TO bRevoke:NUM-SELECTED-ROWS:
    bRevoke:FETCH-SELECTED-ROW(iSelect).
    IF NOT AVAILABLE ttrevoke THEN NEXT.
    selForRevoke = FALSE.
    bRevoke:REFRESH().
  END.
  
END.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME}
  RETURN NO-APPLY.

ON DEFAULT-ACTION OF BROWSE bRevoke DO:
  IF NOT AVAILABLE ttRevoke THEN
    RETURN NO-APPLY.

  DO TRANSACTION:
    selForRevoke = (NOT selForRevoke).
  END.
  giRevoke = giRevoke + (IF selForRevoke THEN 1 ELSE -1).
  SELF:REFRESH().
END.

ON GO OF FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE hSGRole AS HANDLE      NO-UNDO.

  CREATE BUFFER hSGRole FOR TABLE "DICTDB._sec-granted-role".

  DO TRANSACTION:
    FOR EACH ttRevoke WHERE selForRevoke EQ TRUE:
      hSGRole:FIND-FIRST("WHERE _granted-role-guid = ~'" + 
                         ttRevoke.selGuid + "~'").
      hSGRole:BUFFER-DELETE().
    END.
  END.

  DELETE OBJECT hSGRole.
END.

ON END-ERROR OF FRAME {&FRAME-NAME}
  RETURN NO-APPLY.

/*-------------------Main-Line Code-------------------------------------*/
FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + 
                            " Granted by " + pcGrantor.
ASSIGN cWarningLine[1] = "When a permission is revoked, the assumption is " +
                         "that all permissions that"
       cWarningLine[2] = "were granted as a result of that permission should" +
                         " also be revoked."
       cWarningLine[3] = "Please carefully review the permissions listed " +
                         "below and Retain or Revoke"
       cWarningLine[4] = "permissions as necessary".

DISPLAY cWarningLine[1] 
        cWarningLine[2]
        cWarningLine[3]
        cWarningLine[4]
    WITH FRAME cascRevoke.

ENABLE ALL WITH FRAME {&FRAME-NAME}.
btnRvkAll:SENSITIVE IN FRAME cascRevoke = FALSE.
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
  selForRevoke:READ-ONLY IN BROWSE bRevoke = TRUE.
&ENDIF

RUN openQuery.
BROWSE bRevoke:SELECT-ALL().

WAIT-FOR GO OF FRAME cascRevoke.

PROCEDURE getRevokeList:
  DEFINE INPUT  PARAMETER pcGrantor    AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcPermission AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcGuid       AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hPermission AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE      NO-UNDO.
  
  DEFINE VARIABLE lChild      AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lAdminRight AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE cPermission AS CHARACTER   NO-UNDO.

  IF pcPermission EQ "" OR pcPermission EQ ? THEN RETURN.

  IF pcPermission NE "_sys.audit.admin" THEN
    cPermission = " AND _role-name = ~'" + pcPermission + "~'".
  ELSE lAdminRight = TRUE.

  CREATE WIDGET-POOL.

  CREATE BUFFER hPermission FOR TABLE "DICTDB._sec-granted-role".

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hPermission).
  hQuery:QUERY-PREPARE("FOR EACH _sec-granted-role WHERE _grantor = ~'" +
                       pcGrantor + "~'  AND _granted-role-guid NE ~'" + 
                       pcGuid + "~'" + cPermission).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE NOT hQuery:QUERY-OFF-END:
    IF hPermission::_grantee = hPermission::_grantor AND
       NOT lAdminRight THEN DO: 
      hQuery:GET-NEXT().
      NEXT.
    END.

    CREATE ttRevoke.
    ASSIGN selGrantee   = hPermission::_grantee
           selGrantor   = hPermission::_grantor
           selIntPerm   = hPermission::_role-name
           selPerm      = getRoleDesc(hPermission::_role-name)
           selGuid      = hPermission::_granted-role-guid
           selForRevoke = TRUE.

    RUN getRevokeList ( INPUT hPermission::_grantee,
                        INPUT hPermission::_role-name,
                        INPUT hPermission::_granted-role-guid ).

    hQuery:GET-NEXT().
  END.
END PROCEDURE.

PROCEDURE openQuery:
  giRevoke = 0.
  FOR EACH bfRevoke WHERE bfRevoke.selForRevoke = TRUE NO-LOCK:
    giRevoke = giRevoke + 1.
  END.

  QUERY qRevoke:QUERY-PREPARE("FOR EACH ttRevoke BY " + gcSort).
  QUERY qRevoke:QUERY-OPEN().
  
END PROCEDURE.
