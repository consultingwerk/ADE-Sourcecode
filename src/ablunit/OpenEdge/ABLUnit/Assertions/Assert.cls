
 /*------------------------------------------------------------------------
    File        : Assert
    Purpose     : A set of assertion methods for use in test methods. If an 
                  assertion fails, an AssertionFailedException is thrown. Messages 
                  are only recorded when an assertion fails.
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Fri Jun 29 16:30:27 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.ABLUnit.Assertions.*.



class OpenEdge.ABLUnit.Assertions.Assert: 

	method public static void AssertEquals(input a as Progress.Lang.Object, input b as Progress.Lang.Object):
        define variable failMessage as character NO-UNDO.
        if not a:Equals(b) then
        do:
            failMessage = "Expected: " + string(a) + " but was: " + string(b).
            return error new AssertionFailedException(failMessage).
        end.		
        
	end method.

    method public static void AssertEquals(input a as integer, input b as integer):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
             failMessage = "Expected: " + string(a) + " but was: " + string(b).
             return error new AssertionFailedException(failMessage).
        end.
                
    end method.

    method public static void AssertEquals(input a as character, input b as character):
        define variable failMessage as character no-undo.
        if not a eq b then
        do:
            failMessage = "Expected: " + string(a) + " but was: " + string(b).
            return error new AssertionFailedException(failMessage).
        end.
    end method.


	method public static void AssertTrue(input a as logical):
		define variable failMessage as character no-undo.
		if not a then
		  do:
            failMessage = "Expected: TRUE but was: FALSE".
            return error new AssertionFailedException(failMessage).
        end.        

	end method.


    method public static void AssertFalse(input a as logical):
        define variable failMessage as character no-undo.
        if a then
        do:
            failMessage = "Expected: FALSE but was: TRUE".
            return error new AssertionFailedException(failMessage).
        end.        
    end method.
    
end class.