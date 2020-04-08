/************************************************
Copyright (c) 2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IRunnableEntity
    Purpose     : Describes an entity that runs tests, including the lifecycle methods
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2019-12-05
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.ABLUnit.Model.TestEntity.

interface OpenEdge.ABLUnit.Model.IRunnableEntity:
    /* The current TestEntity being tested */
    define public property Entity as Progress.Lang.Object no-undo
        get.
    
    /* Runs the Test Entity (class or procedure) */
    method public void StartEntity().
    
    /* Stop the Test Entity (class or procedure) */
    method public void StopEntity().
    
    /* Runs a single test method.
       
       @param TestEntity The child test  */
    method public void RunChild(input pChild as TestEntity).
    
end interface.