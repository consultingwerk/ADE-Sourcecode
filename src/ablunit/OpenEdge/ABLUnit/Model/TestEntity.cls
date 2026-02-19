/************************************************
Copyright (c) 2013, 2019-2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : TestEntity
   Purpose     :
   Syntax      :
   Description :
   Author(s)   : svutla
   Created     : Wed Sep 18 11:54:23 IST 2013
   Notes       :
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Model.TestEntity.
using OpenEdge.ABLUnit.Results.TestResultList.
using OpenEdge.ABLUnit.Results.TestTestResult.
using OpenEdge.ABLUnit.Results.TestTypeResult.
using OpenEdge.Core.Collections.Array.

class OpenEdge.ABLUnit.Model.TestEntity:

    define public property Name as character no-undo get. set.
    define public property id as integer no-undo get. set.
    define public property timeTaken as decimal no-undo get. set.

    // A single TestEntity may have multiple results because of lifecycle methods' failures
    define private variable mResultList as TestResultList no-undo.

    /* Summary for all the tests in this test entity. Even if this is a TestMethod, there may be BeforeEach and/or AfterEach lifecycle methods
       that run and fail, and we should record that information */
    define public property Summary as TestTypeResult no-undo
        get.
        protected set.

    define private variable testEntities as Array no-undo.

    /* Constructor
       @param integer The test ID */
    constructor public TestEntity (input id1 as integer):
        super ().
        assign
            testEntities            = new Array()
            testEntities:AutoExpand = true
            id                      = id1
            mResultList             = new TestResultList()
            .
        if not valid-object(this-object:Summary) then
            assign Summary = new TestTypeResult().
    end constructor.

    method public Array getTestEntities():
        return testEntities.
    end method.

    method public integer getChildrenSize():
        return testEntities:Size.
    end method.

    method public void addTestEntity( input testEntity as TestEntity ):
        testEntities:Add(testEntity).
        return.
    end method.

    /* Adds a test result for this entity.

       NOTE: This method increments the Summary's counts so only call it AFTER the
       result is updated/complete

       Entities like a method or a class/procedure may have one or more before- and after-
       lifecycle methods in addition to the 'main' or test method.

       @param TestTestResult The current result */
    method public void AddTestResult(input pResult as TestTestResult):
        mResultList:Add(pResult).
        // update the summary too
        this-object:Summary:Add(pResult).
    end method.

    /* Returns an array of test results for this entity

       @return TestTestResult[] The results for this entity. May be indeterminate */
    method public TestTestResult extent GetTestResults():
        return cast(mResultList:ToArray(), TestTestResult).
    end method.

end class.