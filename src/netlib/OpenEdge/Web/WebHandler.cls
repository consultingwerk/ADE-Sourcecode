/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   Purpose     : Abstract class to use as a basis for building WebSpeed for
                 PASOE request handlers
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Wed Jan 14 14:38:25 EST 2015
   Notes       : * Concrete child classes must implement the HandleNotImplemented and
                   HandleNotAllowedMethod methods so which are the baseline on 
                   we control the messages back (either created entirely in ABL or
                   served by PASOE).
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using OpenEdge.Web.WebRequest.
using Progress.Web.IWebHandler.
using OpenEdge.Core.Assert.

class OpenEdge.Web.WebHandler abstract
            implements IWebHandler :
        
    /* Handle request by calling the specific handler for the request method
       
       @return integer An HTTP status code. Zero means that the webhandler will take care of
                       any errors. A non-zero value means that the PASOE webapp's error handling 
                       will return a standardm page for the error */
    method public integer HandleRequest( ):
        define variable webRequest as IWebRequest no-undo.
        define variable httpStatus as integer no-undo.
        
        assign webRequest = new WebRequest()        
               httpStatus = integer(StatusCodeEnum:None).
        
        /* Check http method and dispatch to corresponding handler */
        case MethodEnum:GetEnum(webRequest:Method):
            when MethodEnum:DELETE  then assign httpStatus = HandleDelete(webRequest).
            when MethodEnum:GET     then assign httpStatus = HandleGet(webRequest).
            when MethodEnum:HEAD    then assign httpStatus = HandleHead(webRequest).
            when MethodEnum:OPTIONS then assign httpStatus = HandleOptions(webRequest).
            when MethodEnum:POST    then assign httpStatus = HandlePost(webRequest).
            when MethodEnum:PUT     then assign httpStatus = HandlePut(webRequest).
            when MethodEnum:TRACE   then assign httpStatus = HandleTrace(webRequest).
            when MethodEnum:PATCH   then assign httpStatus = HandlePatch(webRequest).
            otherwise                    assign httpStatus = HandleNotImplemented(webRequest).
        end case.
        
        Assert:NotNull(httpStatus, 'Status return code').

        /* good */
        return httpStatus.
        /* bad: We know something went wrong, and we were told what */
        catch oStatusError as SendExceptionError:
            return integer(oStatusError:StatusCode).
        end catch.
        /* ugly: we know something went wrong, but not what, exactly */
        catch oError as Progress.Lang.Error:
            return integer(StatusCodeEnum:InternalServerError).             
        end catch.
    end method.
    
    /* Handler for unsupported methods
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method abstract protected integer HandleNotAllowedMethod(input poRequest as IWebRequest).
       
    /* Handler for unknown methods
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method abstract protected integer HandleNotImplemented(input poRequest as IWebRequest).
       
    /* Default handler for the HTTP DELETE method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleDelete(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP GET method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleGet(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP POST method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandlePost(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP PUT method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandlePut(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP PATCH method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandlePatch(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP HEAD method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleHead(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP OPTIONS method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleOptions(input poRequest as IWebRequest):
         return HandleNotAllowedMethod(poRequest).    
    end method.
        
    /* Default handler for the HTTP TRACE method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleTrace(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.
    
end class.