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
/* pnstates.i - navigate panel-specific ADM states */

    /* If a link has been activated or deactivated, check to
       see if it was the record target; if so, signal other objects
       such as Navigation Panel. */

    WHEN "link-changed":U THEN 
    DO:
        RUN request-attribute IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT 'NAVIGATION-TARGET':U,
             INPUT 'Query-Position':U).
        IF RETURN-VALUE NE ? AND RETURN-VALUE NE "?":U AND NOT updating THEN
        DO:
          CASE RETURN-VALUE:
            WHEN 'first-record':U THEN adm-panel-state = 'first':U.
            WHEN 'last-record':U THEN adm-panel-state = 'last':U.
            WHEN 'only-record':U THEN adm-panel-state = 'disable-all':U.
            WHEN 'not-first-or-last':U THEN adm-panel-state = 'enable-all':U.
            WHEN 'no-record-available':U THEN adm-panel-state = 'disable-all':U.
            WHEN 'no-external-record-available':U THEN 
                  adm-panel-state = 'disable-all':U.
          END CASE.
          RUN set-buttons (adm-panel-state).  /* reset to prior state */
        END.
        ELSE DO:
          adm-panel-state = 'disable-all':U.
	  RUN set-buttons (adm-panel-state).
        END.
    END.

    WHEN "record-available":U THEN
        IF not updating THEN
            RUN set-buttons ('enable-all':U).
          
    WHEN "update-complete":U THEN 
    DO:
        updating = false.
        RUN set-buttons (adm-panel-state).
    END.

    WHEN "update":U THEN 
    DO:
        updating = true.
        RUN set-buttons ('disable-all':U).
    END.
        
    WHEN "no-record-available":U OR
    WHEN "no-external-record-available":U THEN 
    DO:
        adm-panel-state = 'disable-all':U.
	RUN set-buttons (adm-panel-state).
    END.

    WHEN "first-record":U THEN 
    DO:
        adm-panel-state = 'first':U.
        RUN set-buttons (adm-panel-state).
    END.
    
    WHEN "last-record":U THEN 
    DO:
        adm-panel-state = 'last':U.
        RUN set-buttons (adm-panel-state).
    END.
    
    WHEN 'not-first-or-last':U THEN 
    DO:
        adm-panel-state = 'enable-all':U.
        RUN set-buttons (adm-panel-state).
    END.
    
    WHEN 'only-record':U THEN 
    DO:
        adm-panel-state = 'disable-all':U.
        RUN set-buttons (adm-panel-state).
    END.
