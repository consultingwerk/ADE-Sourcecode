/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   File        : AssertionFailedError
   Purpose     : The exception thrown when an assertion fails. 
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Wed Jul 18 16:10:35 IST 2012
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.


ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.Core.AssertionFailedError INHERITS Progress.Lang.AppError: 
    DEFINE VARIABLE exceptionMessage AS CHARACTER NO-UNDO.    
		
    CONSTRUCTOR PUBLIC AssertionFailedError (INPUT failMessage AS CHARACTER ):
        SUPER(failMessage).
        exceptionMessage = failMessage.
    END CONSTRUCTOR.
    
    CONSTRUCTOR PUBLIC AssertionFailedError (INPUT failMessage AS CHARACTER, INPUT val AS INTEGER):
        SUPER(failMessage, val).
        exceptionMessage = failMessage.
    END CONSTRUCTOR.


    METHOD PUBLIC CHARACTER GetMessage(  ):
        RETURN exceptionMessage.
    END METHOD.
    
END CLASS.