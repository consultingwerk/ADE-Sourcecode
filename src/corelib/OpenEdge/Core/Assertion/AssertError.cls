 /************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : AssertError
    Purpose     : Assertions specific to error messages
    Syntax      : 
    Description : 
    Author(s)   : psajja
    Created     : Tue Dec 16 12:30:23 IST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.

class OpenEdge.Core.Assertion.AssertError: 

    /** Asserts that last executed statement raised an error message.
        
        @throws AssertionFailedError Error thrown if no error message exists */
    method public static void HasErrorMessage():
        if error-status:num-messages eq 0 then
             undo, throw new AssertionFailedError('Error message must exist.', 0).
    end method.
    
    /** Asserts that last executed statement raised no error message.
        
        @throws AssertionFailedError Error thrown if error message exists */
    method public static void NoErrorMessage():
        if error-status:num-messages > 0 then
             undo, throw new AssertionFailedError('Error message must not exist.', 0).
    end method.
    
    /** Asserts that last executed statement raised an error.
        
        @throws AssertionFailedError Error thrown if no error exists */
    method public static void HasErrorStatus():
        if not error-status:error then
             undo, throw new AssertionFailedError('Error must exist.', 0).
    end method.
    
    /** Asserts that last executed statement raised no error.
        
        @throws AssertionFailedError Error thrown if error exists */
    method public static void NoErrorStatus():
        if error-status:error then
             undo, throw new AssertionFailedError('Error must not exist.', 0).
    end method.
end class.