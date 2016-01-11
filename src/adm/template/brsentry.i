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
/* brsentry.i - trigger code for ROW-ENTRY of SmartBrowse */
/* For the sake of backward compatibility with 8.0, FIRST-ENABLED-TABLE
   is mapped to ENABLED-TABLES if it is otherwise undefined. */
&IF DEFINED (FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}) = 0 &THEN
  &SCOP FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME} {&ENABLED-TABLES-IN-QUERY-{&BROWSE-NAME}}
&ENDIF
&IF "{&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}":U NE "":U &THEN
   IF {&BROWSE-NAME}:NEW-ROW AND NOT adm-brs-initted THEN 
   DO:
     /* This prevents initial values from being displayed twice if focus
        leaves the row (because of an error, e.g.) and then returns: */
     adm-brs-initted = yes.  

     IF adm-adding-record THEN        /* if it's Add, not Copy */
     DO:
       IF adm-create-on-add = no THEN /* and we're postponing Create */
       DO:
         /* We can retrieve and display initial values only for Progress DBs.*/
         IF DBTYPE(LDBNAME(BUFFER {&adm-first-enabled-table})) EQ "PROGRESS":U
         THEN DO:
          /* Retrieve and display the template record initial values. */
          FIND {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE 
            RECID({&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}) 
              = adm-first-tmpl-recid.
          &IF "{&SECOND-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}":U NE "":U &THEN
            FIND {&SECOND-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE 
              RECID({&SECOND-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}) 
                = adm-second-tmpl-recid.
          &ENDIF
          &IF "{&THIRD-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}":U NE "":U &THEN
            FIND {&THIRD-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE 
              RECID({&THIRD-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}) 
                = adm-third-tmpl-recid.
          &ENDIF

          DISPLAY {&UNLESS-HIDDEN} {&FIELDS-IN-QUERY-{&BROWSE-NAME}}
            WITH BROWSE {&BROWSE-NAME} NO-ERROR.
         END.
        END.
        ELSE DO:              /* Else do the Create here */
         DO TRANSACTION ON STOP  UNDO, RETURN "ADM-ERROR":U
                        ON ERROR UNDO, RETURN "ADM-ERROR":U.
           adm-create-complete = no.    /* Signal Cancel in case of failure. */
           RUN dispatch ('create-record':U).
           IF RETURN-VALUE = "ADM-ERROR":U THEN UNDO, RETURN "ADM-ERROR":U.
           DISPLAY {&UNLESS-HIDDEN} {&FIELDS-IN-QUERY-{&BROWSE-NAME}}
             WITH BROWSE {&BROWSE-NAME} NO-ERROR.
         END.
         adm-create-complete = yes.
        END. 
      END.              /* END code for Progress DB initial values. */
      ELSE                       /* Start with old record for a copy */
      DO:
         FIND {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE 
           ROWID({&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}) = 
              adm-first-prev-rowid NO-LOCK. 

         &IF "{&SECOND-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}":U NE "":U &THEN
           FIND {&SECOND-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE 
             ROWID({&SECOND-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}) = 
                adm-second-prev-rowid NO-LOCK. 
         &ENDIF

         &IF "{&THIRD-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}":U NE "":U &THEN
           FIND {&THIRD-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE 
             ROWID({&THIRD-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}) = 
                adm-third-prev-rowid NO-LOCK. 
         &ENDIF

         DISPLAY {&UNLESS-HIDDEN} {&FIELDS-IN-QUERY-{&BROWSE-NAME}} 
           WITH BROWSE {&BROWSE-NAME}.
      END.
   END. 
&ENDIF
