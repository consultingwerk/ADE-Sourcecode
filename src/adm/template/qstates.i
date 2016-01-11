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
    
