/************************************************
Copyright (c) 2014-2016 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.

interface OpenEdge.Net.HTTP.IHttpClientLibrary:
    /** (mandatory) A free-text name for this library. Used for the USER-AGENT
        string. */
    define public property LibraryName as character no-undo get.
    
    /** (mandatory) A free-text semantic version string for this library. Used for the USER-AGENT
        string. */
    define public property LibraryVersion as character no-undo get.
    
    /** (mandatory) Miscellanous options (like timeouts) for this client */
    define public property Options as ClientOptions no-undo get.
    
    /** Generic HTTP Request execution
        
        @param IHttpRequest The request to execute. May include headers,
                            HTTP method, payload etc. 
        @param IHttpResponse Includes status and payload */
    method public void Execute(input poRequest  as IHttpRequest,
                               input poResponse as IHttpResponse).

end interface.