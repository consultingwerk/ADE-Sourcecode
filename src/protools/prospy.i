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
/*********************************************************************
 
 File:              prospy.i
 Description:       Definition for the temporary table that is used by
                    the PRO*Spy tool for version 9. 
                    
 

  Created:          12/07/99
  

***********************************************************************/
DEFINE TEMP-TABLE tSpyInfo 
        FIELD tType     AS CHARACTER FORMAT "x(10)"
        FIELD tSource   AS CHAR FORMAT "x(28)"
        FIELD tSrcProc  AS CHAR FORMAT "x(28)"
        FIELD tProcName AS CHAR FORMAT "x(28)"
        FIELD tTarget   AS CHAR FORMAT "x(28)"
        FIELD tParms    AS CHAR FORMAT "x(10000)"
        FIELD tSpyId    AS INTEGER
        INDEX tSpyIdx IS UNIQUE PRIMARY tSpyID ASC.
