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

File: as4dict/_dictfdb.p

Description:
    checks if the schmeaholder has also a PROGRESS-Schema in it
    
Input-Output Pramaeters:
    dbnum   gets increased by one if PROGRESS-Schemaholder contains no 
    PROGRESS-Schema
    
    
History:
    hutegger    94/06/13    creation
    Modified to work with PROGRESS/400 Data Dictionary   D. McMann    
--------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER dbnum as integer.

/*------------------------------------------------------------------*/

        find first DICTDB._db where DICTDB._db._db-name = ? no-error.         
        if available DICTDB._Db
         AND NOT can-find(first DICTDB._file of DICTDB._db             
                         where DICTDB._file._file-number > 0)  
  
                  then assign dbnum = dbnum + 1.               

  
  
/*------------------------------------------------------------------*/
