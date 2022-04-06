/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

