/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationArgument
    Purpose     : This is the runtime argument (ie actual passed value) for a parameter.
                  It's a value holder with some context (the operation/request/parameter)
                  to which it applies.
    Author(s)   : pjudge
    Created     : 2016-05-25
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

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
    
    /* The argument value. It must be of the correct type (the OperationParameter's ArgumentType */
    define public property ArgumentValue as Progress.Lang.Object no-undo
        get.
        set(input pArgValue as Progress.Lang.Object ):
            if valid-object(pArgValue) then
                Assert:IsType(pArgValue, this-object:ArgumentType).
            
            assign this-object:ArgumentValue = pArgValue.                 
        end set.
    
    /* The actual argument type (the ABL type in which the value is stored. Defaults to the parameter's DefaultType.
       This valus is mutable because we may store the actual value in JSON as opposed to a dataset handle(say). */
    define public property ArgumentType as class Progress.Lang.Class no-undo
        get.
        set(input pArgType as class Progress.Lang.Class):
            Assert:NotNull(pArgType, 'Argument type').
            
            assign this-object:ArgumentType = pArgType.
        end set.
    
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
        
        assign this-object:Operation    = poOperation
               this-object:Parameter    = poParam
               this-object:Request      = poReq
               this-object:Response     = poResp
               
               this-object:ArgumentType = poParam:ArgumentType 
               .
    end constructor.
    
end class.