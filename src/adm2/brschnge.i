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
/* brschnge.i - trigger code for VALUE-CHANGED trigger of SmartDataBrowse - 03/03/99 */

  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE NO-UNDO.
  DEFINE VARIABLE cNewRecord  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQuery      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cModFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayed AS CHARACTER  NO-UNDO.

  IF glReposition THEN  /* Don't generate an extra unwanted dataAvailable.*/
    glReposition = no.
  ELSE DO:
    {get NewRecord cNewRecord}.
    IF cNewRecord = 'No':U THEN
    DO:
      {get QueryObject lQuery}.
      IF lQuery THEN  /* Browser has its own dbquery */
        RUN dataAvailable ("VALUE-CHANGED":U).
      ELSE DO:
        hQuery = {&BROWSE-NAME}:QUERY.
        hBuffer = hQuery:GET-BUFFER-HANDLE(1).
        /* We don't have access to the RowObject Temp-Table's RowIdent
           field so we get the result ROWID from the Quer's buffer as an ID. */
        {set RowIdent STRING(hBuffer:ROWID)}.
        {get DataSource hDataSource}.
        /* Tell the DataObject to let other objects know.*/
        glReposition = yes.     /* prevents the browse from reacting. */
        RUN dataAvailable IN hDataSource ("DIFFERENT":U) NO-ERROR.
      END.  /* END ELSE DO */
    END.    /* END DO IF not NewRecord */
  END.      /* ELSE ELSE DO IF NOT glReposition */

  {get ModifiedFields cModFields}.
  {get DisplayedFields cDisplayed}.
  {get NewRecord cNewRecord}.
  IF cNewRecord = 'No':U AND
      INDEX(cDisplayed, "<calc>") > 0 AND  /* local calculated fields present */
      num-entries(cModFields) > 1          /* enabled fields were modified */
  THEN DO:
      BROWSE {&BROWSE-NAME}:REFRESH() NO-ERROR. /* Make sure that calc'd fields are refreshed */
  END.
