/**************************************************************************
Copyright (c) 2014,2017-2018,2021 by Progress Software Corporation. All rights reserved.
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

    /* Constructor */
    constructor public AgentInfo ( ):
        setArchiveAgentStats(true).
    end constructor.
    
    /* Destructor */
    destructor AgentInfo ( ):
        setArchiveAgentStats(false).
    end destructor.
    
    /* Empties the cached agent request stats */
    method public void clearAgentStatData ( ):
        define variable statsData as handle no-undo.
        
        /* Clear the agent request table */
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output statsData).
        if valid-handle(statsData) then
            statsData:empty-temp-table().
    end method.
    
    /* Toggles the agent stats archive on and off. If we turn gathering
       stats OFF (a FALSE parameter) then we also empty the cached stats
       
       @param logical TRUE to enabled archiving; FALSE to disable
       @return logical TRUE when stats are archived, false otherwise */
    method public logical setArchiveAgentStats (input setValue as logical):
        Progress.ApplicationServer.AgentInfo:archiveAgentStats = setValue.
        
        if not Progress.ApplicationServer.AgentInfo:archiveAgentStats then
            clearAgentStatData().
        
        return Progress.ApplicationServer.AgentInfo:archiveAgentStats.
    end method.

    /* Returns the agent statistics

       @param table-handle agent statistics data
       @return logical */
    method public logical getAgentStatData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentstatTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.
    
    method public logical getAgentThreadData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentThreadTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.

    /* Returns the status of all agent sessions

       @param table-handle agent session data
       @return logical */
    method public logical getAgentSessionData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentSessionTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.

    /* Returns the status of a specific agent session

       @param character in session id 
       @param table-handle agent session data
       @return logical */
    method public logical getAgentSessionData (input  agentSessId as integer,
                                               output table-handle hTTCopy):
        define variable hTTSrcBuffer  as handle no-undo.
        define variable hTTCopyBuffer as handle no-undo.
        define variable pasThandle    as handle no-undo.

        Progress.ApplicationServer.AgentInfo:getAgentSessionTableHandle(output pasThandle).

        /* Create dynamic temp-table */
        create temp-table hTTCopy.
    
        /* Copy the schema from the one passed in */
        hTTCopy:create-like(pasThandle).

        /* Get the new temp-table ready and name it AgentSession */
        hTTCopy:temp-table-prepare("AgentSession").    
      
        /* Get the default buffer for both source and target tables */
        assign 
            hTTSrcBuffer  = pasThandle:default-buffer-handle 
            hTTCopyBuffer = hTTCopy:default-buffer-handle
            . 

        /* Fetch specific record from source table where session ID matches */
        hTTSrcBuffer:find-first(substitute("where &1._Session-Id eq &2", pasThandle:name, agentSessId)) no-error.
        if hTTSrcBuffer:available then do:
            /* Create record and copy from source */
            hTTCopyBuffer:buffer-create().
            hTTCopyBuffer:buffer-copy(hTTSrcBuffer).
            hTTCopyBuffer:buffer-release().
        end.

        return valid-handle(hTTCopy).
        
        finally:
            delete object hTTCopy. 
        end finally.
    end method.

    /* Returns the agent connection data

       @param table-handle agent connection data
       @return logical */
    method public logical getAgentConnectionData (output table-handle pasThandle):
        Progress.ApplicationServer.AgentInfo:getAgentConnectionTableHandle(output pasThandle).
        
        return valid-handle(pasThandle).
    end method.

    /* Returns the last 1000 requests for this agent

       This method used to give all the requests that are running on the agent.
       But because of the Issue:PSC00364863, we limited the API to return only
       last 1000 requests information.

       @param table-handle agent request data
       @return logical */
    method public logical getAgentRequestData (output table-handle hTTCopy):
        define variable hTTSrcBuffer  as handle  no-undo.
        define variable hTTCopyBuffer as handle  no-undo.
        define variable hQuery        as handle  no-undo.
        define variable iCounter      as integer no-undo.
        define variable pasThandle    as handle  no-undo.
        
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output pasThandle).
        
        /* Create dynamic temp-table */
        create temp-table hTTCopy.
    
        /* Copy the schema from the one passed in */
        hTTCopy:create-like(pasThandle).
    
        /* Get it ready and name it - in this case, AgentRequest is the new temp-table name */
        hTTCopy:temp-table-prepare("AgentRequest").    
      
        /* Get the default buffer for both source and target tables */
        assign 
            hTTSrcBuffer  = pasThandle:default-buffer-handle 
            hTTCopyBuffer = hTTCopy:default-buffer-handle
            . 
    
        /* scan the source temp-table, in reverse order, and copy only the last
           1000 records. First create query to fetch records from source table */      
        create query hQuery.
        hQuery:set-buffers(hTTSrcBuffer).
        hQuery:query-prepare(substitute("for each &1", pasThandle:name)).
        hQuery:query-open().
        /* get last one, to do reverse fetching */
        hQuery:get-last().
     
        /* loop through until query returns no more records */
        do while not hQuery:query-off-end:
            iCounter = iCounter + 1.
       
            /* Create record and copy from source */
            hTTCopyBuffer:buffer-create().
            hTTCopyBuffer:buffer-copy(hTTSrcBuffer).
            hTTCopyBuffer:buffer-release().
       
            /* Stop when we create 100 records */
            if iCounter = 1000 then       
            COUNTBLK:
            do:
                leave COUNTBLK.           
            end.
       
            /* get previous record */
            hQuery:get-prev().
        end.

        return valid-handle(hTTCopy).
        
        finally:
            if valid-object(hQuery) then
            do:
                if hQuery:is-open then
                    hQuery:query-close.
                delete object hQuery no-error.
            end.

            delete object hTTCopy. 
        end finally.
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
    
    /* Returns the agent dynamic ABL session info
       
       @param longchar out JSON representation of the stack 
       @return logical  */
    method public logical GetDynamicABLSessionLimitInfo (output sessionInfo as longchar):
        define variable mptr as memptr no-undo.
        define variable retVal as logical no-undo.
        
        assign retVal = Progress.ApplicationServer.AgentInfo:GetDynamicABLSessionLimitInfo(mptr).

        copy-lob from mptr // JSON data is spec'ed as UTF-8
            to sessionInfo convert target codepage 'utf-8':u.
        
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
        define variable sessid_int as integer no-undo.
        define variable use_int as logical no-undo initial no.

        if length(sessid) le 10 then do:
            sessid_int = integer(sessid) no-error.
            if not error-status:error then
               use_int = yes.
        end.

        if use_int then
           retVal = Progress.ApplicationServer.AgentInfo:GetAgentSessionStack(sessid_int, mptr).
        else
           retVal = Progress.ApplicationServer.AgentInfo:GetAgentSessionStack(sessid, mptr).

        copy-lob from mptr 
                 // JSON data is spec'ed as UTF-8
                 to pStack convert target codepage 'utf-8':u.
        
        return retVal.

        finally:
            set-size(mptr) = 0.
        end finally. 
    end method.

    /* Returns the agent call stack for a given session
       
       @param integer The agent session id for which to return a call stack
       @param longchar out JSON representation of the stack 
       @return logical  */
    method public logical getAgentSessionStack (input  sessid as integer,
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

    method public logical getClientSessionID(input  agentSessId  as integer,
                                             output clientSessId as character):
        return Progress.ApplicationServer.AgentInfo:GetClientSessionID(input  agentSessId,
                                                                       output clientSessId).
    end method.

    method public integer getAgentSessionID(input clsessid as character):
        return Progress.ApplicationServer.AgentInfo:GetAgentSessionID(clsessid).
    end method.

    /* Returns the number of agent requests being monitored 
       
       @return int64 The number of agent requests. Returns -1 if not enabled */
    method public int64 getAgentRequestQty ( ):
        define variable pasThandle as handle no-undo.
        define variable hBuffer    as handle no-undo.
        define variable hQuery     as handle no-undo.
        define variable qty        as int64  no-undo.
        
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output pasThandle). 
        if not valid-object(pasThandle) then return -1.

        hBuffer = pasThandle:default-buffer-handle.
        create query hQuery.
        hQuery:add-buffer(hBuffer).
        hQuery:query-prepare(substitute("preselect each &1 no-lock", hBuffer:name)).
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

    /* Returns the active request for a given sessionID

       @param character in session id 
       @param table-handle request info for the given session id */
    method public void getAgentActiveRequestData (input  sessionId as character,
                                                  output table-handle hTTCopy):
        define variable hTTSrcBuffer  as handle no-undo.
        define variable hTTCopyBuffer as handle no-undo.
        define variable hQuery        as handle no-undo.
        define variable pasThandle    as handle no-undo.
        
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output pasThandle).
        
        /* create dynamic temp-table */
        create temp-table hTTCopy.
    
        /* Copy the schema from the one passed in */
        hTTCopy:create-like(pasThandle).
    
        /* Get it ready and name it - in this case, AgentRequest is the new temp-table name */
        hTTCopy:temp-table-prepare("AgentActiveRequest").    
    
        /* Get the default buffer for both source and target tables */
        assign 
            hTTSrcBuffer  = pasThandle:default-buffer-handle 
            hTTCopyBuffer = hTTCopy:default-buffer-handle
            . 
    
        /* First create query to fetch records from source table */      
        create query hQuery.
        hQuery:set-buffers(hTTSrcBuffer).
        hQuery:query-prepare(substitute("for each &1", pasThandle:name)).
        hQuery:query-open().
     
        QUERYBLK:
        repeat:
            hQuery:get-next().
            if hQuery:query-off-end then leave QUERYBLK. 
		
            if hTTSrcBuffer:buffer-field("_Request-BrokerSessionId"):buffer-value eq sessionId then
            do:
                /* Create record and copy from source */
                hTTCopyBuffer:buffer-create().
                hTTCopyBuffer:buffer-copy(hTTSrcBuffer).
                hTTCopyBuffer:buffer-release().
            end.
        end.

        /* Done with query */
        finally:
            if valid-object(hQuery) then
            do:
                if hQuery:is-open then
                    hQuery:query-close.
                delete object hQuery no-error.
            end.

            delete object hTTCopy. 
        end finally.
    end method.

end class.
