/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationArgument
    Purpose     : This is the runtime argument (ie actual passed value) for a parameter
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-05-25
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateArrayHolder.
using Ccs.Common.Support.IDateHolder.
using Ccs.Common.Support.IDateTimeArrayHolder.
using Ccs.Common.Support.IDateTimeHolder.
using Ccs.Common.Support.IDateTimeTzArrayHolder.
using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.IDecimalArrayHolder.
using Ccs.Common.Support.IDecimalHolder.
using Ccs.Common.Support.IHandleArrayHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IInt64ArrayHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.ILogicalArrayHolder.
using Ccs.Common.Support.ILogicalHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrArrayHolder.
using Ccs.Common.Support.IMemptrHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.IWebRequest.

class OpenEdge.Web.DataObject.OperationArgument:
    /* (mandatory) request context */
    define public property Operation as MappedOperation no-undo get. private set.
    define public property Parameter as OperationParameter no-undo get. private set.
    define public property Request as IWebRequest no-undo get. private set.
    define public property Response as IHttpResponse no-undo get. private set.
    
    /* (optional) Basically an identifier for the argument variable used to make the call. */
    define public property ArgumentIndex as integer no-undo get. set.
    
    define public property IsArray as logical no-undo get. private set.
    define public property IsPrimitive as logical no-undo get. private set.
    define public property HasSchema as logical no-undo get. private set.
    define public property DataType as character no-undo get. private set.
    define public property IoMode as character no-undo get. private set.
    
    /* argument value and its type */
    define public property ArgumentValue as Progress.Lang.Object no-undo get. set.
    define public property ArgumentType  as class Progress.Lang.Class no-undo
        get.
        set(input poType as class Progress.Lang.Class):
            Assert:NotNull(poType, 'Argument type').
            if this-object:IsPrimitive then
                Assert:IsType(poType, get-class(IPrimitiveHolder)).
            assign this-object:ArgumentType = poType.
        end set.
    
    /* (optional) Schema for this argument. May be a single table handle or an
       array of them; may be a JSON or XML schema too. The schema may be a ProDataSet
       and the value we use a single table in that dataset. */
    define public property SchemaHolder as Progress.Lang.Object no-undo get. set.
    
    /* Constructor
       
       @param MappedOperation The operation being executed 
       @param OperationParameter The parameter 'template' for these values
       @param IWebRequest The incoming request
       @param IHttpResponse The outgoing response */
    constructor public OperationArgument(input poOperation as MappedOperation,
                                         input poParam as OperationParameter,
                                         input poReq as IWebRequest,
                                         input poResp as IHttpResponse ):
        Assert:NotNull(poOperation, 'Operation map').
        Assert:NotNull(poParam, 'Operatation parameter').
        Assert:NotNull(poReq, 'Web request').
        Assert:NotNull(poResp, 'Web Response').
        
        assign this-object:Operation = poOperation
               this-object:Parameter = poParam
               this-object:Request   = poReq
               this-object:Response  = poResp
               
               this-object:IsArray     = (entry(num-entries(poParam:ABLType, ' ':u), poParam:ABLType, ' ':u) eq 'extent':u)
               this-object:IsPrimitive = (not poParam:ABLType begins 'class':u)
               this-object:DataType    = trim(entry(1, poParam:ABLType, ' ':u))
               this-object:IoMode      = poParam:IOMode:ToString()
               this-object:HasSchema   = false  //default value
               .
        /* defaults */
        if this-object:IsPrimitive then
        do:
            if this-object:IsArray then
            case this-object:DataType:
                when 'character':u or
                when 'longchar':u or
                when 'rowid':u then
                    assign this-object:ArgumentType = get-class(ILongcharArrayHolder).
                when 'recid':u or
                when 'integer':u or
                when 'int64':u then
                    assign this-object:ArgumentType = get-class(IInt64ArrayHolder).
                when 'decimal':u then
                    assign this-object:ArgumentType = get-class(IDecimalArrayHolder).
                when 'logical':u then
                    assign this-object:ArgumentType = get-class(ILogicalArrayHolder).
                when 'date':u then
                    assign this-object:ArgumentType = get-class(IDateArrayHolder).
                when 'datetime':u then
                    assign this-object:ArgumentType = get-class(IDateTimeArrayHolder).
                when 'datetime-tz':u then
                    assign this-object:ArgumentType = get-class(IDateTimeTzArrayHolder).
                when 'raw':u or
                when 'memptr':u then
                    assign this-object:ArgumentType = get-class(IMemptrArrayHolder).
                when 'handle':u then
                    assign this-object:ArgumentType = get-class(IHandleArrayHolder).
                when 'table':u or
                when 'dataset':u then
                    assign this-object:ArgumentType = get-class(IHandleArrayHolder)
                           this-object:HasSchema    = true.
            end case.
            else
            case poParam:ABLType:
                when 'character':u or
                when 'longchar':u then
                    assign this-object:ArgumentType = get-class(ILongcharHolder).
                when 'integer':u or
                when 'int64':u then
                    assign this-object:ArgumentType = get-class(IInt64Holder).
                when 'decimal':u then
                    assign this-object:ArgumentType = get-class(IDecimalHolder).
                when 'logical':u then
                    assign this-object:ArgumentType = get-class(ILogicalHolder).
                when 'rowid':u then
                    assign this-object:ArgumentType = get-class(ILongcharHolder).
                when 'recid':u then
                    assign this-object:ArgumentType = get-class(IInt64Holder). 
                when 'date':u then
                    assign this-object:ArgumentType = get-class(IDateHolder).
                when 'datetime':u then
                    assign this-object:ArgumentType = get-class(IDateTimeHolder).
                when 'datetime-tz':u then
                    assign this-object:ArgumentType = get-class(IDateTimeTzHolder).
                when 'raw':u or
                when 'memptr':u then
                    assign this-object:ArgumentType = get-class(IMemptrHolder).
                when 'handle':u then
                    assign this-object:ArgumentType = get-class(IHandleHolder).
                when 'table' or
                when 'dataset':u then
                    /* special treatment for datasets & temp-tables. always BY-REFERENCE and always use dataset handles */
                    assign this-object:ArgumentType = get-class(IHandleHolder)
                           this-object:DataType     = substitute('&1-handle':u, poParam:ABLType) 
                           this-object:IoMode       = substitute('&1 by-reference':u, poParam:IOMode:ToString()) 
                           this-object:HasSchema    = true.
            end case.
        end.
        else
            assign this-object:ArgumentType = Progress.Lang.Class:GetClass(entry(2, poParam:ABLType, ' ':u)).
        
    end constructor.
    
end class.