/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IEventProvider
    Purpose     : Defines an interface for interacting with an Event Provider 
                  from an STS 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 27 16:09:05 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Security.Principal.
using Progress.Json.ObjectModel.JsonObject.

interface OpenEdge.Security.STS.IEventProvider:
    
    /* Records a named event. This is a one-way operation:
       nothing is returned from provider to the STS. 
     
       @param character (optional) The name of the STS sending this event
       @param character (optional) The name of the event to send.
       @param Principal (optional) The client-principal/token currently being processed in the STS
       @param JsonObject (optional) The domain context from the STS */
    method public void RecordEvent (input pcSender as character,
                                    input pcEventName as character,
                                    input poPrincipal as Principal,
                                    input poDomainCtx as JsonObject).

end interface.
