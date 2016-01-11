/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : IHttpClientLibrary
    Purpose     : Interface representing the library performing actual HTTP
                  requests and processing the responses. Not 'customer facing': 
                  the classes implementing this interface will be highly-specific
                  to the underlying DLL/implementations.
                  
                  The OpenEdge.Net.Http.* classes should be used for all client
                  programming purposes.
    Author(s)   : pjudge
    Created     : Wed Apr 02 09:44:33 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpResponse.

interface OpenEdge.Net.HTTP.IHttpClientLibrary:
    /* Initializer/Startup */
    method public void Initialize().
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy().
    
    /** (mandatory) A free-text name for this library. Used for the USER-AGENT
        string. */
    define public property LibraryName as character no-undo get.
    
    /** (mandatory) A free-text semantic version string for this library. Used for the USER-AGENT
        string. */
    define public property LibraryVersion as character no-undo get.
    
    /** (mandatory) Miscellanous options (like timeouts) for this library */
    define public property Options as ClientOptions no-undo get.
    
    /** Generic HTTP Request execution
        
        @param HttpRequest The request to execute. May include headers,
                           HTTP method, payload etc. 
        @return HttpResponse */
    method public HttpResponse Execute(input poRequest as HttpRequest).
    
end interface.