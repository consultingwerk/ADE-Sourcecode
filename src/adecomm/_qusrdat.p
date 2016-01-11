/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

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
----------------------------------------------------------------------------*/

/* This isn't used because there is no db id in _User record
   but there should be!!! */
DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.
DEFINE VAR pword AS LOGICAL NO-UNDO.

FORM
  _User._Userid    FORMAT "x(8)"   LABEL "User ID"
  _User._User-name FORMAT "x(40)"  LABEL "User Name"
  pword            FORMAT "yes/no" LABEL "Has Password?"
  WITH FRAME shousers 
  DOWN USE-TEXT STREAM-IO.

FOR EACH _User NO-LOCK:
   DISPLAY STREAM rpt
      _User._Userid
      _User._User-name
      _User._Password <> ENCODE("") @ pword
      WITH FRAME shousers.
  DOWN STREAM rpt WITH FRAME shousers.
END.

