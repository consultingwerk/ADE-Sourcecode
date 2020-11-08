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
        define variable innerErr as Progress.Lang.Error no-undo.
        
        super(innerErr).
        SetMessage(poStatusCode, StatusCodeHelper:GetMessage(poStatusCode)).
    end.
    
    /* Constructor.
    
       @param StatusCodeEnum The error status being raised 
       @param character The status message */    
    constructor public SendExceptionError(input poStatusCode as StatusCodeEnum,
                                          input pcStatusMessage  as character):
        define variable innerErr as Progress.Lang.Error no-undo.
        
        super(innerErr).
        SetMessage(poStatusCode, pcStatusMessage).
    end constructor.
    
    /* Constructor.
    
       @param StatusCodeEnum The error status being raised 
       @param Progress.Lang.Error The error that caused this status error to be raised. */
    constructor public SendExceptionError(input poStatusCode as StatusCodeEnum,
                                          input poInnerError as Progress.Lang.Error):
        super(poInnerError).
        SetMessage(poStatusCode, ?).
    end constructor.
    
    /* Constructor.
    
       @param StatusCodeEnum The error status being raised 
       @param Progress.Lang.Error The error that caused this status error to be raised. */
    constructor public SendExceptionError(input pStatusCode as StatusCodeEnum,
                                          input pInnerStop as Progress.Lang.Stop):
        super(pInnerStop).
        SetMessage(pStatusCode, ?).
    end constructor.
    
    /* Constructor.
    
       @param StatusCodeEnum The error status being raised 
       @param character The status message 
       @param Progress.Lang.Error The error that caused this status error to be raised. */
    constructor public SendExceptionError(input pStatusCode as StatusCodeEnum,
                                          input pStatusMessage  as character,
                                          input pInnerStop as Progress.Lang.Stop):
        super(pInnerStop).
        SetMessage(pStatusCode, pStatusMessage).
    end constructor.
    
    /* Constructor.
    
       @param StatusCodeEnum The error status being raised 
       @param character The status message 
       @param Progress.Lang.Error The error that caused this status error to be raised. */    
    constructor public SendExceptionError(input poStatusCode as StatusCodeEnum,
                                          input pcStatusMessage as character,
                                          input poInnerError as Progress.Lang.Error):
        super(poInnerError).
        SetMessage(poStatusCode, pcStatusMessage).
    end constructor.
    
    /* Sets the status code & message in the appropriate places
       
       @param StatusCodeEnum The status code for this error
       @param character      A message associated with the status code. May be ? nbut not empty */
    method private void SetMessage(input pStatusCode as StatusCodeEnum,
                                   input pStatusMessage as character):
        Assert:NotNull(pStatusCode, 'Status code').
        if pStatusMessage eq ? then
            assign pStatusMessage = StatusCodeHelper:GetMessage(pStatusCode).
        else
            Assert:NotEmpty(pStatusMessage, 'Status message').
        
        assign this-object:StatusCode    = pStatusCode
               this-object:StatusMessage = pStatusMessage.
        
        AddMessage(this-object:StatusMessage, integer(pStatusCode)).
    end method.
    
    method override public character ToString():
        return substitute('HTTP Error: &2 (&1)', StatusCode, StatusMessage).
    end method.
end.