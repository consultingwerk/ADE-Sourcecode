/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationHandlerRegistry
    Purpose     : Registry for types that hold operation handlers.
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-19
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Web.DataObject.FileOperationHandler.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using OpenEdge.Web.DataObject.Writer.OperationHandlerRegistry.
using OpenEdge.Web.DataObject.VoidOperationHandler.
using OpenEdge.Web.DataObject.ClassOperationHandler.
using OpenEdge.Web.DataObject.ProcedureOperationHandler.
using OpenEdge.Web.DataObject.DataObjectHandler.

class OpenEdge.Web.DataObject.Writer.OperationHandlerRegistry inherits BuilderRegistry:

    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(OperationHandlerRegistry:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(IOperationHandler)).
                OperationHandlerRegistry:InitializeRegistry(oRegistry).                
                assign OperationHandlerRegistry:Registry = oRegistry.
            end.
            return OperationHandlerRegistry:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        poRegistry:Put(string(TargetTypeEnum:Class),      get-class(ClassOperationHandler)).
        poRegistry:Put(string(TargetTypeEnum:File),       get-class(FileOperationHandler)).
        poRegistry:Put(string(TargetTypeEnum:Procedure),  get-class(ProcedureOperationHandler)).
        poRegistry:Put(string(TargetTypeEnum:Self),       get-class(DataObjectHandler)).
        poRegistry:Put(string(TargetTypeEnum:Void),       get-class(VoidOperationHandler)).
    end method.
    
end class.