/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* u-mcheck.p
*
*    An example file to provide the function interface that is expected by
*    Results. The Admin is going to provide this file, or a file like this,
*    when the Admin wishes to hook in their own menu sensitivity function
*
*    Results will call this file 1) at startup and 2) everytime after
*    a feature has completed its execution.
*
*    Results sends a list of features and expects state information
*    to be returned for each feature in the list. Results provides
*    corresponding lists for the state information.
*
*    This function will be used for Results features as well as Admin
*    defined features.
*
*    Results does not provide a Results core equivalent to this program.
*    If this  program is not hooked to Results, all Admin features will always
*    be available to the end user.
*
*    The Admin takes full responsibility for:
*        1. Changing the states of Results features.
*        2. Not to change the number of entries of the lists.
*
*    Use the Admin->Integration Procedures... menu to hook this function
*    into Results. In the dialog box choose "Menu Item Overide" and
*    change the codepath.
*
*    This function, if hooked in as is, will not change the state of any of
*    the features.
*
*  Input Parameters
*
*    featureList     - A comma seperated list of the features.
*
*  Input-Output Parameters
*
*    sensitivityList - A comma seperated list of "true" or "false". Each
*                      entry in this list corresponds
*
*    checkList       - A comma seperated list of "true" or "false". Thre
*                      is one entry for each feature, even if the feature
*                      is not currently represneted by a toggle on the menu.
*                      If the feature is not represented by a toggle then
*                      this value is not used by Results.
*/

DEFINE INPUT         PARAMETER featureList     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT  PARAMETER sensitivityList AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT  PARAMETER checkList       AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

DO qbf-i = 1 TO NUM-ENTRIES(featureList):

  /*
  * Change/augment the following code fragment ...
  *
  *    ENTRY(qbf-i, sensitivityList) = ....
  *    ENTRY(qbf-i, checkList) = ....
  */

END.

RETURN.

/* u-mcheck.p - end of file */

