/************************************************
Copyright (c) 2013-2016, 2019-2020 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   File        : ClassAnnotationInfo
   Purpose     : Stores the information related to the Before, Setup, Test, TearDown, After annotations in
                 the test class.   
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Mon Jul 23 11:21:50 IST 2012
   Notes       : * The TestClass class contains the code to run the test and lifecycle methods
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Reflection.TestAnnotationInfo.
using OpenEdge.ABLUnit.Reflection.TestInfo.

class OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo inherits TestAnnotationInfo: 
    /* default constructor */
    constructor public ClassAnnotationInfo ():
        super ().
    end constructor.
        
    method public void setBeforeClass(input bClass as TestInfo):
        if valid-object(bClass) then
            BeforeAll:Add(bClass).
    end method.
    
    method public void setAfterClass(input aClass as TestInfo):
        if valid-object(aClass) then
            AfterAll:Add(aClass).
    end method.
    
    method public void setBeforeMethod(input bMethod as TestInfo):
        if valid-object(bMethod) then
            BeforeEach:Add(bMethod).
    end method.
    
    method public void setAfterMethod(input aMethod as TestInfo):
        if valid-object(aMethod) then
            AfterEach:Add(aMethod).
    end method.
    
    method public void AddTestMethod(input tMethod as TestInfo):
        if valid-object(tMethod) then
            Tests:Add(tMethod).
    end method.
   
end class.