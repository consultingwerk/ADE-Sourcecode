/**************************************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
**************************************************************************/
 /*------------------------------------------------------------------------
    File        : AgentInfo.cls
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : aherbstr
    Created     : Tuesday July 8 2014
    Notes       : Used by the Server Broker tools to manage agent sessions.
  -----------------------------------------------------------------------*/

block-level on error undo, throw.

class OpenEdge.ApplicationServer.AgentInfo :
    
    define private variable AgentStats    as handle  no-undo.
    define private variable AgentThreads  as handle  no-undo.
    define private variable AgentSessions as handle  no-undo.
    define private variable AgentConnects as handle  no-undo.
    define private variable AgentRequests as handle  no-undo.
    
    define private variable retval        as logical no-undo.
    
    constructor public AgentInfo ():
        Progress.ApplicationServer.AgentInfo:archiveAgentStats = yes.
    end constructor.
    

    method public logical setArchiveAgentStats (input setValue as logical):
        Progress.ApplicationServer.AgentInfo:archiveAgentStats = setValue.
        retval = Progress.ApplicationServer.AgentInfo:archiveAgentStats.
        return retval.
    end method.

    method public logical getAgentStatData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentstatTableHandle(output AgentStats).
        pasThandle = AgentStats.
        if valid-handle(pasThandle) then retval = yes. 
        else retval = no.
        return retval.
    end method.
    
    method public logical getAgentThreadData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentThreadTableHandle(output AgentThreads).
        pasThandle = AgentThreads.
        if valid-handle(pasThandle) then retval = yes. 
        else retval = no.
        return retval.
    end method.

    method public logical getAgentSessionData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentsessionTableHandle(output AgentSessions).
        pasThandle = AgentSessions.
        if valid-handle(pasThandle) then retval = yes. 
        else retval = no.
        return retval.
    end method.

    method public logical getAgentConnectionData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentConnectionTableHandle(output AgentConnects).
        pasThandle = AgentConnects.
        if valid-handle(pasThandle) then retval = yes. 
        else retval = no.
        return retval.
    end method.

    method public logical getAgentRequestData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output AgentRequests).
        pasThandle = AgentRequests.
        if valid-handle(pasThandle) then retval = yes. 
        else retval = no.
        return retval.
    end method.

    method public logical getAgentStacks (output mptr as memptr):
      return Progress.ApplicationServer.AgentInfo:GetAgentStacks(output mptr).
    end method.

    method public logical getAgentSessionStack (input sessid as char,
                                                output mptr as memptr):
      return Progress.ApplicationServer.AgentInfo:GetAgentSessionStack(sessid,
                                                                 output mptr).
    end method.
    
end class.

