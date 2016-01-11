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

/* dictgate.i - (another) performs routine for the different db mgrs 

  History:  D. McMann 03/20/00 Changed MSSQLSRV to MSS 

*/

{&output} = "{&action}".
RUN VALUE("prodict/" +
  ENTRY(LOOKUP({&dbtype},
               "AS400,CTOSISAM,GENERIC," 
             + "OBJECTA,ORACLE,RDB,SYBASE,ODBC," 
             + "SYB10,ALLBASE,DB2,DB2-DRDA,MSS") + 1,
        "pro/_pro,as4/_as4,bti/_bti,gen/_gen,"
      + "oag/_oag,ora/_ora,rdb/_rdb,syb/_syb,odb/_odb,"
      + "odb/_odb,odb/_odb,odb/_odb,odb/_odb,mss/_mss")
  + "_sys.p")
  ({&dbrec},INPUT-OUTPUT {&output}).
