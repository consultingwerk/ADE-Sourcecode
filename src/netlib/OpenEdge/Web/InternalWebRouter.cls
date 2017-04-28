/************************************************
Copyright (c)  2015-2016 by Progress Software Corporation. All rights reserved.
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

using Progress.Web.AbstractWebRouter.
using Progress.Web.IWebHandler.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.

class OpenEdge.Web.InternalWebRouter
    inherits AbstractWebRouter
    final:
    
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
        define buffer lbHandler for ttHandler.
        
        if DebugEnabled then
        do:
            /* in case it's already cached */
            this-object:Release(pcHandlerName).
            /* always use a new  handler instance */
            oWebHandler = dynamic-new pcHandlerName ().

            if type-of(oWebHandler, ISupportInitialize) then
                cast(oWebHandler, ISupportInitialize):Initialize().
        end.
        else
        do:
            /* Check to see if we've used this handler for a previous request */
            find lbHandler where lbHandler.WebHandlerName eq pcHandlerName no-error.        
            
            /* Create a record for the handler if it does not exist */    
            if not available lbHandler then
            do:
                create lbHandler.
                assign lbHandler.WebHandlerName = pcHandlerName.
            end.
            
            /* Create an instance of the handler if necessary */
            if not valid-object(lbHandler.WebHandler) then
            do: 
                lbHandler.WebHandler = dynamic-new lbHandler.WebHandlerName ().
                
                if type-of(lbHandler.WebHandler, ISupportInitialize) then
                    cast(lbHandler.WebHandler, ISupportInitialize):Initialize().
            end.
                
            assign oWebHandler = cast(lbHandler.WebHandler,IWebHandler).
        end.
        
        Assert:NotNull(oWebHandler, 'URI Handler').
        
        /* Invoke the registered URI handler */
        return oWebHandler:HandleRequest(). 
    end method.
    
    /* Releases the specified handler from the cache. This lets it be cleaned up/GC'ed.
         
       @param character The handler to release.
       @return true if the instance was found and released. otherwise false. */
    method public logical Release(input pchandlerName as character).
        define variable lCached as logical no-undo.
        define buffer lbHandler for ttHandler.
        
        /* Check to see if we've used this handler for a previous request */
        find lbHandler where lbHandler.WebHandlerName eq pcHandlerName no-error.
        assign lCached = available lbHandler and valid-object(lbHandler.WebHandler).
        if lCached then
            assign lbHandler.WebHandler = ?.
        
        return lCached.
    end method.    

    /* Clears (empties) the entire handler cache. */
    method public void Clear():
        define buffer lbHandler for ttHandler.
        
        empty temp-table lbHandler.
    end method.
    
end class.
