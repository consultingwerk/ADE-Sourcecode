/**************************************************************************
Copyright (c) 2014,2017 by Progress Software Corporation. All rights reserved.
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
    /* Default constructor */
    constructor public AgentInfo ():
        setArchiveAgentStats(true).
    end constructor.
    
    /* Toggles the agent stats archive on and off
       
       @param logical TRUE to enabled archiving; FALSE to disable
       @return logical TRUE when stats are archived, false otherwise */
    method public logical setArchiveAgentStats (input setValue as logical):
        Progress.ApplicationServer.AgentInfo:archiveAgentStats = setValue.
        
        return Progress.ApplicationServer.AgentInfo:archiveAgentStats.
    end method.

    method public logical getAgentStatData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentstatTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.
    
    method public logical getAgentThreadData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentThreadTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.

    method public logical getAgentSessionData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentsessionTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.

    method public logical getAgentConnectionData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentConnectionTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.

    method public logical getAgentRequestData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.
    
    /* Returns the agent call stack for all sessions
       
       @param longchar out JSON representation of the stack 
       @return logical  */
    method public logical getAgentStacks (output pStacks as longchar):
        define variable mptr as memptr no-undo.
        define variable retVal as logical no-undo.
        
        assign retVal = Progress.ApplicationServer.AgentInfo:GetAgentStacks(mptr).
        copy-lob from mptr 
                 // JSON data is spec'ed as UTF-8
                 to pStacks convert target codepage 'utf-8':u.
        
        return retVal.
        finally:
            set-size(mptr) = 0.
        end finally. 
    end method.
    
    /* Returns the agent call stack for a given session
       
       @param character The session id for which to return a call stack
       @param longchar out JSON representation of the stack 
       @return logical  */
    method public logical getAgentSessionStack (input  sessid as character,
                                                output pStack as longchar):
        define variable mptr as memptr no-undo.
        define variable retVal as logical no-undo.
        
        assign retVal = Progress.ApplicationServer.AgentInfo:GetAgentSessionStack(sessid, mptr).
        copy-lob from mptr 
                 // JSON data is spec'ed as UTF-8
                 to pStack convert target codepage 'utf-8':u.
        
        return retVal.
        finally:
            set-size(mptr) = 0.
        end finally. 
    end method.

    /* Returns the number of agent requests being monitored 
       
       return int64 The number of agent requests. Returns -1 if not enabled */
    method public int64 getAgentRequestQty ( ):
        define variable hTempTable as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable hQuery  as handle no-undo.
        define variable queryStr as character no-undo. 
        define variable qty as int64 no-undo.
        
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output hTempTable). 
        if not valid-object(hTempTable) then return -1. 

        hBuffer = hTempTable:default-buffer-handle.
        create query hQuery.
        hQuery:add-buffer(hBuffer).
        queryStr = "preselect each ":u + hBuffer:name + " no-lock ":u.
        hQuery:query-prepare(queryStr).
        hQuery:query-open().
        qty = hQuery:num-results.
        return qty.

        finally:
            if valid-object(hQuery) then
            do:
                if hQuery:is-open then
                    hQuery:query-close.
                delete object hQuery no-error.
            end.
        end finally.
    end method.
end class.
