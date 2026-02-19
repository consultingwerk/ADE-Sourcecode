/**********************************************************************
* Copyright (C) 2000-2010,2025 by Progress Software Corporation. All rights*
* reserved. Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: qusrdata.p

Description:
   Display _User information for the quick user report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId - Id of the _Db record for this database.

Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
            04/16/25 by Talha Masood. Replaced ENCODE with GENERATE-PASSWORD-HASH to support FIPS
            05/08/25 by Talha Masood. Added a new column to indicate whether the old ENCODE password was used.
----------------------------------------------------------------------------*/

/* This isn't used because there is no db id in _User record
   but there should be!!! */
DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.
DEFINE VAR pword AS LOGICAL NO-UNDO.
DEFINE VARIABLE newpwd AS LOGICAL NO-UNDO.

FORM
  _User._Userid    FORMAT "x(8)"   LABEL "User ID"
  _User._Domain-Name FORMAT "x(32)" LABEL "Domain"
  _User._User-name FORMAT "x(20)"  LABEL "User Name"
  pword            FORMAT "yes/no" LABEL "Pwd?"
  _User._sql-only-user FORMAT "yes/no" COLUMN-LABEL "SQL!only"
  newpwd           FORMAT "yes/no" COLUMN-LABEL "New!Pwd?"
  WITH FRAME shousers 
  DOWN WIDTH 100 USE-TEXT STREAM-IO.

FOR EACH _User NO-LOCK:
   IF SECURITY-POLICY:FIPS-MODE OR _User._Password BEGINS "uphA1::" THEN
     pword = NOT SECURITY-POLICY:VALIDATE-PASSWORD("", _User._Password).
   ELSE
     pword = _User._Password <> ENCODE("").

   IF _User._Password BEGINS "uphA1::" THEN
     newpwd = YES.
   ELSE
     newpwd = NO.
   
   DISPLAY STREAM rpt
      _User._Userid
      _User._Domain-Name
      _User._User-name
      pword
      _User._sql-only-user
      newpwd
      WITH FRAME shousers.
  DOWN STREAM rpt WITH FRAME shousers.
END.

