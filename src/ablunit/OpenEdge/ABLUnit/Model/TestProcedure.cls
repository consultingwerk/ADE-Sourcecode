/************************************************
Copyright (c) 2013-2014, 2019-2020 by Progress Software Corporation. All rights reserved.
*************************************************/  
 /*------------------------------------------------------------------------
    File        : TestProcedure
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Fri Sep 20 22:47:19 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
BLOCK-LEVEL ON ERROR UNDO, THROW.

using Ccs.Common.Support.IHandleHolder.
using OpenEdge.ABLUnit.Reflection.TestInfo.
using OpenEdge.Core.WidgetHandle.
using Progress.Lang.AppError.
using OpenEdge.ABLUnit.Model.TestCase.

CLASS OpenEdge.ABLUnit.Model.TestProcedure INHERITS TestCase:
    
    /* Constructor 
      
       @param integer The ID of this test entity */
    CONSTRUCTOR PUBLIC TestProcedure ( INPUT id1 AS INTEGER ):
        SUPER (INPUT id1).
    END CONSTRUCTOR.
    
    /* Runs the Test (class or procedure)
       
       @return void The result of running the test */
    /* Runs/new's this test entity */
    method override protected void InstantiateEntity():
        define variable hInstance as handle no-undo.
        
        // run the test class
        run value(this-object:Name) persistent set hInstance.
        
        assign this-object:Entity = new WidgetHandle(hInstance, true).
    end method.
    
    /* Stops/destroys this test entity */
    method override protected void DestroyEntity():
        define variable hInstance as handle no-undo.
        
        if     valid-object(Entity)
           and type-of(Entity, IHandleHolder)
        then
            assign hInstance = cast(Entity, IHandleHolder):Value. 
        
        if valid-handle(hInstance) then
        do:
            apply 'close':u to hInstance.
            assign this-object:Entity = ?.
        end.
    end method.
    
    /* Performs the invocation of the test method in this test entity
       @param TestInfo Data about the method to run */
    method override protected void InvokeTestMethod(input pMethodInfo as TestInfo):
        define variable hInstance as handle no-undo.
        
        if     valid-object(Entity)
           and type-of(Entity, IHandleHolder)
        then
            assign hInstance = cast(Entity, IHandleHolder):Value. 
        
        if not valid-object(pMethodInfo) then
            // don't use Assert() because this state is a 'real error' not a test failure
            return error new AppError('Test method info is invalid', 0).
        
        if not valid-handle(hInstance) then
            // don't use Assert() because this state is a 'real error' not a test failure
            return error new AppError('Test instance is invalid', 0).
        
        if hInstance:get-signature(pMethodInfo:TestName) eq '':u then
            // don't use Assert() because this state is a 'real error' not a test failure
            return error new AppError(substitute('Test procedure &1 is PRIVATE', pMethodInfo:TestName), 0).
        
        // run the test
        run value(pMethodInfo:TestName) in hInstance.
    end method.
    
END CLASS.