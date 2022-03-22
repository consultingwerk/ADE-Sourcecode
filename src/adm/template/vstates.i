/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* vstates.i - viewer-specific ADM states */

    WHEN 'update-begin':U THEN DO:   /* Somebody pressed the Update button */
        RUN dispatch('enable-fields':U).
        IF RETURN-VALUE = "ADM-ERROR":U THEN
        DO:
          /* 'update-failed' is a special signal to a transaction panel
             that the begin never happened properly, so don't start a txn. */
          RUN new-state('update-failed,TABLEIO-SOURCE':U).
          RUN new-state('update-complete':U). 
        END.
        ELSE RUN new-state ('update':U).  /* Tell others (query, nav panel... */
    END.
    WHEN 'update-complete':U THEN DO:
        RUN new-state ('update-complete':U).  /* Tell others... */
    END.
    

