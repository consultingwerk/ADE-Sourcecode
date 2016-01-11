/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : AuthFilterEventHandlerWrapper
    Purpose     : Provides a means to use procedure-based authentication callbacks
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 19 11:18:45 EDT 2015
    Notes       : * The procedure used must have an internal procedure that matches
                    the IAuthFilterEventHandler interface.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler.
using OpenEdge.Net.HTTP.AuthenticationRequestEventArgs.
using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.DataTypeEnum.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Auth.AuthFilterEventHandlerWrapper implements IAuthFilterEventHandler:
    &scoped-define EVENT_HANDLER_NAME AuthFilter_HttpCredentialRequestHandler
    &scoped-define EVENT_HANDLER_SIG PROCEDURE,,INPUT poSender PROGRESS.LANG.OBJECT,INPUT poEventArgs PROGRESS.LANG.OBJECT
    
    /** (mandatory) Contains the handle to the procedure performing the event handling */
    define public property Callback as handle no-undo get. private set.
    
    constructor public AuthFilterEventHandlerWrapper(input phCallbackProcedure as handle):
        Assert:NotNull(phCallbackProcedure, 'Callback').
              
        if phCallbackProcedure:type ne 'procedure':u then
            return error new AssertionFailedError('Callback is not a procedure handle (is of type )'
                                                  + phCallbackProcedure:type
                                                  , 0).
        
        if lookup('{&EVENT_HANDLER_NAME}':u, phCallbackProcedure:internal-entries) eq 0 then
            return error new AppError('Unable to find event handle procedure ~"{&EVENT_HANDLER_NAME}~" in callback procedure ' 
                                      + phCallbackProcedure:name
                                      , 0).
        
        if phCallbackProcedure:get-signature('{&EVENT_HANDLER_NAME}') ne '{&EVENT_HANDLER_SIG}':u then
            return error new AppError('The signature of {&EVENT_HANDLER_NAME} in '
                                      + phCallbackProcedure:name
                                      + ' does not match the interface definition in '
                                      + get-class(IAuthFilterEventHandler):TypeName
                                      , 0).
        
        assign this-object:Callback = phCallbackProcedure.
    end constructor.
        
    method public void AuthFilter_HttpCredentialRequestHandler(
            input poSender as Object,
            input poEventArgs as AuthenticationRequestEventArgs ):
        run AuthFilter_HttpCredentialRequestHandler in this-object:Callback (poSender, poEventArgs).            
    end method. 
    
end class.