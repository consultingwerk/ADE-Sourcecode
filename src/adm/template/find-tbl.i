/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
      /* find-tbl.i - */
       DO:
         IF row-avail-enabled AND            /* fields are enabled */ 
            (adm-initial-lock = "SHARE-LOCK":U OR  
             adm-initial-lock = "EXCLUSIVE-LOCK":U) THEN /* +++ new for EXCL*/
         DO:
           IF adm-initial-lock = "SHARE-LOCK":U        
           THEN FIND {&TABLE} {&WHERE} SHARE-LOCK NO-ERROR.
           ELSE DO TRANSACTION:
             /* For EXCLUSIVE-LOCK we get the lock momentarily to assure
                that no-one else can deadlock with us. Then the lock is
                downgraded to share-lock until the record is saved. */  
             FIND {&TABLE} {&WHERE} EXCLUSIVE-LOCK NO-ERROR.               
           END. /* DO TRANSACTION... */
         END. /* IF...enabled... */
         ELSE FIND {&TABLE} {&WHERE}  NO-LOCK NO-ERROR.
         IF ERROR-STATUS:ERROR THEN DO:
           RUN dispatch ('show-errors':U).
           RETURN "ADM-ERROR":U.
         END. /* IF...ERROR... */
       END. /* end of find-tbl.i */
