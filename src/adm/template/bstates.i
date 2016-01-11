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
/* bstates.i - browser-specific ADM states */
    WHEN "update-begin":U THEN
    DO:
        adm-brs-in-update = yes.
        RUN dispatch ('enable-fields':U).
        IF RETURN-VALUE = "ADM-ERROR":U THEN
        DO:
          /* 'update-failed' is a special signal to a transaction panel
             that the begin never happened properly, so don't start a txn. */
          RUN new-state('update-failed,TABLEIO-SOURCE':U).
          RUN new-state('update-complete':U). 
        END.
        ELSE DO:
          RUN dispatch ('apply-entry':U).
          RUN new-state('update':U).
        END.
    END.
    WHEN "update":U THEN 
      DO:
      /* 'Update' means some other object just started an Update.
          Unless it was part of a Group-Assign with this Browser, 
          disable the browser until the update completes to prevent the
          user from changing records in the middle of the update. */
        DEFINE VARIABLE group-link AS CHARACTER NO-UNDO INIT "":U.
        RUN get-link-handle IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, 'GROUP-ASSIGN-TARGET':U, OUTPUT group-link)
                NO-ERROR.
        IF LOOKUP(STRING(p-issuer-hdl), group-link) EQ 0 THEN 
          {&BROWSE-NAME}:SENSITIVE IN FRAME {&FRAME-NAME} = no.
      END.
    WHEN "update-complete":U THEN DO:
        {&BROWSE-NAME}:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
        adm-brs-in-update = no.
    &IF DEFINED(TABLES-IN-QUERY-{&BROWSE-NAME}) <> 0 &THEN
        /* If this state message came from a query object (Query or Browser 
           with its own query) then we do *not* want to do row-changed, 
           because the row that was just updated was in our 
           Record-Target's query, not ours. */
        RUN get-attribute IN p-issuer-hdl ('QUERY-OBJECT':U).
        IF RETURN-VALUE NE "YES":U THEN
        DO:
          IF NUM-RESULTS("{&BROWSE-NAME}":U) NE ? AND  /* query opened */
             NUM-RESULTS("{&BROWSE-NAME}":U) NE 0 /* query's not empty */
          THEN DO:
            GET CURRENT {&BROWSE-NAME}.
            RUN dispatch ('row-changed':U). 
          END.
        END.
    &ENDIF
        RUN new-state ('update-complete':U).  /* Pass on to others */
    END.
    WHEN "delete-complete":U THEN DO:
       DEFINE VARIABLE sts AS LOGICAL NO-UNDO.
       sts = {&BROWSE-NAME}:DELETE-CURRENT-ROW() IN FRAME {&FRAME-NAME}.
       IF NUM-RESULTS("{&BROWSE-NAME}":U) = 0 THEN  /* Last row deleted? */
         RUN notify('row-available':U).  /* Make sure Targets get the message*/
    END.
    /* Store these states persistently so they can be queried later
       by the Navigation Panel or other objects. */
    WHEN   'first-record':U        OR
      WHEN 'last-record':U         OR
      WHEN 'only-record':U         OR
      WHEN 'not-first-or-last':U   OR
      WHEN 'no-record-available':U OR
      WHEN 'no-external-record-available':U THEN 
        RUN set-attribute-list('Query-Position=':U + p-state).
    
