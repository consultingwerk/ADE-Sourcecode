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
/* brsend.i */
  DEFINE VARIABLE lQuery  AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hSource AS HANDLE  NO-UNDO.

  /* Reposition flag means ignore this event because it occured
     as a side-effect of another reposition event. */
  IF NOT glReposition THEN
  DO:
  /* If this Browser does not manage its own db query,
     then tell the DataSource to reposition to the
     last row in the dataset, even if that means
     getting additional batches of rows from the db.
     Otherwise, if this *is* a db browser, run it locally
     to set LastRowNum and other effects of fetchLast. */
     
  /* Refreshable off to prevent flashing while
     batches of rows are being retrieved. */
     BROWSE {&BROWSE-NAME}:REFRESHABLE = no.
  /* We need to set cLastEvent = "END" here so that when dataAvailable
     is published from fetchLast we can use this to determine whether
     end should be applied */
     ASSIGN cLastEvent = "END":U.
     {get QueryObject lQuery}.
     IF lQuery THEN 
       RUN fetchLast IN THIS-PROCEDURE.   
     ELSE DO:
       {get DataSource hSource}.
       IF VALID-HANDLE(hSource) THEN
         RUN fetchLast IN hSource.
     END.    /* END DO IF NOT lQuery   */
     BROWSE {&BROWSE-NAME}:REFRESHABLE = yes.
  END.   /* END IF NOT Reposition */
