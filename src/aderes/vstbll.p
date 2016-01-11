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
* _vstbll.p
*
*   shared Variable Set Table List.
*
*      Sets the tables that are to be part of a view. This function
*      will only set the table list if the tables list is currently
*      empty.
*
*      All the tables that are to be part of the view must provided
*      in this call.
*
*      If any of the tables in the table list do not exist then the
*      table list will not be set.
*
*  input parameter
*
*     tableList - A comma-separated list of the tables. In the order
*                 in which they have been added to the view.
*/

{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE INPUT  PARAMETER tableList AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER lRet      AS LOGICAL   NO-UNDO INITIAL FALSE.

/* If there are any tables then go away. */
IF NUM-ENTRIES(qbf-tables) > 0 THEN RETURN.

DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO.
DEFINE VARIABLE lookAhead AS CHARACTER NO-UNDO INITIAL "".

/*
* The table list is comma-sep list of character numbers. These numbers
* represent the index of the table.
*/
DO qbf-i = 1 TO NUM-ENTRIES(tableList):

  /*
  * Check each name provided by the application. If any name in the
  * applications's list isn't in our list then clean up and go away.
  */
  {&FIND_TABLE_BY_NAME} ENTRY(qbf-i, tableList) NO-ERROR.
  IF AVAILABLE qbf-rel-buf THEN 
    ASSIGN
      qbf-tables = qbf-tables + lookAhead + STRING(qbf-rel-buf.tid)
      lookAhead  = ",":u
      .
  ELSE DO:
    /* Cleanup and go away */
    RUN aderes/s-zap.p (FALSE).
    RETURN.
  END.
END.

lRet = TRUE.

/* vstbll.p - end of file */

