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
Modified on 02/16/95 by Donna McMann to work with Progress/400 Data Dictionary.
            10/
----------------------------------------------------------------------------*/

/* This isn't used because there is no db id in _User record
   but there should be!!! */
DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.
DEFINE VAR pword AS LOGICAL NO-UNDO.

FORM
  as4dict.p__User._Userid    FORMAT "x(8)"   LABEL "User ID"
  as4dict.p__User._User-name FORMAT "x(40)"  LABEL "User Name"
  pword            FORMAT "yes/no" LABEL "Has Password?"
  WITH FRAME shousers 
  DOWN USE-TEXT STREAM-IO.

FOR EACH as4dict.p__User NO-LOCK:
   DISPLAY STREAM rpt
      as4dict.p__User._Userid
      as4dict.p__User._User-name
      as4dict.p__User._Password <> ENCODE("") @ pword
      WITH FRAME shousers.
  DOWN STREAM rpt WITH FRAME shousers.
END.

