/************************************************
Copyright (c) 2013-2014, 2019-2020 by Progress Software Corporation. All rights reserved.
*************************************************/   
 /*------------------------------------------------------------------------
    File        : TestTestResult
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Tue Aug 14 16:47:53 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Results.TestResultEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using Progress.Lang.AppError.
using Progress.Lang.LockConflict.

CLASS OpenEdge.ABLUnit.Results.TestTestResult:
    /* The result of this test run (test or lifecycle method) */
    DEFINE PUBLIC PROPERTY TestResult       AS TestResultEnum             NO-UNDO
        GET.
        SET(input pResult as TestResultEnum):
            if pResult eq TestResultEnum:StatusIgnored then
                assign this-object:Message = 'Ignored'.
            
            assign TestResult = pResult. 
        end set.
        
    DEFINE PUBLIC PROPERTY IsIncomplete     AS LOGICAL             NO-UNDO INIT FALSE GET. SET.
    DEFINE PUBLIC PROPERTY TestName         AS CHARACTER           NO-UNDO GET. SET.
    
    DEFINE PUBLIC PROPERTY Error    AS Progress.Lang.Error NO-UNDO
        GET.
        SET(input pError as Progress.Lang.Error):
            assign this-object:Error = pError.
            
            if valid-object(pError) then
            do:
                assign this-object:IsIncomplete = true.
                
                if type-of(pError, AssertionFailedError) then
                    assign this-object:TestResult   = TestResultEnum:StatusFailed
                           this-object:Message = cast(pError, AssertionFailedError):GetMessage()
                           .
                else
                    assign this-object:TestResult = TestResultEnum:StatusError.
                
                if     this-object:Message eq '':u 
                   and type-of(this-object:Error, AppError)
                then
                    assign this-object:Message = cast(this-object:Error, AppError):ReturnValue.
                
                if     this-object:Message eq '':u 
                   and this-object:Error:NumMessages ge 1
                then
                    assign this-object:Message = this-object:Error:GetMessage(1). 
            end.
        end set.
    
    /*  A stop condition raised by the test */ 
    define public property Stop as Progress.Lang.Stop no-undo
        get.
        set(input pStop as Progress.Lang.Stop):
            assign this-object:Stop = pStop.
            
            if valid-object(pStop) then
            do:
                assign this-object:IsIncomplete = true
                       this-object:TestResult   = TestResultEnum:StatusError
                       .
                if this-object:Message eq '':u then
                    if type-of(this-object:Stop, LockConflict) then
                        assign this-object:Message = substitute('Lock conflict raised: user:&1 ; tablename:&2 ; device:&3',
                                                            cast(this-object:Stop, LockConflict):User,
                                                            cast(this-object:Stop, LockConflict):TableName,
                                                            cast(this-object:Stop, LockConflict):Device). 
                    else
                        assign this-object:Message = 'Stop condition raised'. 
            end.
        end set.
    
    /* A message associated with the test result (could be for an error, stop or other status) */
    define public property Message as character no-undo
        get.
        set.
    
    /* Default constructor */
    constructor public TestTestResult():
        assign this-object:TestResult = TestResultEnum:StatusNotStarted.
    end constructor.
    
    /* Constructor
       
       @param character The test name */
    constructor public TestTestResult(input pName as character):
        this-object().
        
        Assert:NotNull(pName, 'Test name').
        assign this-object:TestName = pName.
    end constructor.
    
END CLASS.