/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationArgument
    Purpose     : This is the runtime argument (ie actual passed value) / value holder for a parameter.
    Author(s)   : pjudge
    Created     : 2016-05-25
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.

class OpenEdge.Web.DataObject.OperationArgument:
    /* (mandatory) The service to which this argument belongs */
    define public property Service as DataObjectService no-undo
        get.
        private set.
    
    /* (mandatory) The operation to which this argument belongs */
    define public property Operation as MappedOperation no-undo
        get.
        private set.
    
    /* (mandatory) The parameter 'definition' for this argument. We can get to the Operation and thence Service*/
    define public property Parameter as OperationParameter no-undo
        get.
        private set.
    
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
       
       @param OperationParameter The parameter 'template' for these values
       @param IWebRequest The incoming request
       @param IHttpResponse The outgoing response */
    constructor public OperationArgument(input pService as DataObjectService,
                                         input pOperation as MappedOperation,
                                         input poParam as OperationParameter):
        Assert:NotNull(pService, 'Service').
        Assert:NotNull(pOperation, 'Mapped operatation ').
        Assert:NotNull(poParam, 'Operatation parameter').
        
        assign this-object:Service      = pService
               this-object:Operation    = pOperation
               this-object:Parameter    = poParam
               this-object:ArgumentType = poParam:ArgumentType 
               .
        // We need a "Value" property that is defined as CLASS <Object> EXTENT to be able to write object array values
        // The property MUST have PUBLIC SET access
        if     not poParam:IsPrimitive
           and poParam:IsArray
           and not this-object:ArgumentType:IsA(get-class(IObjectArrayHolder)) 
        then
            assign this-object:ArgumentType = get-class(IObjectArrayHolder).
    end constructor.
    
end class.