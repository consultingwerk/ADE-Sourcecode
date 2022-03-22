/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* row-find.i  */
&IF "{1}" eq "{&FIRST-EXTERNAL-TABLE}" &THEN
  IF key-name ne ?         /* Don't find first external table */
                           /* by rowid, if a key-field exists */
  THEN DO:
    RUN dispatch ('find-using-key':U). 
    IF RETURN-VALUE eq "ADM-ERROR":U THEN RETURN RETURN-VALUE.
  END.
  ELSE
&ENDIF  
  DO:
    row-avail-cntr = row-avail-cntr + 1.
    row-avail-rowid = TO-ROWID(ENTRY(row-avail-cntr,rowid-list)).
    IF row-avail-rowid NE ROWID({1}) THEN different-row = yes.
    IF row-avail-rowid ne ? THEN DO:
      /* Change record-available state only for enabled tables, 
         because it affects the state of Update panel buttons. */
      &IF "{1}" = "{&FIRST-ENABLED-TABLE}" &THEN
        /* Don't bother with this for query objects because they manage
           the states in adm-open-query. */
        &IF DEFINED(adm-open-query) = 0 &THEN
          IF adm-row-avail-state NE yes THEN DO: 
             /* If we switched states and this is the primary or only table
                then signal this. */
             RUN new-state ('record-available':U). 
             RUN set-attribute-list ('Query-Position = record-available':U).
             adm-row-avail-state = yes.
          END.
        &ENDIF
      &ENDIF
      {src/adm/template/find-tbl.i 
          &TABLE = {1}
          &WHERE = "WHERE ROWID({1}) = row-avail-rowid"
      }     
    END. /* IF row-avail-rowid ne ? ... */
    ELSE DO:
         IF AVAILABLE {1} THEN RELEASE {1}.      /* Force NO-AVAILABLE */
         &IF DEFINED(adm-open-query) NE 0 &THEN
           /* If this is a query object and the last row in the external
              table was deleted (rather than just moving to a new parent
              row with no rows for this query) then get open-query to CLOSE
              this object's dependent query. */
           IF NOT different-row THEN
             RUN dispatch('open-query').  
         &ENDIF
         /* Change record-available state only for enabled tables. */
         &IF "{1}" = "{&FIRST-ENABLED-TABLE}" &THEN
         /* This is the primary or only record in the row,  
            and there's no record available, so if we switched states, 
            then signal that. */
           &IF DEFINED(adm-open-query) = 0 &THEN
              IF adm-row-avail-state NE no THEN
              DO:                                
                RUN new-state ('no-record-available':U). 
                RUN set-attribute-list 
                  ('Query-Position = no-record-available':U).
                adm-row-avail-state = no.        
              END.     
            &ENDIF
         &ENDIF
     END.
  END.
