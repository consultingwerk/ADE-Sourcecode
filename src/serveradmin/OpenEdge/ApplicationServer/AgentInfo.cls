/**************************************************************************
Copyright (c) 2014,2017-2018 by Progress Software Corporation. All rights reserved.
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
    
    /* Destructor */
    destructor AgentInfo():
        setArchiveAgentStats(false).
    end.
    
    /* Empties the cached agent request stats */
    method public void clearAgentStatData():
        define variable statsData as handle no-undo.
        
    /* clear the agent request table */

    Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output statsData).
    if valid-handle(statsData) then
        statsData:empty-temp-table().

    end method.
    
    /* Toggles the agent stats archive on and off.
       
       If we turn gathering stats OFF (a FALSE parameter) then we also
       empty the cached stats
       
       @param logical TRUE to enabled archiving; FALSE to disable
       @return logical TRUE when stats are archived, false otherwise */
    method public logical setArchiveAgentStats (input setValue as logical):
        Progress.ApplicationServer.AgentInfo:archiveAgentStats = setValue.
        
        if not Progress.ApplicationServer.AgentInfo:archiveAgentStats then
            clearAgentStatData().
        
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

   /*
    This method used to give all the requests that are running on the agent.
    But because of the Issue:PSC00364863, we limited the API to return only
    last 1000 requests information.
    */
    method public logical getAgentRequestData (output table-handle hTTCopy):
        
        DEFINE VARIABLE hTTSrcBuffer  AS HANDLE NO-UNDO.
        DEFINE VARIABLE hTTCopyBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE hQuery        AS HANDLE NO-UNDO.
        DEF    VAR      iCounter      AS INT    NO-UNDO.
        def    var      pasThandle    as HANDLE NO-UNDO.
        
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output pasThandle).
        
        /* create dynamic temp-table */
        CREATE TEMP-TABLE hTTCopy.
    
        /* Copy the schema from the one passed in */
        hTTCopy:CREATE-LIKE (pasThandle).
    
      
        /* Get it ready and name it - in this case, AgentRequest is the new temp-table name */
        hTTCopy:TEMP-TABLE-PREPARE("AgentRequest").    
    
      
        /* Get the default buffer for both source and target tables */
        ASSIGN 
            hTTSrcBuffer  = pasThandle:DEFAULT-BUFFER-HANDLE 
            hTTCopyBuffer = hTTCopy:DEFAULT-BUFFER-HANDLE. 
    
        /* scan the source temp-table, in reverse order, and copy only the last
           1000 records. First create query to fetch records from source table */      
     
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS(hTTSrcBuffer).
        hQuery:QUERY-PREPARE("FOR EACH " +  pasThandle:NAME).
     
        hQuery:QUERY-OPEN().
        /* get last one, to do reverse fetching */
        hQuery:GET-LAST().
     
        /* loop through until query returns no more records */
        DO WHILE NOT hQuery:QUERY-OFF-END:
       
            iCounter = iCounter + 1.
       
            /* Create record and copy from source */
            hTTCopyBuffer:BUFFER-CREATE().
            hTTCopyBuffer:BUFFER-COPY(hTTSrcBuffer).
            hTTCopyBuffer:BUFFER-RELEASE().
       
            /* Stop when we create 100 records */
            IF iCounter = 1000 THEN       
            DO:
                LEAVE.           
            END.
       
            /* get previous record */
            hQuery:GET-PREV().
        END.
     
        /* Done with query */
        hQuery:QUERY-CLOSE().
        DELETE OBJECT hQuery.     
        
        return valid-handle(hTTCopy).
        
        FINALLY:
            delete object hTTCopy. 
        END FINALLY.

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
        define variable sessid_int as int no-undo.
        define variable use_int as logical no-undo initial no.

        if length(sessid) LE 10 then do:
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

    method public logical getClientSessionID(input agentsessid as int,
                                             output clientsessid as char):
      return Progress.ApplicationServer.AgentInfo:GetClientSessionID(
                                                         input  agentsessid,
                                                         output clientsessid).
    end method.

    method public integer getAgentSessionID(input clsessid as char):
      return Progress.ApplicationServer.AgentInfo:GetAgentSessionID(clsessid).
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
