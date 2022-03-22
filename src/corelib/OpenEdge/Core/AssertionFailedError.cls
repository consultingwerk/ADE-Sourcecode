/************************************************
Copyright (c) 2014, 2017, 2021 by Progress Software Corporation. All rights reserved.
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
BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.Core.AssertionFailedError INHERITS Progress.Lang.AppError serializable: 
    DEFINE VARIABLE exceptionMessage AS CHARACTER NO-UNDO.    
	
    CONSTRUCTOR PUBLIC AssertionFailedError (INPUT failMessage as LONGCHAR):
        {&_proparse_ prolint-nowarn(overflow)}
        THIS-OBJECT(STRING(failMessage), 0).
    END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC AssertionFailedError (INPUT failMessage as LONGCHAR, INPUT val AS INTEGER):
        {&_proparse_ prolint-nowarn(overflow)}
        THIS-OBJECT(STRING(failMessage), val).
    END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC AssertionFailedError (INPUT failMessage AS CHARACTER):
        THIS-OBJECT(failMessage, 0).
    END CONSTRUCTOR.
    
    CONSTRUCTOR PUBLIC AssertionFailedError (INPUT failMessage AS CHARACTER, INPUT val AS INTEGER):
        SUPER(failMessage, val).
        exceptionMessage = failMessage.
    END CONSTRUCTOR.
    
    METHOD PUBLIC CHARACTER GetMessage():
        RETURN exceptionMessage.
    END METHOD.
    
END CLASS.