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

    method public logical terminateFreeABLSession(input agentSessionId as integer):
        return pasam:terminateFreeSession(agentSessionId).
    end method.
    
    method public logical terminateABLSession(input brokerSessionId as character,
                                              input terminateOption as integer):
        return pasam:terminateSession(brokerSessionId, terminateOption).
    end method.
    
    method public logical terminateABLSession(input agentSessionId as integer,
                                              input terminateOption as integer):
        return pasam:terminateSession(agentSessionId, terminateOption).
    end method.

    method public logical stopAgent():
        return pasam:stopAgent().
    end method.
    
    method public logical stopAgent(input waitToFinish as int,
                                    input waitAfterStop as int):
        return pasam:stopAgent(waitToFinish, waitAfterStop).
    end method.
    
    method public logical InitiateDebugger(input connectstring as character):
        return pasam:InitiateDebugger(connectstring).
    end method.
    
    method public logical DebugTest(INPUT operation AS Char,
                                    INPUT modifiers AS Char,
                                    INPUT iparm AS Int,
                                    INPUT cparm AS Char,
                                    OUTPUT intoutparm AS Int,
                                    OUTPUT lcharoutparm AS Longchar):
        return pasam:DebugTest(operation, modifiers, iparm, cparm,
                               OUTPUT intoutparm, OUTPUT lcharoutparm).
    end method.
    
    method public logical dynamicPropertiesUpdate(input dynamicPropertiesString as character):
        return pasam:DynamicPropertiesUpdate(dynamicPropertiesString).
    end method.

    method public logical TrackABLObjects(INPUT toggle AS Logical):
        return pasam:TrackABLObjects(toggle).
    end method.

    method public logical TrackingABLObjects():
        return pasam:TrackingABLObjects().
    end method.

    method public logical GetABLObjectsReport(OUTPUT jsonrpt AS Longchar):
        return pasam:GetABLObjectsReport(OUTPUT jsonrpt).
    end method.

    method public logical GetABLObjectsReport(INPUT AgentSessId AS Integer,
                                              OUTPUT jsonrpt AS Longchar):
        return pasam:GetABLObjectsReport(AgentSessId, OUTPUT jsonrpt).
    end method.

    method public logical TrackMemoryUse(INPUT toggle AS Logical):
        return pasam:TrackMemoryUse(toggle).
    end method.

    method public logical TrackingMemoryUse():
        return pasam:TrackingMemoryUse().
    end method.

    method public logical GetMemoryUseReport(OUTPUT jsonrpt AS Longchar):
        return pasam:GetMemoryUseReport(OUTPUT jsonrpt).
    end method.

    method public logical GetMemoryUseReport(INPUT AgentSessId AS Integer,
                                             OUTPUT jsonrpt AS Longchar):
        return pasam:GetMemoryUseReport(AgentSessId, OUTPUT jsonrpt).
    end method.

    METHOD PUBLIC LOGICAL PushProfilerData (
                                INPUT  Url               AS CHARACTER,
                                INPUT  RequestCount      AS INTEGER,
                                INPUT  SettingsJson      AS LONGCHAR):
        return pasam:PushProfilerData(Url, RequestCount, SettingsJson).
    END METHOD.

    METHOD PUBLIC LOGICAL GetProfilerSettings (OUTPUT Settings as LONGCHAR):
        return pasam:GetProfilerSettings(OUTPUT Settings).
    END METHOD.

    method public logical flushDeferredLog():
        return pasam:flushDeferredLog().
    end method.
    
    method public logical resetDeferredLog():
        return pasam:resetDeferredLog().
    end method.
    
    constructor public AgentManager():
        pasam = new Progress.ApplicationServer.AgentManager().
    end constructor.
    
end class.

