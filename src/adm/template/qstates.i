/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* qstates.i - query-specific ADM states  */

    WHEN 'update':U THEN RUN new-state ('update':U). 

    WHEN 'update-complete':U THEN DO:
        /* If this state message came from a query object (Query or Browser 
           with its own query) then we do *not* want to do row-changed, 
           because the row that was just updated was in our 
           Record-Target's query, not ours. */
        RUN get-attribute IN p-issuer-hdl ('QUERY-OBJECT':U).
        IF RETURN-VALUE NE "YES":U THEN
            RUN dispatch ('row-changed':U). 

        RUN new-state ('update-complete':U).
    END.

    WHEN 'delete-complete':U THEN RUN dispatch('get-next':U).

    /* Store these states persistently so they can be queried later
       by the Navigation Panel or other objects. */
    WHEN   'first-record':U        OR
      WHEN 'last-record':U         OR
      WHEN 'only-record':U         OR
      WHEN 'not-first-or-last':U   OR
      WHEN 'no-record-available':U OR
      WHEN 'no-external-record-available':U THEN 
        RUN set-attribute-list('Query-Position=':U + p-state).
    
