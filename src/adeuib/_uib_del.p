/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _uib_del.p

  Description:
     Code to allow developers to delete objects in the UIB.
     
  Input Parameter:
     pi_context - The integer context (i.e. recid) of the object to delete.
                  [There is no default value for this.  You must pass a 
                  valid object ID.]
                  
                  This value is the same value returned by adeuib/_uibinfo.p.
                 
  Output Parameters:
    <none>
    
  Return Values:
     This procedure RETURNS:
       "Error" if pi_context does not point to a valid object.
       "Fail"  if the object was not deleted. (There is no known way this
               would ever happen.)
                      
  Author: Wm. T. Wood
  
  Created: February 1995
  
-----------------------------------------------------------------------------*/
/* Define Parameters. */
DEFINE INPUT        PARAMETER  pi_context   AS INTEGER NO-UNDO.

/* Include Files */
{adeuib/uniwidg.i}   /* Definition of Universal Widget TEMP-TABLE  */

/* Other Shared Variables */
define shared variable _h_UIB as handle no-undo.

/* Make sure the widget (pi_context) is valid */
FIND _U WHERE RECID(_U) eq pi_context NO-ERROR.
IF NOT AVAILABLE _U THEN DO:
  MESSAGE "[{&FILE-NAME}]" SKIP
          "Cannot find valid object with ID:" 
           pi_context
           VIEW-AS ALERT-BOX ERROR.
    RETURN "Error". 
END.
ELSE DO:
  /* Delete the widget */
  RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT yes /* Trash _U records */ ).
  /* Did the deletion fail? */
  IF AVAILABLE _U THEN RETURN "Fail".
  /* Send a request to the UIB to check that the deleted object is not used
     as the current widget, or in the Section Editor. */
  RUN del_cur_widg_check IN _h_UIB.
END. 
