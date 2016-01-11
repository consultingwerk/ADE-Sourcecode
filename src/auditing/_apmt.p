/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: _apmt.p

  Description: Calls the APMT main procedure. Called from the ADE tools. 
               Note that one can't call this from within the Procedure
               Editor, since the code in the Procedure Editor will delete
               any persistent procedure which is not part of the ADE tools.
               
               
  Input Parameters:
       <none>

  Output Parameters:
      <none>

  Author: 

  Created: Feb 25,2005
  
  Modified by: 
------------------------------------------------------------------------*/

DEFINE VARIABLE hdl            AS WIDGET  NO-UNDO.

RUN adecomm/_setcurs.p ("WAIT":U).

RUN auditing/_auditmainw.w PERSISTENT SET hdl.

SETUP-BLOCK:
DO ON ERROR UNDO SETUP-BLOCK, RETRY SETUP-BLOCK:
  /* If there is a RETRY, then there was an error setting up the procedure
     In this case, just delete the procedure. */
  IF RETRY THEN DO:
     RUN destroyObject IN hdl NO-ERROR.
     RUN adecomm/_setcurs.p ("":U).
     RETURN.
  END.

  /* let's bring up the window now */
  IF VALID-HANDLE(hdl) THEN
     RUN initializeObject IN hdl.
END.

/* we are done now */
RUN adecomm/_setcurs.p ("":U).
