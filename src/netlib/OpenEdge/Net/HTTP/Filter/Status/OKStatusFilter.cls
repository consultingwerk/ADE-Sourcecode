/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : OKStatusFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilter.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.StatusActionEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.

class OpenEdge.Net.HTTP.Filter.Status.OKStatusFilter inherits StatusCodeFilter: 
    
    constructor public OKStatusFilter(input poClient as HttpClient):
        define variable oTypes as StatusCodeENum extent 1 no-undo.
        
		super(poClient).
		
		assign oTypes[1] = StatusCodeEnum:OK
		       this-object:StatusCode = oTypes.
    end constructor.
    
    /** Process a particular set of status codes.  
        
        @param HttpResponse The response whose status code is being evaulated
        @return StatusActionEnum  Action required from this evaluation */ 
    method override public StatusActionEnum EvaluateStatus(input poResponse as HttpResponse):
        return StatusActionEnum:OK.
    end method.
    
end class.