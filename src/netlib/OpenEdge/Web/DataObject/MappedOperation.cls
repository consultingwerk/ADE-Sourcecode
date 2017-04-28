/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MappedOperation
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 18 13:40:31 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using OpenEdge.Web.DataObject.OperationParameter.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Web.DataObject.MappedOperation:
    /* (key value) The Service name this operation. */
    define public property ServiceName as character no-undo get. private set.
    
    /* (key value) The relative URI for this operation. */
    define public property ServiceURI as character no-undo get. private set.
        
    /* (key value) The HTTP method for the operation */
    define public property Method as MethodEnum no-undo get. private set.
    
    /* (data value) The MIME type of the response */
    define public property ContentType as character no-undo get. private set.
    
    /* (data value) The HTTP status code to use for the response */
    define public property StatusCode as integer no-undo get. private set.
    
    /* (data value) The kind of operation: CLS, PROC or FILE */
    define public property TargetType as TargetTypeEnum no-undo get. private set.
    
    /* (data value) The target name (class, procedure, filename) */ 
    define public property TargetName as character no-undo get. private set.
    
    /* (data value) For non-file operations, the function/procedure/method name */
    define public property TargetFunction as character no-undo get. private set.
    
    /* (Mandatory) The parameters for this operation. may be empty/0 */    
    define public property Parameters as IList no-undo get. private set.        

    /* (optional) The return-value definition */
    define public property ReturnValue as OperationParameter no-undo get. set.
    
    /* (optional) Options for the method call. Largely free-form */
    define public property Options as JsonObject no-undo get. private set.
    
    /* Constructor. */
    constructor public MappedOperation(input pcServiceName as character,
                                       input pcServiceURI as character,
                                       input poMethod as MethodEnum,
                                       input pcContentType as character,
                                       input poTargetType as TargetTypeEnum,
                                       input pcTargetName as character,
                                       input pcTargetFunction as character,
                                       input poOptions as JsonObject,
                                       input piStatusCode as integer,
                                       input poParams as IList):
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNullOrEmpty(pcServiceURI, 'Service URI').
        Assert:NotNull(poMethod, 'Operation method').
        Assert:NotNull(pcContentType, 'Content type').
        Assert:NotNull(poTargetType, 'Target type').
        Assert:NotNull(pcTargetName, 'Target name').
        // VOID targets are allowed empty names (by definition, really)
        if poTargetType ne TargetTypeEnum:void then
        do:
            Assert:NotEmpty(pcTargetName, 'Target name').
            Assert:NotEmpty(pcContentType, 'Content type').
        end.
        
        Assert:NotNull(pcTargetFunction, 'Target function').
        Assert:NotNull(poParams, 'Operation parameters').
        Assert:IsPositive(piStatusCode, 'Status code').
        
        
        assign this-object:ServiceName = pcServiceName
               this-object:ServiceURI = pcServiceURI
               this-object:Method = poMethod               
               this-object:ContentType = pcContentType
               this-object:TargetType = poTargetType 
               this-object:TargetName = pcTargetName
               this-object:TargetFunction = pcTargetFunction
               this-object:StatusCode = piStatusCode
               this-object:Parameters = poParams.
               
        if valid-object(poOptions) then
            assign this-object:Options = poOptions.
        else
            assign this-object:Options = new JsonObject().
    end method.
    
    method override public character ToString():
        return substitute('&1_&2: &3 svc:&9 uri:&4: type:&5 ; name:&6, fn:&7, numargs:&8':u,
                    this-object:GetClass():TypeName,
                    int64(this-object),
                    string(this-object:Method), 
                    this-object:ServiceURI,
                    string(this-object:TargetType),
                    this-object:TargetName,
                    this-object:TargetFunction,
                    this-object:Parameters:Size,
                    this-object:ServiceName ).
    end method.
    
end class.