/************************************************
Copyright (c) 2013, 2019-2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : TestClass
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Wed Sep 18 11:52:34 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
BLOCK-LEVEL ON ERROR UNDO, THROW.

using OpenEdge.ABLUnit.Model.TestCase.
using OpenEdge.ABLUnit.Reflection.ClassInfo.
using OpenEdge.ABLUnit.Reflection.TestInfo.
using OpenEdge.Core.ISupportInitialize.
using Progress.Lang.AppError.
using Progress.Lang.ParameterList.
using Progress.Reflect.Flags.
using Progress.Reflect.Method.

CLASS OpenEdge.ABLUnit.Model.TestClass INHERITS TestCase:
    define private variable mParams as ParameterList no-undo.
    define private variable mFlags as Flags no-undo.
    
    DEFINE PUBLIC PROPERTY classInfo AS ClassInfo  NO-UNDO GET. SET.
     
    /* Constructor 
      
       @param integer The ID of this test entity */
    CONSTRUCTOR PUBLIC TestClass ( INPUT id1 AS INTEGER ):
        SUPER (INPUT id1).
        
        assign mParams = new ParameterList(0)
               mFlags  = Flags:Instance or Flags:Static or Flags:Public
               .
    END CONSTRUCTOR.
    
    /* Stops/destroys this test entity */
    method override protected void DestroyEntity():
        if     valid-object(this-object:Entity)
           and type-of(this-object:Entity, ISupportInitialize)
        then
            cast(this-object:Entity, ISupportInitialize):Destroy().
        
        assign this-object:Entity = ?.
    end method.
    
    /* Runs the test class */
    method override protected void InstantiateEntity():
        define variable testType as character no-undo.
        
        assign testType = classInfo:getClassName().
        
        // run the test class
        this-object:Entity = dynamic-new testType ().
        
        if type-of(this-object:Entity, ISupportInitialize) then
            cast(this-object:Entity, ISupportInitialize):Initialize().
    end method.
    
    /* Performs the invocation of the test method in this test entity
       
       @param TestInfo Data about the method to run */
    method override protected void InvokeTestMethod(input pMethodInfo as TestInfo):
        define variable meth as Method no-undo.
        
        if not valid-object(pMethodInfo) then
            // don't use Assert() because this state is a 'real error' not a test failure
            return error new AppError('Test method info is invalid', 0).
        
        assign meth = this-object:Entity:GetClass():GetMethod(pMethodInfo:TestName, mFlags, mParams).
        if not valid-object(meth) then
            // don't use Assert() because this state is a 'real error' not a test failure
            return error new AppError(substitute('Test method &1 could not be found', pMethodInfo:TestName), 0).
        
        if meth:IsStatic then
            meth:Invoke(mParams).
        else
            meth:Invoke(this-object:Entity, mParams).
    end method.
    
END CLASS.