/************************************************
Copyright (c) 2015-2016 by Progress Software Corporation. All rights reserved.
*************************************************/  
/*------------------------------------------------------------------------
    File        : DefaultWebHandler
    Purpose     : Returns 501 Not Implemented or 405 Method Not Allowed for all HTTP Methods
    Syntax      : 
    Description : 
    Author(s)   : mbanks
    Created     : Tue Jun 23 11:52:02 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.WebHandler.
using OpenEdge.Web.WebRequest.

class OpenEdge.Web.DefaultWebHandler inherits WebHandler: 
    
    /* Uses the default implementation for each HTTP method, which is one of HandleNotAllowedMethod
       or HandleNotImplemented */
      
    method public override integer HandleRequest( ):
        define variable webRequest as IWebRequest no-undo.
        
        webRequest = new WebRequest().
            
        Logger:Warn("DefaultWebHandler invoked - Method: " + webRequest:Method + " URL: " + webRequest:URI:ToString()).         
        Logger:Info("   RemoteHost: " + webRequest:RemoteHost).
        Logger:Info("   RemoteAddress: " + webRequest:RemoteAddress).
        Logger:Info("   RemoteUser: " + webRequest:RemoteUser).
        
        return super:HandleRequest().

    end method.       
    
    /* Default handler for unsupported methods
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this method will deal with all errors */
    method override protected integer HandleNotAllowedMethod(input poRequest as IWebRequest):
        return integer(StatusCodeEnum:MethodNotAllowed).
        
        /** ALTERNATIVE: WRITE YOUR OWN COMPLETE MESSAGE 
        
        define variable oResponse as OpenEdge.Net.HTTP.IHttpResponse no-undo.
        define variable oWriter as OpenEdge.Web.WebResponseWriter no-undo.
        
        assign oResponse = new OpenEdge.Web.WebResponse()
               oResponse:StatusCode = integer(StatusCodeEnum:MethodNotAllowed)
               oWriter = new WebResponseWriter(oResponse)
               .
        oWriter:Open().
        oWriter:Flush().
        oWriter:Close().
        
        return 0.
        **/
    end method.
    
    /* Default handler for unknown methods
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this method will deal with all errors */
    method override protected integer HandleNotImplemented(input poRequest as IWebRequest):
        return integer(StatusCodeEnum:NotImplemented).
    end method.

end class.
