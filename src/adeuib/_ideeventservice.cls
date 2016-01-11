 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _ideeventservice
    Purpose     : Services events through ide 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Jan 28 16:00:26 EST 2012
     Notes      : in this form this is almost unneccesary as we could
                  have just used the procedure handle, but
                  this allows us to use the same mechanism for the more
                  advanced dialog service that keeps track of  buttons nad
                  frame 
                   
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib.iideeventservice.

routine-level on error undo, throw.

class adeuib._ideeventservice implements iideeventservice: 
	
	define protected property ProcedureHandle as handle no-undo 
        get. 
        protected set.  
	
	define protected property ProcedureMethod as char no-undo 
        get. 
        protected set.  
        
    define protected property UserEventNum as char no-undo 
        init 3
        get. 
        set.  
        
    constructor public _ideeventservice ( ):
        super ().
    end constructor.
    
    method public void RunEvent():
        run value(ProcedureMethod) in ProcedureHandle.
    end method.    
    
    method public void SetCurrentEvent(phHandle as handle,pevent as char).
        ProcedureHandle = phHandle.
        ProcedureMethod = pEvent.
    end method.
     
 end class.