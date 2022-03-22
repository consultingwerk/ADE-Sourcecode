/*********************************************************************
* Copyright (C) 2000,2007-08, 2009 by Progress Software Corporation. All *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Procedure prodict/odb/_odb_sdb.p
   Created February 18, 2000
   Donna L. McMann
   
   This procedure assigns information to the _db record that is needed
   before processing is done via protoodb.p  The bug flags were not
   being assigned early enough in the process for the DataServer to
   know what to do.
   History :
   knavneet 07/24/07 For DB2/400 append the library name to _Db-misc2[1] if it is not empty string. This can be used as default lib while schema update 
   nagaraju 10/21/09 Support for computed column RECID in MSSDS - OE00186593 
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
DEFINE VARIABLE i	         AS INTEGER   NO-UNDO.
DEFINE VARIABLE found	         AS INTEGER   NO-UNDO.
DEFINE VARIABLE clnt_vers           AS CHARACTER NO-UNDO.

FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db.  
RUN STORED-PROC DICTDBG.GetInfo (0).

FOR EACH DICTDBG.GetInfo_buffer:
   IF (LENGTH(DICTDBG.GetInfo_buffer.escape_char,"character") < 1)
     THEN  escape_char = " ".
   ELSE  escape_char = DICTDBG.GetInfo_buffer.escape_char .
   IF (LENGTH(DICTDBG.GetInfo_buffer.quote_char,"character") < 1)
      THEN  quote_char = " ".
   ELSE  quote_char = DICTDBG.GetInfo_buffer.quote_char.

   IF INTEGER(SUBSTRING(DICTDBG.GetInfo_buffer.dbms_version,1,2)) >= 7 AND
      DICTDBG.GetInfo_buffer.dbms_name BEGINS "Microsoft SQL" THEN
       RETURN "wrg-ver".

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
 
    /* wait until here to add library name so that driver-prefix is correctly set
       to the driver name only.
    */
   IF user_library <> "" AND user_library <> "*" THEN 
    ASSIGN DICTDB._Db._Db-misc2[1] = DICTDBG.GetInfo_buffer.driver_name + "," + UPPER(user_library).

   /* If client version is formatted w/"sh_min", the client is OpenEdge 10.1A or greater
    * which knows about the dictionary version number
    */
      IF INDEX(DICTDBG.GetInfo_buffer.prgrs_clnt, ",(sh_min=") <> 0 THEN
        DICTDB._Db._Db-misc2[7] = DICTDB._Db._Db-misc2[7] + " Schema Holder Ver#: ".
       
  REPEAT i = 1 TO 80:
    IF ( CAN-DO(odbc-bug-list[i], driver-prefix) OR
         CAN-DO(odbc-bug-list[i], "ALL") ) AND
         NOT CAN-DO(odbc-bug-excld[i], driver-prefix) THEN
      ASSIGN DICTDB._Db._Db-misc2[4] = DICTDB._Db._Db-misc2[4]
                                   + string(i) + "," .
  END. 
END. 
