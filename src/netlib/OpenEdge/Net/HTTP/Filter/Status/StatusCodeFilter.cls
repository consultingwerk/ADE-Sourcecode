/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StatusCodeFilter
    Purpose     :   
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:43:22 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.StatusActionEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.

class OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilter abstract:
    /** (mandatory) The client that executes the current request. */
    define public property Client as HttpClient no-undo get. private set.

    /** the StatusCode that this filter applies to */
    define public property StatusCode as StatusCodeEnum extent no-undo get. protected set.
    
    constructor protected StatusCodeFilter(input poClient as HttpClient,
                                           input poStatusCode as StatusCodeEnum extent):
        this-object(poClient).
        
        Assert:HasDeterminateExtent(poStatusCode, 'Status code').
        assign this-object:StatusCode = poStatusCode.
    end constructor.

    constructor protected StatusCodeFilter(input poClient as HttpClient):
        Assert:NotNull(poClient, 'Http Client').
    end constructor.
    
    /* [to be implemented by the individual filter types]
                 
        @param HttpResponse The response whose status code is being evaulated
        @return StatusActionEnum The action to take as a result of this filter */ 
    method abstract public StatusActionEnum EvaluateStatus(input poResponse as HttpResponse).
end class.