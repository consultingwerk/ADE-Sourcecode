/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
