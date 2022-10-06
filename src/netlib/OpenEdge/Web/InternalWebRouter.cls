/************************************************
Copyright (c) 2015-2018, 2020 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.Logging.WebRequestTokenResolver.
using Progress.Web.AbstractWebRouter.
using Progress.Web.IWebHandler.
using Progress.Lang.AppError.

class OpenEdge.Web.InternalWebRouter
inherits AbstractWebRouter
final
implements ISupportLogging
         , ISupportInitialize
:
    /* A reference to the Logger in use by an implementer */
    define public property Logger as ILogWriter no-undo
        get():
            // If the property value is set, use that since that will have been a
            // deliberate act.
            //
            // If not set, then always ask for a new one, because this
            // class is run as a singleton, which means that the first logger will
            // be *the* logger for this router for the life of this session (which
            // breaks the administrator's ability to configure loggers).
            if valid-object(this-object:Logger) then
                return this-object:Logger.
            else
                return LoggerBuilder:GetLogger(get-class(OpenEdge.Web.InternalWebRouter)).
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
    define protected property Handlers as IStringKeyedMap no-undo
        get():
            if not valid-object(Handlers) then
                assign this-object:Handlers = new StringKeyedMap().
            
            return this-object:Handlers.
        end get.
        private set.
    
    /* Default constructor */
    constructor public InternalWebRouter():
        // This class is run as a singleton by the agent, so it's OK to run the Initialize() method
        Initialize().
    end constructor.
    
    /* Destructor/finalizer */
    destructor InternalWebRouter():
        // This class is run as a singleton by the agent, so it's OK to run the Destroy() method
        Destroy().
    end destructor.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        TokenResolver:TokenResolved:Unsubscribe(WebRequestTokenResolver:TokenResolvedHandler).
        this-object:Clear().
        assign this-object:Handlers = ?.
    end method.
    
    /* Initializer/Startup */
    method public void Initialize():
        assign this-object:Handlers = new StringKeyedMap().
        // This class is run as a singleton by the agent, so it's OK to subscribe to a static event
        // (also a singleton)
        // The Subscribe() syntax says for this event (TokenResolver:TokenResolved), subscribe a static
        // method (WebRequestTokenResolver:TokenResolvedHandler) to that event.
        // So when the TokenResolved event is published (from the TokenResolver's ResolveToken method),
        // the TokenResolvedHandler method is run.
        TokenResolver:TokenResolved:Subscribe(WebRequestTokenResolver:TokenResolvedHandler).
    end method.
    
    /* Handles a web request.  A customer can specify a different handler for
       each application.  If this is the first request for this handler or the
       cached handler is invalid, an instance of it is created.
         
       The HandleRequest() method is then invoked in the handler instance.
       
       @param pcHandlerName   the name of the customer registered webspeed handler */
    method public override integer HandleRequest(input pcHandlerName as character):
        define variable oWebHandler as IWebHandler no-undo.
        define variable uriTemplate as character no-undo.
        define variable requestPath as character no-undo.
        define variable httpMethod as character no-undo.
        
        assign requestPath = web-context:get-cgi-value('ENV':u, 'REQUEST_URI':u)
               uriTemplate = web-context:get-cgi-value('ENV':u, 'URI_TEMPLATE':u)
               httpMethod  = web-context:get-cgi-value('ENV':u, 'REQUEST_METHOD':u)
               .
        Assert:NotNullOrEmpty(pcHandlerName, 'Web handler name').
        
        logger:Debug(substitute('Request for path "&1" using template "&2" and handler "&3"',
                        requestPath,
                        uriTemplate,
                        pcHandlerName)).
        /* Get a handler instance. May come from the cache, may come from a CCS Service Manager, may be new */
        assign oWebHandler = InvokeHandler(pcHandlerName).
        
        Assert:NotNull(oWebHandler, 'URI Handler').
        
        logger:Debug(substitute('Handler instance &1 used for handler &2', oWebHandler:ToString(), pcHandlerName)).
        
        /* Invoke the registered URI handler */
        return oWebHandler:HandleRequest().
        
        // Stop conditions are considered timeouts: stop-after, user-interrupt, lock-conflict and use of the
        // STOP statement in ABL.
        catch s as Progress.Lang.Stop:
            // 1st arg: StopAfter, UserInterrupt, LockConflict, Stop
            logger:Error(substitute('Request timeout (&1) for "&2 &3" using handler &4',
                                    s:GetClass():TypeName, httpMethod, requestPath, pcHandlerName)).
            // All stops are timeouts
            return integer(StatusCodeEnum:RequestTimeOut).
        end catch.
        // Progress.Lang.StopError is raised for errors, not stops, so should be handled by the below catch block, since
        // it inherits P.L.Error. For example, if the code tries to run a non-existent .P, a StopError is raised.
        catch e as Progress.Lang.Error:
            logger:Error(substitute('Error handling request for "&1 &2" using handler &3',
                                     httpMethod, requestPath, pcHandlerName),
                         e).
            // We're not sure exactly what went wrong; send a general error
            return integer(StatusCodeEnum:InternalServerError).
        end catch.
    end method.
    
    /* Releases the specified handler from the cache. This lets it be cleaned up/GC'ed.
       
       @param character The handler to release.
       @return true if the instance was found and released. otherwise false. */
    method public logical Release(input pchandlerName as character):
        define variable lCached as logical no-undo.
        
        // the handler instance is returned, pre deletion
        assign lCached = valid-object(this-object:Handlers:Remove(pcHandlerName)).
        if lCached then
            logger:Debug(substitute('Handler &1 released from cache', pcHandlerName)).
        
        return lCached.
    end method.
    
    /* Clears (empties) the entire handler cache. */
    method public void Clear():
        this-object:Handlers:Clear().
        logger:Debug('Handler cache cleared').
    end method.
    
    /* Invokes/instantiates a webhandler.
       
       1) Try to get from a CCS Service Manager. If a handler is returned, use this value as-is, without
          caching. We ask for getService(IWebHandler, <web-handler-name>).
       2) If not in debug mode, look in the cache for a webhandler. If it's valid, use it.
       3) Instantiate a webhandler.
       4) If not in debug mode, cache it.
       
       @param character The webhandler name
       @return IWebHandler A usable webhandler instance      */
    method private IWebHandler InvokeHandler(input pHandlerName as character):
        var Progress.Lang.Object webHandler.
        var logical dbg.
        var Progress.Lang.Class plc.
        
        Assert:NotNullOrEmpty(pHandlerName, 'Web handler name').
        
        // 1) look in CCS Service Manager
        if valid-object(Ccs.Common.Application:ServiceManager) then
            assign webHandler = cast(Ccs.Common.Application:ServiceManager
                                                           :getService(get-class(IWebHandler), pHandlerName),
                                     IWebHandler)
                   no-error.
        if valid-object(webHandler) then
        do:
            Logger:Trace(substitute('WebHandler instance for "&1" obtained from Ccs.Common.IServiceManager', pHandlerName)).
            Assert:IsType(webHandler, get-class(IWebHandler)).
            
            return cast(webHandler, IWebHandler).
        end.
        
        // 2) If not in debug, look in our cache
        // NO-ERROR for cases where there is a Service Manager but it does not handle IWebHandler
        assign dbg = DebugEnabled
               no-error.
        Logger:Debug(substitute('Debug mode: &1', string(dbg, 'ON/OFF':u))).
        
        if dbg then
            this-object:Release(pHandlerName).
        else
            assign webHandler = cast(this-object:Handlers:Get(pHandlerName), IWebHandler).
        
        if valid-object(webHandler) then
        do:
            Logger:Trace(substitute('WebHandler instance for "&1" obtained from OpenEdge.Web.InternalWebRouter cache', pHandlerName)).
            
            return cast(webHandler, IWebHandler).
        end.
        
        // 3) create new webhandler
        assign plc = Progress.Lang.Class:GetClass(pHandlerName) no-error.
        if not valid-object(plc) then
            undo, throw new AppError(substitute('Class "&1" cannot be found on PROPATH', pHandlerName), 0).
        
        Assert:IsType(plc, get-class(IWebHandler)).
        
        webHandler = plc:New().
        
        if type-of(webHandler, ISupportInitialize) then
            cast(webHandler, ISupportInitialize):Initialize().
        
        // 4) If not debug, cache the new webhandler
        if not dbg then
        do:
            Logger:Trace(substitute('WebHandler "&1" instance &2 added to OpenEdge.Web.InternalWebRouter cache',
                                    pHandlerName, string(webHandler))).
            this-object:Handlers:Put(pHandlerName, webHandler).
        end.
        
        return cast(webHandler, IWebHandler).
    end method.
    
end class.
