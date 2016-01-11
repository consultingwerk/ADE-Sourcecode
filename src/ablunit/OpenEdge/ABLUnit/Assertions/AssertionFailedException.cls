 
/*------------------------------------------------------------------------
   File        : AssertionFailedException
   Purpose     : The exception thrown when an assertion fails. 
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Wed Jul 18 16:10:35 IST 2012
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.


routine-level on error undo, throw.

class OpenEdge.ABLUnit.Assertions.AssertionFailedException inherits Progress.Lang.AppError: 
    define variable exceptionMessage as character no-undo.    
		
    constructor public AssertionFailedException (input failMessage as character ):
        super(failMessage).
        exceptionMessage = failMessage.
    end constructor.


    method public character GetMessage(  ):
        return exceptionMessage.
    end method.
    
end class.