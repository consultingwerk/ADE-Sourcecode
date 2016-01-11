/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: qseqrpt.p

Description:
   Quick and dirty sequence report for both the GUI and character dictionaries.

Input Parameters:
   p_DbId    - Id of the _Db record corresponding to the current database
   p_PName   - Physical name of the database
   p_DbType  - Database type (e.g., PROGRESS)

Author: Tony Lavinio, Laura Stern

Date Created: 10/08/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
            07/14/98 by D. McMann Added DBVERSION check and _Owner for _File find
            03/29/99 by Mario B      BUG# 99-03-26-19 Changed DBNAME to 
                                     "DICTDB" in _Owner check.
            08/08/02 by D. McMann Eliminated any sequences whose name begins "$" - Peer Direct
----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR  NO-UNDO.

DEFINE VAR header_str AS CHAR NO-UNDO.
DEFINE VAR flag AS CHAR NO-UNDO INIT "".

FIND _Db WHERE RECID(_Db) = p_DbId NO-LOCK.
IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
  FIND _File WHERE _File._File-name = "_Sequence"
               AND _File._Owner = "PUB" NO-LOCK.
ELSE               
  FIND _File "_Sequence" NO-LOCK.
  
IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN DO:
  MESSAGE "You do not have permission to use this option."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

FIND LAST _Sequence WHERE _Sequence._Db-recid = p_DbId 
                      AND NOT _Sequence._Seq-name BEGINS "$" NO-LOCK NO-ERROR.
IF NOT AVAILABLE _Sequence THEN DO:
  MESSAGE "There are no sequences in this database to look at."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

IF CAN-FIND(FIRST dictdb._tenant) THEN
   flag = "Flags: 'm'=multi-tenant".


header_str = "Database: " + p_PName + " (" + p_DbType + ")".
RUN adecomm/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Sequence Report",
    INPUT flag,
    INPUT "",
    INPUT "adecomm/_qseqdat.p",
    INPUT "",
    INPUT {&Sequence_Report}).

/* _qseqrpt.p - end of file */



