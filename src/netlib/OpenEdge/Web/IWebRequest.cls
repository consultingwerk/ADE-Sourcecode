/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   Purpose     : Standard interface for PASOE/Web requests
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Mon Apr 20 11:47:12 EDT 2015
   Notes       : 
   @since      : 11.6    
 ----------------------------------------------------------------------*/
using OpenEdge.Net.HTTP.IHttpRequest.

interface OpenEdge.Web.IWebRequest inherits IHttpRequest:
    /* IP address of the interface on which the request was received */
    define public property LocalAddress as character no-undo get.
    
    /* Host name of the interface on which the request was received */
    define public property LocalHost as character no-undo get.
    
    /* Port number of the interface on which the request was received */
    define public property LocalPort as integer no-undo get.
    
    /* IP address of the client or last proxy that sent the request */
    define public property RemoteAddress as character no-undo get.
    
    /* Host name the client or the last proxy that sent the request */
    define public property RemoteHost as character no-undo get.
    
    /* Port of the client or last proxy that sent the request */
    define public property RemotePort as integer no-undo get.  
    
    /* Login of the user making this request, or null if not authenticated */
    define public property RemoteUser as character no-undo get.

    /* The part of this request's URL that specifies the OE transport */   
    define public property TransportPath as character no-undo get.
    
    /* The real path to the part of the URL specified by TransportPath */
    define public property ResolvedTransportPath as character no-undo get.
    
    /* The URL after the TransportPath. Does not include the query. */
    define public property PathInfo as character no-undo get.

    /* Portion of request URI that indicates the web application. */
    define public property WebAppPath as character no-undo get.
        
    /* Returns the default cookie path   */
    define public property DefaultCookiePath as character no-undo get.
    
    /* Returns the default cookie domain   */
    define public property DefaultCookieDomain as character no-undo get.
    
    /* Returns a list of all context property names  */
    define public property ContextNames as character no-undo get.
        
    /* Return the server software   */
    define public property ServerSoftware as character no-undo get.
    
    /* Returns a comma-delimited list of path parameter names, for URI mappings */ 
    define public property PathParameterNames as character no-undo get.
    
    /* Get the parameter value that corresponds to the defined URI mapping 
        that invoked the handler for this request
         
        Example: 
        URI mapping defined in openedge.properties /customers/{custname}/orders/{ordernum} 
        Requested URI /customers/Andersen/orders/7 
        GetPathParameter("custname") will return "Andersen"
        GetPathParameter("ordernum") will return "7"
                        
        @param character name defined with curly braces in URI mapping  
        @return character The path parameter value */
    method public character GetPathParameter(input pcName as character).
    
    /* Get a value from the request context
       
       @param character The name context property name   
       @return longchar The content property value */
    method public longchar GetContextValue(pcName as character).
    
end interface.
