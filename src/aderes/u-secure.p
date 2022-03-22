/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
*  u-secure
*
*    This function decides which features the user has access.
*
*  Input Parameter
*
*    featureList The list of features that Results currently knows about.
*
*    userName    The current user of Results.
*
*  Input-Output Parameter
*
*    canUseList  A comma seperated list. Each entry in this list
*                corresponds to the identical entry in featureList.
*                Return "true" if you want the user to have access to
*                the feature, "false" if not. Note that these are the
*                character strings "true" and "false" and not the
*                logical values.
*/


DEFINE INPUT        PARAMETER featureList AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER userName    AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER canUseList  AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

/* Move through the list.  */
DO qbf-i = 1 TO NUM-ENTRIES(featureList):

  /*
  * Your code goes here...
  */

  IF ENTRY(qbf-i,featureList) = "AboutResults":u THEN
    ENTRY(qbf-i, canUseList) = "false":u.
END.

RETURN.

/* u-secure.p - end of file */

