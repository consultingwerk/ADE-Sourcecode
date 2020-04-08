/************************************************
Copyright (c) 2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TestAnnotationInfo
    Purpose     : Stores the information related to the Before, Setup, Test, TearDown, After annotations 
                  for an individual test (class or procedure).in
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2019-12-05
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Reflection.ITestInfoList.
using OpenEdge.ABLUnit.Reflection.TestInfoList.

class OpenEdge.ABLUnit.Reflection.TestAnnotationInfo:
    /* A list of methods/procedures to run before any tests have run */
    define public property BeforeAll as ITestInfoList no-undo
        get.
        private set.
    
    /* A list of methods/procedures to run before each test */
    define public property BeforeEach as ITestInfoList no-undo
        get.
        private set.
    
    /* A list of methods/procedures to run after each test */
    define public property AfterEach as ITestInfoList no-undo
        get.
        private set.
    
    /* A list of methods/procedures to after all tests have run */
    define public property AfterAll as ITestInfoList no-undo
        get.
        private set.
    
    /* A list of tests to run */
    define public property Tests as ITestInfoList no-undo
        get.
        private set.
    
    /* Default constructor */
    constructor public TestAnnotationInfo():
        assign BeforeAll  = new TestInfoList()
               BeforeEach = new TestInfoList()
               Tests      = new TestInfoList()
               AfterEach  = new TestInfoList()
               AfterAll   = new TestInfoList()
               .
    end constructor.
    
end class.