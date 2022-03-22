/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ExpectedExceptionError
    Purpose     : Error raised when a test method expects a particular error, but
                  the error is not thrown from the test.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-12-15
    Notes       : - This has its own type so that the code in TestCase does
                    not confuse such errors with vanilla P.L.AppError per OCTA-41889
  ----------------------------------------------------------------------*/
using Progress.Lang.AppError.

block-level on error undo, throw.

class OpenEdge.ABLUnit.Runner.ExpectedExceptionError
serializable
inherits AppError:
    
    /* The expected error's type name */
    define public property Expected as character no-undo
        get.
        private set.
    
    /* Constructor
       
       @param character The expected error type name. */
    constructor public ExpectedExceptionError(input pExpected as character):
        super(substitute('No exception is raised but expecting &1', pExpected), 0).
        
        assign this-object:Expected = pExpected.
    end constructor.
    
end class.