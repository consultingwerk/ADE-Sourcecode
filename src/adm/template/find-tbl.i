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
