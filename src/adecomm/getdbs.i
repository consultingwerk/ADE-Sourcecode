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

File: adecomm/getdbs.i

Description:
    
    definition of s_ttb_db - Temp-Table
            
Input-Parameters:
    none

Output-Parameters:
    none
    
included in:
    adecomm/_getdbs.p
    adecomm/_getfdbs.p
    prodict/_dctsget.p
    adedict/DB/_getdbs.p

    
Author: Tom Hutegger

History:
    hutegger    95/06   creation
    hutegger    95/08   added dbrcd, empty and dspnm fields

                            
--------------------------------------------------------------------*/
/*h-*/

def {&new} shared temp-table   s_ttb_db
        field               cnnctd      as logical   format "yes/no"
        field               dbnr        as integer   format "zz9"
        field               dbtyp       as character format "x(12)"
        field               dspnm       as character format "x(20)"
        field               ldbnm       as character format "x(12)"
        field               pdbnm       as character format "x(40)"
        field               sdbnm       as character format "x(12)"
        field               vrsn        as character format "x"
        field               empty       as logical   format "yes/no"
        field               dbrcd       as recid
        field               local       as logical   format "local/holder"
        index               upi         is primary unique
                                        dbnr ldbnm.

/*------------------------------------------------------------------*/
