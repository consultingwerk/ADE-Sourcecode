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
/* Procedure prodict/mss/_mss_sdb.p
   Created February 18, 2000
   Donna L. McMann
   
   This procedure assigns information to the _db record that is needed
   before processing is done via protomss.p  The bug flags were not
   being assigned early enough in the process for the DataServer to
   know what to do.
   
   History:  Added check for Old version of MSS D. McMann 04/24/00
   
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

   ASSIGN DICTDB._Db._Db-misc2[1] = DICTDBG.GetInfo_buffer.driver_name
          DICTDB._Db._Db-misc2[2] = DICTDBG.GetInfo_buffer.driver_version
          DICTDB._Db._Db-misc2[3] = escape_char + quote_char
          DICTDB._Db._Db-misc2[5] = DICTDBG.GetInfo_buffer.dbms_name + " " 
  			        + DICTDBG.GetInfo_buffer.dbms_version 
          DICTDB._Db._Db-misc2[6] = DICTDBG.GetInfo_buffer.odbc_version
          DICTDB._Db._Db-misc2[7] = "Dictionary Ver#: " +  odbc-dict-ver
  		                          + " Client Ver#: "
  		                          + DICTDBG.GetInfo_buffer.prgrs_clnt
  		                          + " Server Ver# "
  		                          + DICTDBG.GetInfo_buffer.prgrs_srvr
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
    IF i = 17 THEN DO:
      IF DICTDB._Db._Db-Misc1[1] = 1 THEN 
        ASSIGN DICTDB._Db._Db-misc2[4] = DICTDB._Db._Db-misc2[4]
                                   + string(i) + "," .
    END.
    ELSE IF ( CAN-DO(odbc-bug-list[i], driver-prefix) OR
         CAN-DO(odbc-bug-list[i], "ALL") ) AND
         NOT CAN-DO(odbc-bug-excld[i], driver-prefix) THEN
      ASSIGN DICTDB._Db._Db-misc2[4] = DICTDB._Db._Db-misc2[4]
                                   + string(i) + "," .
  END. 
END. 
