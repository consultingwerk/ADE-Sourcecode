/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using Ccs.Common.Support.IHandleHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.DataObjectHandler.
using OpenEdge.Web.DataObject.FileOperationHandler.
using OpenEdge.Web.DataObject.OperationOptions.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using OpenEdge.Web.DataObject.VoidOperationHandler.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.Writer.OperationHandlerRegistry.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.MappedOperation:
    // Use a variable since we need the value to be CASE-SENSITIVE
    define private variable mServiceName as character case-sensitive no-undo.
    
    /* (key value) The Service name this operation. */
    define public property ServiceName as character no-undo
        get():
            return mServiceName.
        end get.
    
    /* (key value) The Version of this operation. */
    define public property ServiceVersion as SemanticVersion no-undo get. private set.
    
    // Use a variable since we need the value to be CASE-SENSITIVE
    define private variable mServiceUri as character case-sensitive no-undo.
    
    /* (key value) The relative URI for this operation. */
    define public property ServiceURI as character no-undo
        get():
            return mServiceUri.
        end get.
        
    /* (key value) The HTTP method for the operation */
    define public property Method as MethodEnum no-undo get. private set.
    
    /* (data value) The MIME type of the response */
    define public property ContentType as character no-undo get. private set.
    
    /* (data value) The HTTP status code to use for the response */
    define public property StatusCode as integer no-undo get. private set.
    
    /* (data value) The kind of operation: CLS, PROC, FILE, VOID */
    define public property TargetType as character no-undo get. private set.
    
    /* (data value) The target name (class, procedure, filename) */ 
    define public property TargetName as character no-undo get. private set.
    
    /* (data value) The expected ABL type of the target */
    define public property EntityType as class Progress.Lang.Class no-undo get. private set.
    
    /* (data value) For non-file operations, the function/procedure/method name */
    define public property TargetFunction as character no-undo get. private set.
    
    /* (Mandatory) The parameters for this operation. may be empty/0 */
    define public property Parameters as IList no-undo get. private set.
    
    /* (optional) The return-value definition */
    define public property ReturnValue as OperationParameter no-undo get. set.
    
    /* (optional) Options for the method call. */
    define public property Options as OperationOptions no-undo get. private set.
    
    /* (optional) A map of schema holders for the arguments (incl. return) for this operation */
    define public property Schemas as IStringKeyedMap no-undo get. private set.
    
    /* (optional) An easy/human-readable name for this operation */
    define public property Name as character no-undo get. set.
    
    /* Constructor
       
       @param character The service name
       @param character The service URI
       @param MethodEnum  The HTTP method
       @param character The content-type to return
       @param character The ABL target of the operation
       @param character The name of the target (class/procedure/etc)
       @param character The entity type (what type of object should this be)
       @param character The name of the function (method/internal-proc/etc)
       @param OperationOptions Any options pertaining to this operatiion
       @param integer The HTTP status code to return in case of success
       @param IList The parameter definitions for this operation */
    constructor public MappedOperation(input pcServiceName as character,
                                       input pVersion as SemanticVersion,
                                       input pcServiceURI as character,
                                       input poMethod as MethodEnum,
                                       input pcContentType as character,
                                       input pTargetType as character,
                                       input pcTargetName as character,
                                       input pEntityType as character,
                                       input pcTargetFunction as character,
                                       input poOptions as OperationOptions,
                                       input piStatusCode as integer,
                                       input poParams as IList):
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pcServiceURI, 'Service URI').
        Assert:NotNull(poMethod, 'Operation method').
        Assert:NotNull(pcContentType, 'Content type').
        Assert:NotNullOrEmpty(pTargetType, 'Target type').
        Assert:NotNull(pcTargetName, 'Target name').
        
        if not OperationHandlerRegistry:Registry:Has(pTargetType) then
            undo, throw new AppError(substitute('Unsupported target type "&1" for service "&2" operation "&4 &3"',
                                        pTargetType,
                                        pcServiceName,
                                        pcServiceURI,
                                        string(poMethod) ), 
                                    0).
        
        // VOID targets are allowed empty names (by definition, really)
        if not pTargetType eq string(TargetTypeEnum:void) then
        do:
            Assert:NotEmpty(pcTargetName, 'Target name').
            Assert:NotEmpty(pcContentType, 'Content type').
        end.
        
        Assert:NotNull(pcTargetFunction, 'Target function').
        Assert:NotNull(poParams, 'Operation parameters').
        Assert:IsPositive(piStatusCode, 'Status code').
        
        assign this-object:mServiceName   = pcServiceName
               this-object:ServiceVersion = pVersion
               this-object:mServiceURI    = pcServiceURI
               this-object:Method         = poMethod
               this-object:ContentType    = pcContentType
               this-object:TargetType     = pTargetType 
               this-object:TargetName     = pcTargetName
               this-object:TargetFunction = pcTargetFunction
               this-object:StatusCode     = piStatusCode
               this-object:Parameters     = poParams
               this-object:Schemas        = new StringKeyedMap()
               .
        if valid-object(poOptions) then
            assign this-object:Options = poOptions.
        else
            assign this-object:Options = new OperationOptions().
        
        // Set the target type. Default to PLO or IHandleHolder
        if OpenEdge.Core.String:IsNullOrEmpty(pEntityType) then
        case pTargetType:
            when string(TargetTypeEnum:Procedure)   then assign this-object:EntityType = get-class(IHandleHolder).
            when string(TargetTypeEnum:File)        then assign this-object:EntityType = get-class(FileOperationHandler).
            when string(TargetTypeEnum:Self)        then assign this-object:EntityType = get-class(DataObjectHandler).
            when string(TargetTypeEnum:Void)        then assign this-object:EntityType = get-class(VoidOperationHandler).
            // incl. TargetTypeEnum:Class
            otherwise                                    assign this-object:EntityType = get-class(Progress.Lang.Object).
        end case.
        else
            assign this-object:EntityType = Progress.Lang.Class:GetClass(pEntityType).
    end method.
    
    method override public character ToString():
        return substitute('&1_&2: &3 svc:&4 v&5 uri:&6: type:&7 ; name:&9, type-of:&9':u,
                    this-object:GetClass():TypeName,
                    int64(this-object),
                    string(this-object:Method), 
                    this-object:mServiceName,
                    string(this-object:ServiceVersion),
                    this-object:ServiceURI,
                    this-object:TargetType,
                    this-object:TargetName,
                    this-object:EntityType:TypeName )
            + substitute(', fn:&7, numargs:&2, num-schemas:&1, name:&3':u,
                    this-object:Schemas:Size,
                    this-object:Parameters:Size,
                    this-object:Name, 
                    this-object:TargetFunction  ).
    end method.
    
end class.