/************************************************
Copyright (c)  2013-2016, 2020, 2024 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : TestTypeResult
   Purpose     :
   Syntax      :
   Description :
   Author(s)   : hgarapat
   Created     : Tue Aug 14 16:43:04 IST 2012
   Notes       : class that stores the test results (TestTestResult) for each of its methods similarly for procedure for each of its internal procs
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Results.TestResultEnum.
using OpenEdge.ABLUnit.Results.TestTestResult.
using OpenEdge.ABLUnit.Results.TestTypeResult.

class OpenEdge.ABLUnit.Results.TestTypeResult:

    /* The number of tests (independent of the other counts).
       A single test may have more than one failure associated with it (eg the 'after each' methods fail). */
    define public property TestCount as integer no-undo initial 0
        get():
            // Always return the combined results as the test count.
            return successCount + failureCount + errorCount + ignoreCount.
        end get.
        set.

    define public property successCount as integer no-undo init 0 get. set.
    define public property failureCount as integer no-undo init 0 get. set.
    define public property errorCount   as integer no-undo init 0 get. set.
    define public property ignoreCount  as integer no-undo init 0 get. set.

    /*
    Returns all the test methods for a particular test class
    */
    method public integer GetTestCount ( ):
        return this-object:TestCount.
    end method.

    // These Increment*() methods provide consistent math operations for the respective result type.
    method public void IncrementSuccess ( ):
        this-object:successCount += 1.
        return.
    end method.

    method public void IncrementFailure ( ):
        this-object:failureCount += 1.
        return.
    end method.

    method public void IncrementError ( ):
        this-object:errorCount += 1.
        return.
    end method.

    method public void IncrementIgnore ( ):
        this-object:ignoreCount += 1.
        return.
    end method.

    // These Get*Count*() methods are deprecated since the members are now PROPERTIES instead of
    // private variables. There are public getter and setter methods and so no reason not to make them properties
    @deprecated(since="13.0.0").
    method public integer GetSuccessCount ( ):
        return this-object:successCount.
    end method.

    @deprecated(since="13.0.0").
    method public integer GetFailureCount ( ):
        return this-object:failureCount.
    end method.

    @deprecated(since="13.0.0").
    method public integer GetErrorCount ( ):
        return this-object:errorCount.
    end method.

    @deprecated(since="13.0.0").
    method public integer GetIgnoreCount ( ):
        return this-object:ignoreCount.
    end method.

    /* Adds a child result to this result

       @param TestTypeResult The child/additive result */
    method public void Add(input pValue as TestTypeResult):
        if valid-object(pValue) then
            assign
                this-object:successCount = this-object:successCount + pValue:successCount
                this-object:errorCount   = this-object:errorCount   + pValue:errorCount
                this-object:failureCount = this-object:failureCount + pValue:failureCount
                this-object:ignoreCount  = this-object:ignoreCount  + pValue:ignoreCount
                this-object:TestCount    = this-object:TestCount    + pValue:TestCount
                .
    end method.

    /* Increments the relevant counter for a test result

       @param TestTestResult The input result  */
    method public void Add(input pResult as TestTestResult):
        if valid-object(pResult) then
            case pResult:TestResult:
                when TestResultEnum:StatusError   then  
                    this-object:IncrementError().
                when TestResultEnum:StatusFailed  then 
                    this-object:IncrementFailure().
                when TestResultEnum:StatusIgnored then 
                    this-object:IncrementIgnore().
                otherwise                              
                    this-object:IncrementSuccess().
            end case.
    end method.

end class.