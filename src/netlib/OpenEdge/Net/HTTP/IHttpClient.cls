/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : IHttpClient
    Purpose     : Interface defining an HTTP Client
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 21 09:09:31 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.

interface OpenEdge.Net.HTTP.IHttpClient:  
    
    /** (mandatory) A free-text name for this http client. Used for the USER-AGENT
        string. */
    define public property ClientName as character no-undo get.
    
    /** (mandatory) A free-text semantic version string for this http client. Used for the USER-AGENT
        string. */
    define public property ClientVersion as character no-undo get.
    
    /** Miscellanous options (like timeouts) for this client */
    define public property Options as ClientOptions no-undo get.
    
    /** Executes an HTTP request. 
        
        @param  HttpRequest Request parameters (URL, method, etc)  
        @return HttpResponse Includes status and payload */
    method public IHttpResponse Execute(input poRequest as IHttpRequest).
    
    /** Executes an HTTP request and populates the passed-in response
        
        @param HttpRequest Request parameters (URL, method, etc)  
        @param HttpResponse Includes status and payload*/
    method public void Execute(input poRequest  as IHttpRequest,
                               input poResponse as IHttpResponse).
    
end interface.