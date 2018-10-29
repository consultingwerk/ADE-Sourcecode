/*************************************************************************
Copyright (c)  2015, 2018 by Progress Software Corporation. All rights reserved.
**************************************************************************/ 
/*------------------------------------------------------------------------
   Purpose     : Provide dispatching for WebSpeed for the PAS Web transport
   Usage       : Define as defaultHandler in openedge.properties for the WEB transport
   Description : Manages startup of web/objects/web-handler.p and passes requests 
                 to its process-web-request. The web-handler.p is a PAS variation 
                 of the classic web-disp procedure.
                 This allows classic webSpeed applications and tools to run in a 
                 PAS web application.
   Author(s)   : hdaniels 
   Created     : March 27 2015
   Notes       : Intended for migration of existing WebSpeed applications.
                 It is generally recommended that new web development for PAS web
                 transport use an implementation of the IWebHandler class that manages 
                 the requests using OpenEdge.NetLib as base classes.   
               - The launched default web-handler procedure and WebSpeed utilities
                 have no knowledge of this class and does not have any reference 
                 to the OpenEdge.NetLib.pl  
                                   
   @since      : 11.6
----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.IHttpRequest from propath.
using OpenEdge.Net.HTTP.IHttpResponse from propath.
using Progress.Lang.AppError from propath.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.StatusCodeEnum.

class OpenEdge.Web.CompatibilityHandler implements Progress.Web.IWebHandler, ISupportLogging:
    /* A reference to the Logger in use by an implementer. Should ALWAYS return a valie value, even if its the VoidLogger */
    define public property Logger as OpenEdge.Logging.ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(OpenEdge.Web.CompatibilityHandler)).
            
            return this-object:Logger.
        end get.
        set.
    
    define protected property AllowedMethods as char no-undo init "POST,GET":U get. set.
    
    /* Private variable for lazy-load */
    define private variable mProcHandle as handle no-undo.
    
    /* Keep track of web-handler.p  */
    define protected property ProcedureHandle as handle no-undo
        get ().
            if not valid-handle(mProcHandle) then 
                assign mProcHandle = StartProcedure().
            
            return mProcHandle. 
        end. 
        set(input pProcHandle as handle):
            // if there's an already-running procedure, delete it. By default we want this to act as a singleton
            StopProcedure().
            
            assign mProcHandle = pProcHandle.
        end set.
    
    /* default constructor */
    constructor public CompatibilityHandler():
    end constructor.
    
    /**
     * Handle a web request. 
     */
    method public integer HandleRequest( ):
        define variable cMethod as character no-undo.
        
        cMethod = web-context:get-cgi-value ("ENV":U,"REQUEST_METHOD":U).
        if lookup(cMethod,AllowedMethods) = 0 then
        do:
            this-object:Logger:Info(substitute('HTTP Method &1 is is not supported by WebSpeed compatibility handler (&2)',
                                        cMethod, string(this-object) )).
            
            return integer(StatusCodeEnum:MethodNotAllowed).
        end.
        
        run process-web-request in ProcedureHandle.
        
        return 0.
    end method.

   /* Start the web-handler procedure. This PAS replacement of 
      web-disp.p initialize all utilities and super procedures
      the same way web-disp does (it calls paswebstart.p, an 
      extention of webstart, from the main block) 
      @todo read procedure name from config */
    method protected handle StartProcedure():
        define variable procHdl as handle no-undo.
        
        run web/objects/web-handler.p persistent set procHdl.
        
        return procHdl.
    end method.
    
    /* Stops any running web-handler procedure. */ 
    method protected void StopProcedure():
        if valid-handle(mProcHandle) then
        do:
            apply "close":U to mProcHandle.
            delete procedure mProcHandle no-error.
            
            assign mProcHandle = ?
                   no-error. 
        end.
    end method.
    
    /* Clean up the persistent procedure */
    destructor public CompatibilityHandler ( ):
        StopProcedure().
    end destructor.
    
end class.
