/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
        poRegistry:Put(substitute('&1.&2':u, 
                            TargetTypeEnum:File:GetClass():TypeName,
                            TargetTypeEnum:File:ToString()),
                       get-class(FileOperationHandler)).
        
        poRegistry:Put(substitute('&1.&2':u, 
                            TargetTypeEnum:Void:GetClass():TypeName,
                            TargetTypeEnum:Void:ToString()),       
                       get-class(VoidOperationHandler)).
                       
        poRegistry:Put(substitute('&1.&2':u, 
                            TargetTypeEnum:Class:GetClass():TypeName,
                            TargetTypeEnum:Class:ToString()),                 
                       get-class(ClassOperationHandler)).
                       
        poRegistry:Put(substitute('&1.&2':u, 
                            TargetTypeEnum:Procedure:GetClass():TypeName,
                            TargetTypeEnum:Procedure:ToString()),   
                       get-class(ProcedureOperationHandler)).
    end method.

end class.