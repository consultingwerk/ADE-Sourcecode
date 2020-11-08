/************************************************
Copyright (c) 2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : TestCase
    Purpose     : A TestEntity that is capable of running test classes and procedures,
                  their lifecycle methods and their test methods
    Author(s)   : pjudge
    Created     : 2019-12-09
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Model.IRunnableEntity.
using OpenEdge.ABLUnit.Model.TestCase.
using OpenEdge.ABLUnit.Model.TestEntity.
using OpenEdge.ABLUnit.Model.TestMethod.
using OpenEdge.ABLUnit.Reflection.AnnotationInfo.
using OpenEdge.ABLUnit.Reflection.AnnotationUtil.
using OpenEdge.ABLUnit.Reflection.ITestInfoList.
using OpenEdge.ABLUnit.Reflection.TestAnnotationInfo.
using OpenEdge.ABLUnit.Reflection.TestInfo.
using OpenEdge.ABLUnit.Results.TestResultEnum.
using OpenEdge.ABLUnit.Results.TestTestResult.
using Progress.Lang.AppError.

class OpenEdge.ABLUnit.Model.TestCase abstract inherits TestEntity
                    implements IRunnableEntity:
    
    /* The current object being tested */
    define public property Entity as Progress.Lang.Object no-undo
        get.
        protected set.
    
    /* Annotations relating to this runnable entity. This contains info about the lifecycle methods */
    define public property AnnotationInfo as TestAnnotationInfo no-undo
        get.
        set.
    
    /* Constructor
       
       @param integer The id of the test entity */
    constructor public TestCase (input id1 as integer):
        super (input id1).
    end constructor.
    
    /* Runs a child test entity in the test entity.
       
       @param TestEntity The test method to run */
    method public void RunChild(input pChild as TestEntity):
        define variable ti as TestInfo no-undo.
        define variable expectedException as character no-undo.
        define variable expectedErrNum as integer no-undo.
        define variable annotEntry as character no-undo.
        define variable hasErrNumAttrib as logical no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable startTime as datetime no-undo.
        define variable tr as TestTestResult no-undo.
        
        if not valid-object(this-object:Entity) then
            // don't use Assert() because this state is a 'real error' not a test failure
            return error new AppError(substitute('Test instance &1 is invalid', this-object:name), 0).
        
        if not type-of(pChild, TestMethod) then
            return.
        
        assign ti = cast(pChild, TestMethod):getTestInfo()
               tr = new TestTestResult(ti:TestName)
               .
        // Check whether the test method is ignored
        if AnnotationUtil:HasIgnoreAnnotation(ti:annotations) then
        do:
            assign tr:TestResult    = TestResultEnum:StatusIgnored
                   pChild:timeTaken = 0
                   .
            pChild:AddTestResult(tr).
            return.
        end.
        
        assign startTime = now.
        
        // Run all @Setup methods
        RunLifecycleMethods(AnnotationInfo:BeforeEach, pChild, false).
        
        assign expectedException = AnnotationUtil:GetExpectedExceptionName(ti:annotations)
               hasErrNumAttrib   = no
               cnt               = num-entries(expectedException)
               .
        // We know there's at least an 'expected' here, so if there's only 1 then move along.
        if cnt ge 2 then
        do loop = 1 to cnt
        while not hasErrNumAttrib:
            assign annotEntry = trim(entry(loop, expectedException)). 
            if annotEntry begins 'errNum':u then
                assign expectedErrNum  = integer(entry(2, annotEntry, '=':u))
                       hasErrNumAttrib = yes
                       .
        end.
        
        // Get a fully-qualified OOABL type reference  
        assign expectedException = GetExpectedErrorType(trim(entry(1, expectedException))).
        
        // run the test. this block catches an uncaught STOPs and any other thrown errors
        do on stop undo, retry:
            if retry then
            do:
                // this should be dealt with as an unxpected error
                assign expectedException = '':u.
                undo, throw new AppError(substitute('Stop condition raised for &1', tr:TestName), 0).
            end.
            
            // block to catch any Stop conditions if -catchStop=1
            do on error undo, throw:
                // run the test
                InvokeTestMethod(ti).
                
                // we were expecting failure here
                if not expectedException eq '':u then
                    undo, throw new Progress.Lang.AppError(substitute('No exception is raised but expecting &1', expectedException), 0).
                //success!
                assign tr:IsIncomplete = false
                       tr:TestResult   = TestResultEnum:StatusPassed
                       .
                // if -catchStop=1 then this code applies, otherwise use IF RETRY code of the surrounding block
                catch stoi as Progress.Lang.Stop:
                    if expectedException eq '':u then
                        assign tr:Stop = stoi.
                    else
                    if stoi:GetClass():IsA(expectedException) then
                        assign tr:TestResult = TestResultEnum:StatusPassed.
                    else
                        assign tr:Stop    = stoi
                               tr:Message = substitute('Expecting:&1 but found:&2',
                                                       expectedException, stoi:GetClass():TypeName).
                end catch.
            end.    // ON ERROR UNDO, THROW block
            
            catch runErr as Progress.Lang.Error:
                if expectedException eq '':u then
                    assign tr:Error = runErr.
                else
                if runErr:GetClass():IsA(expectedException) then
                do:
                    if not hasErrNumAttrib
                    or runErr:GetMessageNum(1) eq expectedErrNum
                    then
                        assign tr:TestResult = TestResultEnum:StatusPassed.
                    else
                        assign tr:Error   = runErr
                               tr:Message = substitute('Expecting:&1(&2) but found:&1(&3)',
                                                            runErr:GetClass():TypeName,
                                                            expectedErrNum, runErr:GetMessageNum(1)).
                end.
                else
                    assign tr:Error   = runErr
                           tr:Message = substitute('Expecting:&1 but found:&2',
                                                   expectedException, runErr:GetClass():TypeName).
            end catch.
        end.    // ON-STOP-RETRY block
        
        // Add the result of the testmethod run
        pChild:AddTestResult(tr).
        
        // run the @Teardown (after-each) methods
        RunLifecycleMethods(AnnotationInfo:AfterEach, pChild, false).
        
        assign pChild:timeTaken = interval(now, startTime, 'milliseconds':u) / 1000.
    end method.
    
    /* Runs/starts the test entity 
       This method adds a TestResult iff there's an error or failure. */
    method public void StartEntity():
        define variable tr as TestTestResult no-undo.
        
        // Start with the number of tests  (methods) in this runnable entity. We will add any failures to it
        // Make sure we use the number of tests to run (the children) rather than the annotated number of tests
        assign this-object:Summary:TestCount = this-object:getChildrenSize().
        
        do on stop undo, retry:
            if retry then
                undo, throw new AppError(substitute('Stop condition raised for &1', this-object:name), 0).
            
            do on error undo, throw:
                // run the test class
                InstantiateEntity().
                // if -catchStop=1 then this code applies, otherwise use IF RETRY code of the surrounding block
                catch stoi as Progress.Lang.Stop:
                    assign tr                = new TestTestResult(this-object:name)
                           tr:Stop           = stoi
                           Summary:TestCount = Summary:TestCount + 1
                           .
                    this-object:AddTestResult(tr).
                    return.
                end catch.
            end.
            // We don't care about the successly running of the test entity, only
            // failures and errors; those are added in the catch and/or stop blocks
            RunLifecycleMethods(AnnotationInfo:BeforeAll, this-object, true).
        end.    // STOP-RETRY block
        
        // failure to run
        catch runErr as Progress.Lang.Error:
            assign tr                = new TestTestResult(this-object:name)
                   tr:Error          = runErr
                   Summary:TestCount = Summary:TestCount + 1
                   .
            this-object:AddTestResult(tr).
        end catch.
    end method.
    
    /* Stops/destroys the test entity */
    method public void StopEntity():
        define variable tr as TestTestResult no-undo.
        
        if not valid-object(this-object:Entity) then
            return.
        
        do on stop undo, retry:
            if retry then
                undo, throw new AppError(substitute('Stop condition raised for &1', this-object:name), 0).
            
            // Run any @After methods
            RunLifecycleMethods(AnnotationInfo:AfterAll, this-object, true).
            
            do on error undo, throw:
                DestroyEntity().
                // if -catchStop=1 then this code applies, otherwise use IF RETRY code of the surrounding block
                catch stoi as Progress.Lang.Stop:
                    assign tr      = new TestTestResult(this-object:name)
                           tr:Stop = stoi
                           Summary:TestCount = Summary:TestCount + 1
                           .
                end catch.
            end.
        end.
        
        // failure to destroy
        catch runErr as Progress.Lang.Error:
            assign tr                = new TestTestResult(this-object:name)
                   tr:Error          = runErr
                   Summary:TestCount = Summary:TestCount + 1
                   .
        end catch.
        finally:
            // if there isn't a TestTestResult, this method is a no-op
            this-object:AddTestResult(tr).
        end finally.
    end method.
    
    /* Performs the invocation of the test method in this test entity
       @param TestInfo Data about the method to run */
    method abstract protected void InvokeTestMethod(input pMethodInfo as TestInfo).
    
    /* Runs/new's this test entity */
    method abstract protected void InstantiateEntity().
    
    /* Stops/destroys this test entity */
    method abstract protected void DestroyEntity().
    
    /* Runs the lifecycle methods for a given annotation.
       
       All lifecycle methods are run, even if one fails.
       
       @param ITestInfoList     The list of lifecycle methods
       @param TestEntity  The test for which the lifecycle methods were run (class/procedure/method)
       @param logical If TRUE then a failure will increment the number of test in the entity's summary; if FALSE 
                      or UNKNOWN the number of tests is not changed */
    method protected void RunLifecycleMethods(input pMethods as ITestInfoList,
                                              input pEntity as TestEntity,
                                              input pIncrementTestOnFailure as logical):
        define variable lifecycleMethod as TestInfo no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable tr as TestTestResult no-undo.
        
        if not valid-object(this-object:Entity) then
            // don't use Assert() because this state is a 'real error' not a test failure
            return error new AppError(substitute('Test instance &1 is invalid', this-object:name), 0).
        
        if    not valid-object(pMethods)
           or pMethods:Size eq 0
        then
            return.
        
        assign cnt = pMethods:Size.
        LIFECYCLE-METHOD-RUN:
        do loop = 1 to cnt
        on stop undo, retry:
            if retry then
                undo, throw new AppError(substitute('Stop condition raised for &1', lifecycleMethod:testName), 0).
            
            do on error undo, throw:
                assign lifecycleMethod = cast(pMethods:Get(loop), TestInfo)
                       tr              = new TestTestResult(lifecycleMethod:testName)
                       .
                if valid-object(lifecycleMethod) then
                    // runit
                    InvokeTestMethod(lifecycleMethod).
                
                // if -catchStop=1 then this code applies, otherwise use IF RETRY code of the surrounding block
                catch stoi as Progress.Lang.Stop:
                    assign tr:Stop = stoi.
                    // explicitly go to the next iteration of the loop 
                    next LIFECYCLE-METHOD-RUN.
                end catch.
            end.    // ERROR UNDO block
            
            assign tr:TestResult = TestResultEnum:StatusPassed.
            
            //failure
            catch runErr as Progress.Lang.Error:
                assign tr:Error = runErr.
                // explicitly go to the next iteration of the loop 
                next LIFECYCLE-METHOD-RUN.
            end catch.
            finally:
                if valid-object(tr) then
                case tr:TestResult:
                    when TestResultEnum:StatusError  or
                    when TestResultEnum:StatusFailed then
                    do:
                        pEntity:AddTestResult(tr).
                        // add failures as 'tests'
                        if pIncrementTestOnFailure eq true then
                            assign pEntity:Summary:TestCount = pEntity:Summary:TestCount + 1.
                    end.
                end case.
            end finally.
        end.    // STOP-RETRY block
    end method.
    
    /* Expands the given expected error type if it is a recognised abbreviation.
       
       @param character An abbreviated OOABL (error) type
       @return character A 'resolved' error type */
    method protected character GetExpectedErrorType(input pShortError as character):
        case pShortError:
            when ? then
                return '':u.
            
            when 'Error':u          or
            when 'AppError':u       or
            when 'ProError':u       or
            when 'SoapFaultError':u or
            when 'Stop':u           or
            when 'SysError':u       then
                return 'Progress.Lang.':u + pShortError.
            
            when 'Quit':u then
                return get-class(Progress.Lang.SysError):TypeName.
            
            otherwise 
                return pShortError.
        end case.
    end method.
    
end class.