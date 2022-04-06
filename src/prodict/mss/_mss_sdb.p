/*********************************************************************
* Copyright (C) 2006, 2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Procedure prodict/mss/_mss_sdb.p
   Created February 18, 2000
   Donna L. McMann
   
   This procedure assigns information to the _db record that is needed
   before processing is done via protomss.p  The bug flags were not
   being assigned early enough in the process for the DataServer to
   know what to do.
   
   History:  Added check for Old version of MSS D. McMann 04/24/00
   
             fernando   04/14/06  Unicode support
             fernando   07/19/06  Unicode support - MSS 2005 and up
             nagaraju   10/20/09  computed column support - MSS 2005 and up
             nagaraju   10/29/09  report error if computed column with MSS 2005 or earlier
             sgarg      08/18/11  OE00198733: Bug[17] should be OFF for MSS drivers
			 vprasad	08/20/2018 ODIA-1951 -  ODBC Driver 17 for SQL Server certification
*/   

&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/gate/odb_ctl.i }
&UNDEFINE DATASERVER

DEFINE VARIABLE driver-prefix	 AS CHARACTER NO-UNDO.
DEFINE VARIABLE escape_char      AS CHARACTER NO-UNDO.
DEFINE VARIABLE quote_char       AS CHARACTER NO-UNDO.
DEFINE VARIABLE i	             AS INTEGER   NO-UNDO.

FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db.  
RUN STORED-PROC DICTDBG.GetInfo (0).

FOR EACH DICTDBG.GetInfo_buffer:
   IF (LENGTH(DICTDBG.GetInfo_buffer.escape_char,"character") < 1)
     THEN  escape_char = " ".
   ELSE  escape_char = DICTDBG.GetInfo_buffer.escape_char .
   IF (LENGTH(DICTDBG.GetInfo_buffer.quote_char,"character") < 1)
      THEN  quote_char = " ".
   ELSE  quote_char = DICTDBG.GetInfo_buffer.quote_char.

   IF INTEGER(SUBSTRING(DICTDBG.GetInfo_buffer.dbms_version,1,2)) < 7 THEN
       RETURN "wrg-ver".

   /* for Unicode support, we only support SQL Server 2005 and up */
   IF user_env[32] = "MSSQLSRV9" THEN DO:
       IF INTEGER(SUBSTRING(DICTDBG.GetInfo_buffer.dbms_version,1,2)) < 8 THEN
           RETURN "wrg-ver".
   END.
   ELSE IF user_env[32] = "MSSQLSRV10" THEN DO:
       /* must be version 10 (SQL Server 2008) */
       IF INTEGER(SUBSTRING(DICTDBG.GetInfo_buffer.dbms_version,1,2)) < 10 THEN
           RETURN "wrg-ver".
       /* NOT using the SQL Native driver version 10 */
       /* NOT using the ODBC Driver 17 for SQL Server */
       IF 	((NOT DICTDBG.GetInfo_buffer.driver_name BEGINS "SQLNCLI") AND
			(NOT DICTDBG.GetInfo_buffer.driver_name BEGINS "MSODBCSQL")) 
			OR 
           INTEGER(ENTRY(1,DICTDBG.GetInfo_buffer.driver_version,".")) < 10 THEN
           RETURN "wrg-ver".
   END.
      /* for Computed column support, we only support SQL Server 2005 and up */
   ELSE IF ((NUM-ENTRIES(user_env[27]) > 1) AND (entry(2,user_env[27]) EQ "2")) THEN DO:
       IF INTEGER(SUBSTRING(DICTDBG.GetInfo_buffer.dbms_version,1,2)) < 9 THEN
           RETURN "wrg-ver".
   END.

   ASSIGN DICTDB._Db._Db-misc2[1] = DICTDBG.GetInfo_buffer.driver_name
          DICTDB._Db._Db-misc2[2] = DICTDBG.GetInfo_buffer.driver_version
          DICTDB._Db._Db-misc2[3] = escape_char + quote_char
          DICTDB._Db._Db-misc2[5] = DICTDBG.GetInfo_buffer.dbms_name + " " 
  			        + DICTDBG.GetInfo_buffer.dbms_version 
          DICTDB._Db._Db-misc2[6] = DICTDBG.GetInfo_buffer.odbc_version
          DICTDB._Db._Db-misc2[7] = "Dictionary Ver #:" +  odbc-dict-ver
  		                          + ",Client Ver #:"
  		                          + DICTDBG.GetInfo_buffer.prgrs_clnt
  		                          + ",Server Ver #:"
  		                          + DICTDBG.GetInfo_buffer.prgrs_srvr
  		                          + ","
          DICTDB._Db._Db-misc2[8] = DICTDBG.GetInfo_buffer.dbms_name
          driver-prefix    = ( IF DICTDB._Db._Db-misc2[1] BEGINS "QE"
                              THEN SUBSTRING(DICTDB._Db._Db-misc2[1]
                                      ,1
                                      ,LENGTH(DICTDB._Db._Db-misc2[1]
                                              ,"character") - 6
                                      ,"character")
  		                       ELSE DICTDB._Db._Db-misc2[1] )
          DICTDB._Db._Db-misc2[4] = "".
        
  REPEAT i = 1 TO 80:
   IF ( CAN-DO(odbc-bug-list[i], driver-prefix) OR
         CAN-DO(odbc-bug-list[i], "ALL") ) AND
         NOT CAN-DO(odbc-bug-excld[i], driver-prefix) THEN
      ASSIGN DICTDB._Db._Db-misc2[4] = DICTDB._Db._Db-misc2[4]
                                   + string(i) + "," .
   END. 
END. 
