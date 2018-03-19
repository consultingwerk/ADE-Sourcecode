/**************************************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
**************************************************************************/
 /*------------------------------------------------------------------------
    File        : AgentManager.cls
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : aherbstr
    Created     : Tuesday July 8 2014
    Notes       : Used by the Server Broker tools to manage agent sessions.
  -----------------------------------------------------------------------*/

block-level on error undo, throw.

class OpenEdge.ApplicationServer.AgentManager:

    define private variable pasam as class Progress.ApplicationServer.AgentManager.
    
    method public logical cancelRequest(input brokerSessionId as character,
                                        input requstId        as character):
        return pasam:cancelRequest(brokerSessionId, requstId).
    end method.
    
    method public integer terminateFreeABLSessions(input numSessions as integer):
        return pasam:terminateFreeSessions(numSessions).
    end method.
    
    method public logical terminateABLSession(input brokerSessionId as character,
                                              input terminateOption as integer):
        return pasam:terminateSession(brokerSessionId, terminateOption).
    end method.
    
    method public logical stopAgent():
        return pasam:stopAgent().
    end method.
    
    method public logical InitiateDebugger(input connectstring as character):
        return pasam:InitiateDebugger(connectstring).
    end method.
    
    method public logical dynamicPropertiesUpdate(input dynamicPropertiesString as character):
        return pasam:DynamicPropertiesUpdate(dynamicPropertiesString).
    end method.
    
    constructor public AgentManager():
        pasam = new Progress.ApplicationServer.AgentManager().
    end constructor.
    
end class.

