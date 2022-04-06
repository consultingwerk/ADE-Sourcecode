/*********************************************************************
* Copyright (C) 2000,2013 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: qtblrpt.p

Description:
   Quick and dirty table report for both the GUI and character dictionary.
 
Input Parameters:
   p_DbId   - Id of the _Db record corresponding to the current database
   p_PName  - Physical name of the database
   p_DbType - Database type (e.g., PROGRESS)

Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92
    Modified: 07/10/98 D. McMann Added DBVERSION and _Owner check
              03/29/99 by Mario B      BUG# 99-03-26-19 Changed DBNAME to 
                                       "DICTDB" in _Owner check.

----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR  NO-UNDO.

DEFINE VAR header_str AS CHAR NO-UNDO.
DEFINE VAR flags      AS CHAR NO-UNDO.
DEFINE VAR cdc        AS LOGICAL INIT NO NO-UNDO.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
  FIND dictdb._File WHERE dictdb._File._File-name = "_File"
               AND dictdb._File._Owner = "PUB"
               NO-LOCK.
  IF NOT CAN-DO(dictdb._File._Can-read,USERID("DICTDB")) THEN DO:
    MESSAGE "You do not have permission to use this option."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.

  FIND LAST dictdb._File WHERE (dictdb._File._Owner = "PUB" OR dictdb._File._Owner = "_FOREIGN")
                    AND NOT dictdb._File._Hidden NO-LOCK NO-ERROR.
  IF NOT AVAILABLE _File THEN DO:
    MESSAGE "There are no tables in this database to look at."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
END.
ELSE DO:
  FIND dictdb._File "_File".
  IF NOT CAN-DO(dictdb._File._Can-read,USERID("DICTDB")) THEN DO:
    MESSAGE "You do not have permission to use this option."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.

  FIND LAST dictdb._File WHERE  NOT dictdb._File._Hidden NO-ERROR.
  IF NOT AVAILABLE dictdb._File THEN DO:
    MESSAGE "There are no tables in this database to look at."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
END.  

header_str = "Database: " + p_PName + " (" + p_DbType + ")".

FIND dictdb._Database-feature WHERE dictdb._Database-feature._DBFeature_Name = "Change Data Capture" NO-LOCK NO-ERROR.
if dictdb._Database-feature._dbfeature_enabled EQ "1" then assign cdc = true.

FIND dictdb._Database-feature WHERE dictdb._Database-feature._DBFeature_Name = "Table Partitioning" NO-LOCK NO-ERROR.

IF dictdb._Database-feature._dbfeature_enabled EQ "1" AND CAN-FIND(FIRST dictdb._tenant) THEN
    flags = "Flags: 'c'=cdc-enabled, 'p'=partitioned, 'm'=multi-tenant, 'f'=frozen, 's'=a SQL table".
ELSE IF _File._file-attributes[1] THEN
    flags = "Flags: 'c'=cdc-enabled, 'f'=frozen, 's'=a SQL table".
ELSE IF _File._file-attributes[3] THEN
    flags = "Flags: 'p'=partitioned, 'f'=frozen, 's'=a SQL table".
ELSE IF cdc THEN
    flags = "Flags: 'c'=cdc-enabled, 'ct'=CDC change table, 'f'=frozen, 's'=a SQL table".
ELSE
    flags = "Flags: 'f'=frozen, 's'=a SQL table".

RUN adecomm/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Quick Table Report",
    INPUT flags,
    INPUT "",
    INPUT "adecomm/_qtbldat.p",
    INPUT "",
    INPUT {&Quick_Table_Report}).

/* _qtblrpt.p - end of file */





