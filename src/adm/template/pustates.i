/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* pustates.i - update panel-specific ADM states -- with regression bug fix */

    /* If a link has been activated or deactivated, then:
           If there's no active Tableio-Target, disable the panel;
           Else if we're in 'Save' mode, enable the target's fields
           as we did for the objects active at initialization. */

    WHEN "link-changed":U THEN 
    DO:
        DEFINE VARIABLE t-t-link AS CHARACTER NO-UNDO INIT "":U.
        DEFINE VARIABLE query-position AS CHARACTER NO-UNDO.
        RUN get-link-handle IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, 'TABLEIO-TARGET':U, OUTPUT t-t-link)
                NO-ERROR.
        IF t-t-link NE "":U THEN     /* There is an active TableIO link */
        DO:
          /* Find out if there's a record available. */
          RUN request-attribute IN adm-broker-hdl
              (THIS-PROCEDURE, 'TABLEIO-TARGET':U, 'Query-Position':U).
          query-position = RETURN-VALUE.
          IF LOOKUP(query-position, 
              'no-record-available,no-external-record-available':U) = 0 
          THEN DO:                   /* There is a record available. */
            IF panel-type = 'SAVE':U THEN 
            DO:
              /* Re-enable the fields in a target of a Save style panel
                 if there's a record in that target. */
              RUN request-attribute IN adm-broker-hdl
                (THIS-PROCEDURE, 'TABLEIO-TARGET':U, 'FIELDS-ENABLED':U).
              IF RETURN-VALUE NE "YES":U 
                THEN RUN notify('enable-fields, TABLEIO-TARGET':U).
            END.   /* END DO IF Save */
          END.     /* END DO IF record-available */
          ELSE IF query-position = 'no-external-record-available':U THEN
            adm-panel-state = 'disable-all':U. /* No recs can be added. */
          ELSE adm-panel-state = 'add-only':U. /* No recs in the target. */
          RUN set-buttons (adm-panel-state).   /* reset panel state */
        END.       /* END DO IF Tableio-link present */
        ELSE       /* ELSE IF no TableIO link, disable the panel. */
          RUN set-buttons ('disable-all':U).
    END.           /* END DO link-changed */

    WHEN "record-available":U THEN 
    DO:
       adm-panel-state = 'initial':U.
       RUN set-buttons (adm-panel-state).
        IF panel-type = 'SAVE':U THEN
        DO:
            RUN request-attribute IN adm-broker-hdl
              (THIS-PROCEDURE, 'TABLEIO-TARGET':U, 'FIELDS-ENABLED':U).
            IF RETURN-VALUE NE "YES":U THEN
              RUN notify( 'enable-fields, TABLEIO-TARGET':U).
        END.
    END.

    /* no-record-available means the current query is empty; Add is valid.
       no-external-record-available means a needed External Table record
       isn't present; no update actions at all are valid. */
    WHEN "no-record-available":U OR
    WHEN "no-external-record-available":U THEN 
    DO:
        IF p-state = "no-record-available":U THEN
            adm-panel-state = 'add-only':U.
        ELSE adm-panel-state = 'disable-all':U.
        RUN set-buttons (adm-panel-state).
        IF panel-type = 'SAVE':U THEN
           RUN notify ('disable-fields,TABLEIO-TARGET':U).
    END.

    WHEN "update":U THEN 
    DO:
        adm-panel-state = 'action-chosen':U.
        RUN set-buttons (adm-panel-state).
    END.

  &IF "{&ADM-TRANSACTION-PANEL}":U = "yes":U &THEN
    WHEN "update-failed":U THEN
      trans-commit = no.   /* Signal failure to the Panel. */
  &ENDIF
    WHEN "update-complete":U THEN 
    DO:
        RUN get-attribute IN THIS-PROCEDURE ('AddFunction':U).
        IF (RETURN-VALUE <> 'Multiple-Records':U) OR NOT add-active THEN DO:
          RUN request-attribute IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT 'TABLEIO-TARGET':U,
             INPUT 'Query-Position':U).
          CASE RETURN-VALUE:
            WHEN 'no-record-available':U THEN adm-panel-state = 'add-only':U.
            WHEN 'no-external-record-available':U THEN 
                  adm-panel-state = 'disable-all':U.
            OTHERWISE adm-panel-state = 'initial':U.
          END CASE.
          RUN set-buttons (adm-panel-state).  /* reset to prior state */
          IF panel-type = "UPDATE":U OR panel-type = "UPDATE-TRANS":U THEN 
          DO:
            RUN dispatch ('apply-entry':U).  /* Get focus into panel first. */
            RUN notify ('disable-fields,TABLEIO-TARGET':U).
          END.
        END.
    END.
