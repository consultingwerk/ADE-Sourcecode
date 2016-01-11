/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : RedirectStatusFilter
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

class OpenEdge.Net.HTTP.Filter.Status.RedirectStatusFilter inherits StatusCodeFilter: 
    
    constructor public RedirectStatusFilter(input poClient as HttpClient):
        define variable oTypes as StatusCodeENum extent 1 no-undo.
        
		super(poClient).
		
		assign oTypes[1] = StatusCodeEnum:Found
		       StatusCode = oTypes.
    end constructor.
	
    /* Process a particular set of status codes.  
       
        @param HttpResponse The response whose status code is being evaulated
        @return StatusActionEnum  Action required from this evaluation */ 
    method override public StatusActionEnum EvaluateStatus(input poResponse as HttpResponse):
        define variable cLocation as character no-undo.
        
        assign cLocation = poResponse:GetHeaderEntry('Location').
        
        /* the value of the Location header is the new host/path */
        poResponse:Request:SetURI(string(cLocation)).        
        
        return StatusActionEnum:Retry.
    end method.
    
end class.