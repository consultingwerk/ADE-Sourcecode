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

/*----------------------------------------------------------------------------

File: setalias.i

Description:   
   This procedure sets the alias as4dict which is used in the
   PROGRESS/400 Data Dictionary.  The alias allows the schema holder
   to have multi AS400 Schemas.
 
Author: Donna L. McMann

Date Created: 12/30/94

----------------------------------------------------------------------------*/

cr-al:
FOR EACH _Db NO-LOCK:
    IF _Db._Db-type = "AS400" THEN DO:
        /* default to the first as400 that is connected*/     
      IF CONNECTED(_Db._Db-name) THEN DO:      
           FIND _File OF _DB WHERE _File._File-name = "p__File" NO-LOCK NO-ERROR.
                 IF AVAILABLE _File THEN DO:
                    CREATE ALIAS as4dict FOR DATABASE VALUE(_Db._Db-name).
                     ASSIGN assgndb = TRUE.
                      LEAVE cr-al.
                 END.
            END.
      END.
END.

