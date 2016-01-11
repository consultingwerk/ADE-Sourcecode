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
/* snd-end.i */
        OTHERWISE 
        DO:
            RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                INPUT "RECORD-SOURCE":U, OUTPUT link-handle) NO-ERROR.
            IF link-handle NE "":U THEN 
            DO:
                IF NUM-ENTRIES(link-handle) > 1 THEN  
                    MESSAGE "send-records in ":U THIS-PROCEDURE:FILE-NAME 
                            "encountered more than one RECORD-SOURCE.":U SKIP
                            "The first will be used.":U 
                            VIEW-AS ALERT-BOX ERROR.
                RUN send-records IN WIDGET-HANDLE(ENTRY(1,link-handle))
                    (INPUT ENTRY(i, p-tbl-list), OUTPUT rowid-string).
                p-rowid-list = p-rowid-list + rowid-string.
            END.
            ELSE
            DO:
                MESSAGE "Requested table":U ENTRY(i, p-tbl-list) 
                        "does not match tables in send-records":U 
                        "in procedure":U THIS-PROCEDURE:FILE-NAME ".":U SKIP
                        "Check that objects are linked properly and that":U
                        "database qualification is consistent.":U
                    VIEW-AS ALERT-BOX ERROR.     
                RETURN ERROR.
            END.
        END.
        END CASE.        
    END.                 /* i = 1 to num-entries */
