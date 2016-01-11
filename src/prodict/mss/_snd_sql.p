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

/* _snd_sql.p - SEND.SQL toMSS to create MSS objects. */

/*++


Component:  Protoxxx   (progress to foreign datamanager)

Purpose:    Read in SQL from a file created by _wrktgen.p
            and use SEND-SQL-STATEMENT stored procedure
            to perform each command inside foreign data manager. 

            NOTE: The output of this file can be adjusted 
                 by using the local environment variables 
                 and the dataserver dependent section at 
                 begining of the code.  

History:    
   D. McMann 03/31/00 Created from odb/_snd_sql.p

--*/


{ prodict/gate/_snd_sql.i }
