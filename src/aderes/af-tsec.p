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
/*
* af-tsec.p
*
*    Calls the admin defined table security function.
*/

{ aderes/s-system.i }
{ aderes/j-define.i }

DEFINE VARIABLE ans       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.
DEFINE VARIABLE tCount    AS INTEGER   NO-UNDO.
DEFINE VARIABLE dName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE tList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE aList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE sList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lookAhead AS CHARACTER NO-UNDO.
DEFINE VARIABLE fName     AS CHARACTER NO-UNDO.

/* If there isn't any admin defined security then return.  */
IF qbf-u-hook[{&ahSecTableCode}] <> ? THEN DO:

  /*
  * The secure where code doesn't have a Results Core version. If the
  * Admin doesn't provide a function then Results will use the security
  * defined in the dictionary. This code should be called after
  * j-init.p builds the list of tables.
  */
  fName = SEARCH(qbf-u-hook[{&ahSecTableCode}]).

  IF fName = ? THEN
  RUN adecomm/_s-alert.p (INPUT-OUTPUT ans, "error":u, "ok":u,
    SUBSTITUTE("The Admin function, &1, was defined but not found for the TableSecurity Check.  &2 will use default table security.",
    qbf-u-hook[{&ahSecTableCode}],qbf-product)).
  ELSE
  _tableCheck = fName.
END.

IF _tableCheck = ? THEN RETURN.

/*
 * Loop through each database and set up a list of 350 tables. Send over
 * to the application. This is done for performance (fewer calls to .p files)
 * and to avoid hitting any Progress run time limits.
 */
DO ix = 1 TO NUM-ENTRIES(qbf-dbs):
  ASSIGN
    lookAhead = ""
    tCount    = 0
    tList     = ""
    aList     = ""
    sList     = ""
    dName     = ENTRY(ix, qbf-dbs)
    .

  FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee
    AND ENTRY(1,qbf-rel-buf.tname,".":u) = ENTRY(ix,qbf-dbs):

    /* Assign the table and default for cansee */
    ASSIGN
      tCount = tCount + 1
      tList  = tList + lookAhead + ENTRY(2,qbf-rel-buf.tname,".":u)
      sList  = sList + lookAhead + "true":u
      .

    /*
    * If there is an alias then get the reference name. The security
    * function will need to know this information to make a valid decision.
    */

    IF qbf-rel-buf.sid <> ? THEN DO:
      {&FIND_TABLE2_BY_ID} qbf-rel-buf.sid.
      aList = aList + lookAhead + ENTRY(2,qbf-rel-buf2.tname,".":u).
    END.
    ELSE
      aList = aList + lookAhead.

    lookAhead = ",":u.

    IF tCount = 350 THEN
      RUN checkSecurity.
  END.

  /* The walk through the tables rarely ends on an even block of 350 */
  IF tCount > 0 THEN
    RUN checkSecurity.
END.

RETURN.

/*------------------------------------------------------------------------*/
PROCEDURE checkSecurity:
  DEFINE VARIABLE jx AS INTEGER NO-UNDO.

  IF _tableCheck = ? THEN RETURN.
  
  hook:
  DO ON STOP UNDO hook, RETRY hook:
    IF RETRY THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ans, "error":u, "ok":u,
        SUBSTITUTE("There is a problem with &1.  &2 will use default table security.",_tableCheck,qbf-product)).
  
      _tableCheck = ?.
      LEAVE hook.
    END.
  
    RUN VALUE(_tableCheck) (dName,USERID(dName),tList,aList,INPUT-OUTPUT sList).
  
    /* Walk through the list and set our bits. */
    DO jx = 1 TO NUM-ENTRIES(tList):
      {&FIND_TABLE2_BY_NAME} dName + ".":u + ENTRY(jx, tList).
      qbf-rel-buf2.cansee = (ENTRY(jx, sList) = "true":u).
    END.
  
    ASSIGN
      lookAhead = ""
      tCount    = 0
      tList     = ""
      aList     = ""
      sList     = ""
      .
  END.
END PROCEDURE.
  
/* af-tsec.p - end of file */

