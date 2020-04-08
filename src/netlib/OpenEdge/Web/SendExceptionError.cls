/************************************************
Copyright (c) 2015-2016, 2020 by Progress Software Corporation. All rights reserved.
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
    define public property StatusMessage as character no-undo get. private set.

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
       @param Progress.Lang.Error The error that caused this status error to be raised. */    
    constructor public SendExceptionError(input poStatusCode as StatusCodeEnum,
                                          input poInnerError as Error):
        this-object(poStatusCode,
                    StatusCodeHelper:GetMessage(poStatusCode),
                    poInnerError).
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
    
    method override public character ToString():
        return substitute('HTTP Error: &2 (&1)', StatusCode, StatusMessage).
    end method.
end.