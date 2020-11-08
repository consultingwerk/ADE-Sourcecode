/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Net.HTTP.CookieCollection.
using OpenEdge.Net.HTTP.HttpHeaderCollection.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.DataObjectHandler.
using OpenEdge.Web.DataObject.FileOperationHandler.
using OpenEdge.Web.DataObject.OperationOptions.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using OpenEdge.Web.DataObject.VoidOperationHandler.
using OpenEdge.Web.DataObject.Writer.OperationHandlerRegistry.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.MappedOperation:
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
    
    /* (optional) A collection of HTTP headers to set for this operation. */
    define public property Headers as HttpHeaderCollection no-undo
        get.
        private set.
    
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
    
    /* (optional) A collection of HTTP cookies to set for this operation. */
    define public property Cookies as CookieCollection no-undo
        get.
        private set.
    
    /* (optional) Access control list for this operation. Typically one or more ROLES that will be evaluated 
       against the current user. */
    define public property AccessControl as character extent no-undo
        get.
        set.
    
    /* Constructor
       
       @param character The service URI
       @param MethodEnum  The HTTP method
       @param character The content-type to return
       @param character The ABL target of the operation
       @param character The name of the target (class/procedure/etc)
       @param character The entity type (what type of object should this be)
       @param character The name of the function (method/internal-proc/etc)
       @param OperationOptions Any options pertaining to this operatiion
       @param integer The HTTP status code to return in case of success */
    constructor public MappedOperation(input pcServiceURI as character,
                                       input poMethod as MethodEnum,
                                       input pcContentType as character,
                                       input pTargetType as character,
                                       input pcTargetName as character,
                                       input pEntityType as character,
                                       input pcTargetFunction as character,
                                       input poOptions as OperationOptions,
                                       input piStatusCode as integer):
        this-object(pcServiceURI,
                    poMethod,
                    pcContentType,
                    pTargetType,
                    pcTargetName,
                    pEntityType,
                    pcTargetFunction,
                    poOptions,
                    piStatusCode,
                    new List() ).
    end constructor.
    
    /* Constructor
       
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
    constructor public MappedOperation(input pcServiceURI as character,
                                       input poMethod as MethodEnum,
                                       input pcContentType as character,
                                       input pTargetType as character,
                                       input pcTargetName as character,
                                       input pEntityType as character,
                                       input pcTargetFunction as character,
                                       input poOptions as OperationOptions,
                                       input piStatusCode as integer,
                                       input poParams as IList):
        Assert:NotNull(pcServiceURI, 'Service URI').
        Assert:NotNull(poMethod, 'Operation method').
        Assert:NotNullOrEmpty(pcContentType, 'Content type').
        Assert:NotNullOrEmpty(pTargetType, 'Target type').
        Assert:NotNull(pcTargetName, 'Target name').
        Assert:NotNull(poParams, 'Operation parameters').
        
        if not OperationHandlerRegistry:Registry:Has(pTargetType) then
            undo, throw new AppError(substitute('Unsupported target type "&1" for operation "&3 &2"',
                                        pTargetType,
                                        pcServiceURI,
                                        string(poMethod) ), 
                                    0).
        
        // VOID targets are allowed empty names (by definition, really)
        if not pTargetType eq string(TargetTypeEnum:Void) then
        do:
            Assert:NotEmpty(pcTargetName, 'Target name').
            Assert:NotEmpty(pcContentType, 'Content type').
        end.
        else
        // Procedures may have a NULL target (ie call the main block)
        if pTargetType eq string(TargetTypeEnum:Procedure) then
            Assert:NotEmpty(pcTargetFunction, 'Target function').
        else
            Assert:NotNullOrEmpty(pcTargetFunction, 'Target function').
        
        Assert:NotNull(poParams, 'Operation parameters').
        Assert:IsPositive(piStatusCode, 'Status code').
        
        assign this-object:mServiceURI    = '/':u + trim(pcServiceURI, '/':u)
               this-object:Method         = poMethod
               this-object:ContentType    = pcContentType
               this-object:TargetType     = pTargetType 
               this-object:TargetName     = pcTargetName
               this-object:TargetFunction = pcTargetFunction
               this-object:StatusCode     = piStatusCode
               this-object:Parameters     = poParams
               this-object:Schemas        = new StringKeyedMap()
               this-object:Headers        = new HttpHeaderCollection()
               this-object:Cookies        = new CookieCollection()
               .
        if valid-object(poOptions) then
            assign this-object:Options = poOptions.
        else
            assign this-object:Options = new OperationOptions().
        
        // Set the target type. Default to PLO or IHandleHolder
        if OpenEdge.Core.String:IsNullOrEmpty(pEntityType) then
        case pTargetType:
            when string(TargetTypeEnum:Procedure) then assign this-object:EntityType = get-class(IHandleHolder).
            when string(TargetTypeEnum:File)      then assign this-object:EntityType = get-class(FileOperationHandler).
            when string(TargetTypeEnum:Self)      then assign this-object:EntityType = get-class(DataObjectHandler).
            when string(TargetTypeEnum:Void)      then assign this-object:EntityType = get-class(VoidOperationHandler).
            when string(TargetTypeEnum:Class)     then assign this-object:EntityType = Progress.Lang.Class:GetClass(pcTargetName).
            otherwise                                  assign this-object:EntityType = get-class(Progress.Lang.Object).
        end case.
        else
            assign this-object:EntityType = Progress.Lang.Class:GetClass(pEntityType).
    end method.
    
    method override public character ToString():
        define variable params as character no-undo.
        define variable delim as character no-undo.
        define variable iter as IIterator no-undo.
        
        assign iter  = this-object:Parameters:Iterator()
               delim = '':u
               .
        do while iter:HasNext():
            assign params = params
                          + delim 
                          + '[':u + iter:Next():ToString() + ']':u
                   delim  = ',':u.
        end.
        
        return substitute('&1_&2: &3 &4: ;target: &5 name:&6, type-of:&7':u,
                    this-object:GetClass():TypeName,
                    int64(this-object),
                    string(this-object:Method),
                    this-object:ServiceURI,
                    this-object:TargetType,
                    this-object:TargetName,
                    this-object:EntityType:TypeName )
               + substitute(', fn:&4, args(&2): &6, num-schemas:&1, num-hdr:&5, name:&3, num-cookies:&7':u,
                    this-object:Schemas:Size,
                    this-object:Parameters:Size,
                    this-object:Name,
                    this-object:TargetFunction,
                    this-object:Headers:Size,
                    params,
                    this-object:Cookies:Size ).
    end method.
    
    /* Returns a schema handle for a named schema for this operation (only).
       
       @param character The schema name
       @return handle A schema handle. UNKNOWN if the schema cannot be found */
    method public handle GetSchema(input pSchemaName as character):
        define variable hSchema as handle no-undo.
        
        Assert:NotNull(pSchemaName, 'Schema name').
        
        // is there an operation schema already?
        if this-object:Schemas:ContainsKey(pSchemaName) then
            assign hSchema = cast(this-object:Schemas:Get(pSchemaName), IHandleHolder):Value.
        
        return hSchema.
    end method.     // GetSchema()
    
end class.