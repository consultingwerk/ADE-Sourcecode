/*********************************************************************
* Copyright (C) 2000,2007, 2009 by Progress Software Corporation. All *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _sndinfo.p - 

   History:  DLM Removed warning message about driver not being certified 11/23/98
             knavneet While checking the driver name we read the 1st ENTRY from _Db-misc2[1] as it may have Library name appended to it for DB2/400 01/24/07
             nagaraju 10/21/09 Support for computed column RECID in MSSDS - OE00186593 

*/
{ prodict/dictvar.i }
{ prodict/gate/odb_ctl.i }

DEFINE VARIABLE driver-prefix AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.

RUN STORED-PROC DICTDBG.CloseAllProcs.
FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db.
RUN STORED-PROC DICTDBG.GetInfo (0).
FOR EACH DICTDBG.GetInfo_buffer:

  IF DICTDB._Db._Db-misc2[1] = ? THEN DO:
    ASSIGN
      DICTDB._Db._Db-misc2[1] = DICTDBG.GetInfo_buffer.driver_name
      DICTDB._Db._Db-misc2[2] = DICTDBG.GetInfo_buffer.driver_version
      DICTDB._Db._Db-misc2[3] = (IF (LENGTH(DICTDBG.GetInfo_buffer.escape_char) < 1)
			 THEN " "
  			 ELSE
  			 DICTDBG.GetInfo_buffer.escape_char) +
        			 (IF (LENGTH(DICTDBG.GetInfo_buffer.quote_char)
				 < 1)
  			 THEN " "
  			 ELSE
  			 DICTDBG.GetInfo_buffer.quote_char) 
        DICTDB._Db._Db-misc2[5] = DICTDBG.GetInfo_buffer.dbms_name + " " +
  			 DICTDBG.GetInfo_buffer.dbms_version 
        DICTDB._Db._Db-misc2[6] = DICTDBG.GetInfo_buffer.odbc_version
        DICTDB._Db._Db-misc2[7] = "Dictionary Ver #:" +  odbc-dict-ver +
  		       ",Client Ver #:" + DICTDBG.GetInfo_buffer.prgrs_clnt +
  		       ",Server Ver #:" + DICTDBG.GetInfo_buffer.prgrs_srvr +
                       ",".

        driver-prefix = IF DICTDB._Db._Db-misc2[1] BEGINS "QE" THEN
  		      SUBSTRING(DICTDB._Db._Db-misc2[1], 1,
  				LENGTH(DICTDB._Db._Db-misc2[1]) - 6) ELSE
  		      DICTDB._Db._Db-misc2[1].

        DICTDB._Db._Db-misc2[4] = "".
        REPEAT i = 1 TO 80:
          DICTDB._Db._Db-misc2[4] = IF ( CAN-DO(odbc-bug-list[i], driver-prefix)
                                OR CAN-DO(odbc-bug-list[i], "ALL") )
                                AND NOT CAN-DO(odbc-bug-excld[i],
  					 driver-prefix)
                             THEN DICTDB._Db._Db-misc2[4] + string(i) + "," 
  			   ELSE DICTDB._Db._Db-misc2[4].
        END. /* REPEAT */

        END. /* _Db._Db-misc2[1] = ? DO */
    
    ELSE IF ENTRY(1,DICTDB._Db._Db-misc2[1]) <> DICTDBG.GetInfo_buffer.driver_name THEN
    DO:
      MESSAGE
	    "The Schema Holder was not created with the ODBC driver you have"
	    "connected with." SKIP
	    "You may experience problems with this connection."
	    SKIP(1)
	    "Schema Holder: "  DICTDB._Db._Db-misc2[1] SKIP
	    "Current driver: " DICTDBG.GetInfo_buffer.driver_name
	    SKIP(1)
	    "Please consider recreating your schema holder using the current"
	    "ODBC driver."
	    VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
  END.
  CLOSE STORED-PROC DICTDBG.GetInfo.

  /* Refresh the bug info we just calculated.				*/
  RUN STORED-PROC DICTDBG.SendInfo (DICTDB._Db._Db-misc2[4]).
  CLOSE STORED-PROC DICTDBG.SendInfo.


