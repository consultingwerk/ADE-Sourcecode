/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/  
/*------------------------------------------------------------------------
   File        : SendExceptionError
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : lecuyer
   Created     : Fri Sep 11 2015
   Notes       : 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Web.SendExceptionError.
using Progress.Lang.Error.

class OpenEdge.Web.SendExceptionError inherits ApplicationError:  
    /* (mandatory) The error HTTP status code. */  
    define public property StatusCode as StatusCodeEnum no-undo get. private set.
        
    /* A status message text. */        
    define public property StatusMessage as character no-undo
        get.
        set(input pcMessage as character):
            Assert:NotNullOrEmpty(pcMessage, 'Status message').
            
            assign this-object:StatusMessage = pcMessage.
            
            /* make sure our stack is ok. */
            if this-object:NumMessages ge 1 then
                RemoveMessage(1).
            AddMessage(this-object:StatusMessage, integer(this-object:StatusCode)).
        end set.
    
    constructor static SendExceptionError ():
        ApplicationError:AddError(
            get-class(SendExceptionError),
            /* short message */
            'HTTP Error',
            /* message */
            '&1').
    end constructor.

    /* Constructor.
    
       @param StatusCodeEnum The error status being raised */    
    constructor public SendExceptionError(input poStatusCode as StatusCodeEnum):
        this-object(poStatusCode,
                    StatusCodeHelper:GetMessage(poStatusCode)).
    end.
    
    /* Constructor.
    
       @param StatusCodeEnum The error status being raised 
       @param character The status message */    
    constructor public SendExceptionError(input poStatusCode as StatusCodeEnum,
                                          input pcStatusMessage  as character):
        this-object(poStatusCode, pcStatusMessage, ?).
    end constructor.
    
    /* Constructor.
    
       @param StatusCodeEnum The error status being raised 
       @param character The status message 
       @param Progress.Lang.Error The error that caused this status error to be raised. */    
    constructor public SendExceptionError(input poStatusCode as StatusCodeEnum,
                                          input pcStatusMessage  as character,
                                          input poInnerError as Error):
        super(poInnerError).
        
        Assert:NotNull(poStatusCode, 'Status code').
        Assert:NotNullOrEmpty(pcStatusMessage, 'Status message').
        
        assign this-object:StatusCode    = poStatusCode
               this-object:StatusMessage = pcStatusMessage.
        
        AddMessage(this-object:StatusMessage, integer(poStatusCode)).
    end.
end.    