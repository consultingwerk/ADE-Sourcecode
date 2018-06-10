/************************************************
Copyright (c) 2015-2018 by Progress Software Corporation. All rights reserved.
*************************************************/  
/*------------------------------------------------------------------------
   Purpose     : Keep a list of customer specified handlers and invoke 
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Mon Apr 27 14:42:44 EDT 2015
   Notes       : This is managed as a singleton by the ABL
   @since      : 11.6    
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using Progress.Web.AbstractWebRouter.
using Progress.Web.IWebHandler.

class OpenEdge.Web.InternalWebRouter implements ISupportLogging 
    inherits AbstractWebRouter
    final:
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get(): 
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(OpenEdge.Web.InternalWebRouter)).
            
            return this-object:Logger.
        end get.
        set.
    
    /* Indicates whether debugging is enabled for this request. */
    define private property DebugEnabled as logical no-undo
        get:
            define variable cVal as character no-undo.
            
            assign cVal = web-context:get-cgi-value('ENV':u, 'SERVLET_SRVR_DEBUG':u).
            
            /* rules per web/objects/web-util.p */
            return (cVal eq 'Enabled':u or cVal eq 'On':u).
        end get.
        /* read-only property; no setter at all */
    
    /* Store request handlers by name */
    define private temp-table ttHandler no-undo
        field WebHandler     as Progress.Lang.Object
        field WebHandlerName as character
        index idx1 as primary unique WebHandlerName.
    
    /* Handles a web request.  A customer can specify a different handler for
       each application.  If this is the first request for this handler or the 
       handler is invalaid, an instance of it is created.  
       The HandleRequest() method is then invoked.
      
       @param pcHandlerName   the name of the customer registered webspeed handler */
    method public override integer HandleRequest( pcHandlerName as character ):
        define variable oWebHandler as IWebHandler no-undo.
        define variable uriTemplate as character no-undo.
        define variable requestPath as character no-undo.
        
        define buffer lbHandler for ttHandler.
        
        assign requestPath = web-context:get-cgi-value('ENV':u, 'REQUEST_URI':u)
               uriTemplate = web-context:get-cgi-value('ENV':u, 'URI_TEMPLATE':u)
               .
        logger:Debug(substitute('Request for path "&1" using template "&2" and handler "&3"', 
                        requestPath,
                        uriTemplate,
                        pcHandlerName)).
        logger:Debug(substitute('Debug mode: &1', string(DebugEnabled, 'ON/OFF':u))).
        
        if DebugEnabled then
        do:
            /* in case it's already cached */
            this-object:Release(pcHandlerName).
            
            /* always use a new  handler instance */
            assign oWebHandler = InvokeHandler(pcHandlerName).
        end.
        else
        do:
            /* Check to see if we've used this handler for a previous request */
            if can-find(lbHandler where lbHandler.WebHandlerName eq pcHandlerName) then
                find lbHandler where lbHandler.WebHandlerName eq pcHandlerName.
            
            /* Create a record for the handler if it does not exist */    
            if not available lbHandler then
            do:
                create lbHandler.
                assign lbHandler.WebHandlerName = pcHandlerName.
            end.
            
            /* Create an instance of the handler if necessary */
            if valid-object(lbHandler.WebHandler) then
                assign oWebHandler = cast(lbHandler.WebHandler,IWebHandler).
            else
                assign oWebHandler          = InvokeHandler(pcHandlerName)
                       lbHandler.WebHandler = oWebHandler
                       .
        end.
        
        Assert:NotNull(oWebHandler, 'URI Handler').
        
        logger:Debug(substitute('Handler instance &1 used for handler &2', oWebHandler:ToString(), pcHandlerName)).
        
        /* Invoke the registered URI handler */
        return oWebHandler:HandleRequest().
        
        catch e as Progress.Lang.Error :
            logger:Error(substitute('Error handling request for path &2 using handler &1', pcHandlerName, uriTemplate),
                         e).
            //We're not sure exactly what went wrong; send a general error
            return integer(StatusCodeEnum:InternalServerError).
        end catch.
    end method.
    
    /* Releases the specified handler from the cache. This lets it be cleaned up/GC'ed.
         
       @param character The handler to release.
       @return true if the instance was found and released. otherwise false. */
    method public logical Release(input pchandlerName as character).
        define variable lCached as logical no-undo.
        define buffer lbHandler for ttHandler.
        
        /* Check to see if we've used this handler for a previous request */
        if can-find(lbHandler where lbHandler.WebHandlerName eq pcHandlerName) then
            find lbHandler where lbHandler.WebHandlerName eq pcHandlerName.
        assign lCached = available lbHandler and valid-object(lbHandler.WebHandler).
        if lCached then
        do:
            logger:Debug(substitute('Handler &1 released from cache', pcHandlerName)).
            assign lbHandler.WebHandler = ?.
        end.
        
        return lCached.
    end method.
    
    /* Clears (empties) the entire handler cache. */
    method public void Clear():
        define buffer lbHandler for ttHandler.
        
        empty temp-table lbHandler.
        
        logger:Debug('Handler cache cleared').
    end method.
    
    /* Invokes/instantiates a webhandler
       
       @param character The webhandler name
       @return IWebHandler A usable webhandler instance      */
    method private IWebHandler InvokeHandler(input pHandlerName as character):
        define variable webHandler as IWebHandler no-undo.
        
        Assert:NotNullOrEmpty(pHandlerName, 'Web handler name').
        
        if valid-object(Ccs.Common.Application:ServiceManager) then
            assign webHandler = cast(Ccs.Common.Application:ServiceManager
                                                           :getService(get-class(IWebHandler), pHandlerName),
                                     IWebHandler)
                                no-error.
        
        if not valid-object(webHandler) then
        do:
            webHandler = dynamic-new pHandlerName ().
            
            if type-of(webHandler, ISupportInitialize) then
                cast(webHandler, ISupportInitialize):Initialize().
        end.
        
        return webHandler.
        finally:
            // for cases where there is a Service Manager but it does not handle IWebHandler
            assign error-status:error = false.
        end finally.
    end method.
    
end class.
