/* *************************************************************************************************************************
Copyright (c) 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : IOperationEventHandler
    Purpose     : Signatures for the DataObjectHandler operation-level events
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-03-27
    Notes       : * Classes that want to receive the DOH's messages SHOULD
                    implement this interface
  ----------------------------------------------------------------------*/

using OpenEdge.Web.DataObject.AuthorizeOperationEventArgs.
using OpenEdge.Web.DataObject.HandlerErrorEventArgs.
using OpenEdge.Web.DataObject.HandlerLoadEntityEventArgs.
using OpenEdge.Web.DataObject.OperationInvocationEventArgs.

interface OpenEdge.Web.DataObject.IOperationEventHandler:
    
    /* Event handler for the event published when an operation is Authorize 
       
       @param Progress.Lang.Object The handler publishing the event
       @param AuthoriseOperationEventArgs Event args for this event */
    method public void AuthorizeOperationHandler (input pSender as Progress.Lang.Object,
                                                  input pEventArgs as AuthorizeOperationEventArgs).
    
    /* Event handler for the event published when an error is encountered 
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    method public void OperationErrorHandler (input pSender as Progress.Lang.Object,
                                              input pEventArgs as HandlerErrorEventArgs). 
    
    /* Event handler for the event published to invoke/load a piece of business logic (aka Business Entity).
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerLoadEntityEventArgs Event args for this event */
    method public void LoadEntityHandler (input pSender as Progress.Lang.Object,
                                          input pEventArgs as HandlerLoadEntityEventArgs). 
    
    /* Event handler for the event published to unload a piece of business logic (aka Business Entity).
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerLoadEntityEventArgs Event args for this event */
    method public void UnloadEntityHandler (input pSender as Progress.Lang.Object,
                                            input pEventArgs as HandlerLoadEntityEventArgs). 
    
    /* Event handler for the event published before the business logic function is called by the handler
       
       @param Progress.Lang.Object The handler publishing the event
       @param OperationInvocationEventArgs Event args for this event */
    method public void InvokingHandler (input pSender as Progress.Lang.Object,
                                        input pEventArgs as OperationInvocationEventArgs). 
    
    /* Event handler for the event published after the business logic function was called by the handler 
       
       @param Progress.Lang.Object The handler publishing the event
       @param OperationInvocationEventArgs Event args for this event */
    method public void InvokedHandler (input pSender as Progress.Lang.Object,
                                       input pEventArgs as OperationInvocationEventArgs).  
  
end interface.