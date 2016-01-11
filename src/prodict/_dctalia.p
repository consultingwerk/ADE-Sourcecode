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

/*--------------------------------------------------------------------

File: prodict/_dctalia.p

Description:
    
    Sets DICTDB alias to Database number p_db-num
            
Input-Parameters:
    p_db-num    number of db to set alias to

Output-Parameters:
    none
    
Used/Modified Shared Objects:
    none
    
Author: Tom Hutegger

History:
    hutegger    94/04/12    creation
    mcmann      10/17/03    Add NO-LOCK statement to _Db find in support of on-line schema add

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define input parameter p_db-name    as character.

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

      find first DICTDB._Db
        where DICTDB._Db._Db-name = p_db-name
        NO-LOCK no-error.

      if not available DICTDB._Db
       then create alias "DICTDB"
            for database VALUE(SDBNAME(p_db-name))
            no-error.

/*------------------------------------------------------------------*/
