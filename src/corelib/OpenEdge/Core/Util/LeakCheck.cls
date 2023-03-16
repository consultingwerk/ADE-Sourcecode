/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LeakCheck
    Purpose     : Parses a LOG-MANAGER file for DYNOBJECTS entries and
                  determines whether there are any memory leaks
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-02-04
    Notes       : * To exclude any groups of object from tracking, set the ExcludeGroups property to a CSV list of groups
                    to exclude.
                  * If widget-pools are tracked, only 'program' pools are tracked. This excludes the pools created by the
                    USE-WIDGET-POOL phrase and the session widget-pool
                  * If any log lines cannot be parsed, an error is logged. If the number of line parse failures hits
                    the MaxErrorLines threshold, then parsing for that file stops.
                  * Groups are one of
                   - PROCEDURE (type=procedure name)
                   - PLO (type=OOABL type name)
                   - DATA (type=BUFFER | DATASET | TEMP-TABLE | DATA-SOURCE)
                   - XML (type=X-DOCUMENT | X-NODEREF | SAX-READER | SAX-WRITER | SAX-ATTRIBUTES | SOAP-HEADER | SOAP-HEADER-ENTRYREF)
                   - BLOB (type=MEMPTR)
                   - WIDGET-POOL (type=PROGRAM | PERSISTENT)
                   - HANDLE (Anything else)
                  *  The JSON structure for the leak reports is
                   {
                    "filter": <the group or session used to filter, or null>
                    "sessions": {
                        <session-id>: {
                            "cnt": <leak count>
                            "size": <bytes leaked for session>
                            "req": {
                                <request-id>: {
                                    "cnt": <leak count>
                                    "size": <bytes leaked for session>
                                }
                            }
                        }
                    },
                    "groups": {
                        <group>: {
                            "cnt": <leak count>
                            "size": <bytes leaked for group>
                        }
                    },
                    "objects" : [
                         {
                            "session": <PID | PID Session-ID>
                            "grp": <PROCEDURE|PLO|DATA|XML|BLOB|HANDLE|WIDGET-POOL>
                            "type": <OOABL type or procedure name|widget type|MEMPTR>
                            "id": <handle or internal id>
                            "req": <the PASOE request id or null>
                            "info": <information about where this object was created>
                            "size": <either null or a positive value>
                            "pool": <the name of the widget pool this object was created in, or null>
                            "created": <the timestamp wheen the object was creaetd>
                            "line": <the line on which the object creation happened in the log
                            "log": <the name of the logfile this record was created>
                            "action": <CREATE|DELETE|DELETE-PENDING>
                            "rel": <optionally the related record (so a DELETE for a CREATE and vice versa)>
                         }
                    ]
                   }
                - Which data is returned depends on the report parameters in LeakReportParameters
                - Sessions will only have request information if there are any leaks detected in a request. This is also only
                  relevent for PAS agent logs
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.LeakReportFilterTypeEnum.
using OpenEdge.Core.Util.LeakReportParameters.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LoggerBuilder.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

@since(rel='12.6.0').
class OpenEdge.Core.Util.LeakCheck:
    define private stream sLog.
    
    /* A logger reference. Used in case of parsing errors */
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
            
            return this-object:Logger.
        end get.
        set.
    
    // A list of the groups created during parsing
    define private variable mGroups as character no-undo
                            initial 'PROCEDURE,PLO,DATA,XML,BLOB,HANDLE,WIDGET-POOL'.
    
    // The entry numbers of various parts of the log lines. These are the un-offset values
    define private variable ENTRY_TIMESTAMP as integer no-undo initial 1.
    define private variable ENTRY_PID       as integer no-undo initial 2.
    define private variable ENTRY_SID       as integer no-undo initial 5.
    define private variable ENTRY_RID       as integer no-undo initial 6.
    
    // These entries are used after the context is stripped off, no need to offset
    define private variable ENTRY_ACTION as integer no-undo initial 1.
    define private variable ENTRY_GROUP  as integer no-undo initial 2.
    define private variable ENTRY_ID     as integer no-undo initial 3.
    define private variable ENTRY_HANDLE as integer no-undo initial 4.
    define private variable ENTRY_SIZE   as integer no-undo initial 5.
    
    // Holds all of the objects created in this log.
    {OpenEdge/Core/Util/leakobject.i &ACCESS-LEVEL=PRIVATE &TABLE-PREFIX=t}
    
    // Aggregates leak data for a report. Created when a report is requested
    define private temp-table tReportHeader no-undo
        field ReportContext as character       // Session, Group or Request id, depending on Type
        field Type          as character       // GRP / REQ / SESSION
        field LeakCount     as integer
        field LeakSize      as int64
        index idx1 as primary unique ReportContext
        .
    /* A comma-separated list of groups to exclude. Defaults to WIDGET-POOL. */
    define public property ExcludeGroups as character no-undo
        get.
        set.
    
    /* The maximum number of error lines allowed, before the parser completes. If 0, then all lines are parsed. Initial value
       is 5 */
    define public property MaxErrorLines as int64 no-undo
        get.
        set.
    
    /* Default constructor */
    constructor public LeakCheck():
        assign this-object:ExcludeGroups = ''
               this-object:MaxErrorLines = 5
               .
    end constructor.
    
    /* Are there any memory leaks in the scanned log(s)?
       
       @return logical TRUE if there are leaks detected. FALSE if no scan has been done, or if there are no leaks. */
    method public logical HasLeaks():
        return can-find (first tObject
                         where tObject.Action eq 'CREATE'
                           and tObject.RelatedObject eq ?).
    end method.
    
    /* Are there any memory leaks in the scanned log(s), for a specific group?
      
       @param character A group. If the group is not in the list above, will look for any leak
       @return logical TRUE if there are leaks detected in that group. FALSE if no scan has been done, or if there are no leaks. */
    method public logical HasLeaksForGroup(input pGrp as character):
        // not a valid group
        if pGrp eq ?
        or lookup(pGrp, mGroups) eq 0
        then
            return this-object:HasLeaks().
        else
            return can-find (first tObject
                             where tObject.Action eq 'CREATE'
                               and tObject.RelatedObject eq ?
                               and tObject.Grp eq pGrp).
    end method.
    
    /* Are there any memory leaks in the scanned log(s), for the specified session?
       
       @param character A session identifier, or part thereof. The check is done with the BEGINS operator. If an unknown value is passed,
                       then any leak, anywhere, will return TRUE.
       @return logical TRUE if there are leaks detected in that group. FALSE if no scan has been done, or if there are no leaks. */
    method public logical HasLeaksForSession(input pSession as character):
        if pSession eq ? then
            return this-object:HasLeaks().
        else
            return can-find (first tObject
                             where tObject.Action eq 'CREATE'
                               and tObject.RelatedObject eq ?
                               and tObject.SessId begins pSession).
    end method.
    
    /* Returns an array of all the contexts that have leaks. If there are no leaks for this context, an indeterminate array
       is returned.
       
       @return character[] An array of the leak sessions */
    method public character extent GetReportSessions():
        define variable sessions as character extent no-undo.
        define variable idx as integer no-undo.
        
        define buffer bObject for tObject.
        
        for each bObject
        break by bObject.SessId:
            if first-of(bObject.SessId) then
                assign idx              = idx + 1
                       extent(sessions) = idx
                       sessions[idx]    = bObject.SessId
                       .
        end.
        
        return sessions.
    end method.
    
    /* Returns an array of all the groups that have leaks. If there are no leaks in this group, an indeterminate array
       is returned.
       
       @return character[] An aray of the leak groups */
    method public character extent GetReportGroups():
        define variable grp as character extent no-undo.
        define variable idx as integer no-undo.
        
        define buffer bObject for tObject.
        
        for each bObject
        break by bObject.Grp:
            if first-of(bObject.Grp) then
                assign idx         = idx + 1
                       extent(grp) = idx
                       grp[idx]    = bObject.Grp
                       .
        end.
        
        return grp.
    end method.
    
    /* Returns any leaks for a group as a JSON array of objects
    
       @param character A group identifier. If not in the list above, then all leaks are returned.
       @return JsonObject If there are leaks, an aray of objects, otherwise an empty array returned */
    method public JsonObject GetReportForGroup(input pGrp as character):
        define variable params as LeakReportParameters no-undo.
        
        assign params            = new LeakReportParameters()
               params:FilterType = LeakReportFilterTypeEnum:Group
               params:Filter     = pGrp
               .
        return this-object:GetReport(params).
    end method.

    /* Returns any leaks for a group as a JSON array of objects
       
       @param character A type name, or part thereof. All leaks that begin with this string are returned
       @return JsonObject If there are leaks, an aray of objects, otherwise an empty array returned */
    method public JsonObject GetReportForType(input pType as character):
        define variable params as LeakReportParameters no-undo.
        
        assign params            = new LeakReportParameters()
               params:FilterType = LeakReportFilterTypeEnum:Type
               params:Filter     = pType
               .
        return this-object:GetReport(params).
    end method.
    
    /* Clears any previously-parsed data. */
    method public void Clear():
        define buffer bObject for tObject.
        define buffer bHeader for tReportHeader.
        
        empty temp-table bObject.
        empty temp-table bHeader.
    end method.
    
    /* Returns the internal temp-table BY VALUE. This is to keep the set of data in this object, and
       not allow external callers to modify it. They may modify their copy of the data of course.
       
       If this method is called with the BY-REFERENCE option, an AssertionFailedError is raised.
       
       @parameter TABLE tObject. */
    method public void GetReport(output table tObject):
        // if NUM-REFERENCES > 0 then this has been called BY-REFERENCE
        if temp-table tObject:num-references gt 0 then
            undo, throw new AssertionFailedError('Method GetReport(OUTPUT TABLE) called BY-REFERENCE').
    end method.
    
    /* Builds the leak report based on the requested filter/criteria
       
       @param pReportParams Parameters for the report
       @return JsonObject The leak report */
    method public JsonObject GetReport(input pReportParams as LeakReportParameters):
        define variable objs as JsonArray no-undo.
        define variable report as JsonObject no-undo.
        define variable cntSess as JsonObject no-undo.
        define variable cntGrp as JsonObject no-undo.
        define variable grpData as JsonObject no-undo.
        define variable reqData as JsonObject no-undo.
        define variable reqGrp as JsonObject no-undo.
        define variable item as JsonObject no-undo.
        define variable rel as JsonObject no-undo.
        define variable relData as JsonArray no-undo.
        define variable qryWhere as character no-undo.
        define variable filter as character no-undo.
        
        define buffer bObject for tObject.
        define buffer bRelated for tObject.
        define buffer bHeader for tReportHeader.
        define buffer bChildHeader for tReportHeader.
        
        define query q1 for bObject.
        
        if not valid-object(pReportParams) then
            assign pReportParams = new LeakReportParameters().
        
        assign report  = new JsonObject()
               objs    = new JsonArray()
               cntSess = new JsonObject()
               cntGrp  = new JsonObject()
               .
        // Default query
        if pReportParams:NestRelatedObjects then
            assign qryWhere = 'bObject.Action eq "CREATE"'.
        else
            assign qryWhere = 'true'.
        
        case pReportParams:FilterType:
            when LeakReportFilterTypeEnum:None then
                assign filter = ?.
            
            when LeakReportFilterTypeEnum:Session then
                assign qryWhere = qryWhere
                                + ' and bObject.SessId begins "' + pReportParams:Filter + '"'
                       filter   = 'Session BEGINS ' + pReportParams:Filter
                       .
            when LeakReportFilterTypeEnum:Group then
                if lookup(pReportParams:Filter, mGroups) eq 0 then
                    assign filter = 'Invalid group: ' + pReportParams:Filter.
                else
                    assign qryWhere = qryWhere
                                    + ' and bObject.Grp eq "' + pReportParams:Filter + '"'
                           filter   = 'Group EQ ' + pReportParams:Filter
                           .
            when LeakReportFilterTypeEnum:Type then
                assign qryWhere = qryWhere
                                + ' and bObject.Type begins "' + pReportParams:Filter + '"'
                       filter   = 'Type BEGINS ' + pReportParams:Filter
                       .
        end case.
        
        query q1:query-prepare('for each bObject where ' + qryWhere + ' by bObject.LogAt').
        query q1:query-open().
        
        if pReportParams:PrintHeaderData then
        do:
            report:Add('filter', filter).
            report:Add('sessions', cntSess).
            report:Add('groups', cntGrp).
        end.
        
        if pReportParams:PrintDetailData then
            report:Add('objects', objs).
        
        get first q1.
        OBJECT-LOOP:
        do while available bObject
        on error undo, throw:
            assign rel     = ?
                   relData = ?
                   .
            // A leak is defined as a CREATE record without a related DELETE record
            if pReportParams:OnlyReportLeaks
            and bObject.RelatedObject ne ?
            then
                next OBJECT-LOOP.
            
            // Get the individual leak records
            if pReportParams:PrintDetailData then
            do:
                assign item = new JsonObject().
                buffer bObject:serialize-row('JSON', 'JsonObject', item, no, ?, ?, yes).
                
                objs:Add(item).
                
                if pReportParams:NestRelatedObjects then
                do:
                    assign relData = new JsonArray().
                    for each bRelated
                       where bRelated.RelatedObject eq rowid(bObject):
                        assign rel = new JsonObject().
                        relData:Add(rel).
                        buffer bRelated:serialize-row('JSON', 'JsonObject', rel, no, ?, ?, yes).
                    end.
                    
                    case relData:Length:
                        when 0 then item:AddNull('rel').
                        when 1 then item:Add('rel', rel).
                        otherwise   item:Add('rel', relData).
                    end case.
                end.
                else
                    item:AddNull('rel').
            end.
            
            // Increment the leak counts and sizes for group and context
            if pReportParams:PrintHeaderData then
            do:
                // SESSION
                 find bHeader
                where bHeader.ReportContext eq bObject.SessId
                no-error.
                if not available bHeader then
                do:
                    create bHeader.
                    assign bHeader.ReportContext = bObject.SessId
                           bHeader.Type          = 'SESSION'
                           .
                end.
                assign bHeader.LeakCount = bHeader.LeakCount + 1
                       bHeader.LeakSize  = bHeader.LeakSize + bObject.Size when bObject.Size ne ?
                       .
                // REQUEST
                if not bObject.RequestId eq ? then
                do:
                    find bHeader
                   where bHeader.ReportContext eq bObject.SessId + StringConstant:SPACE + bObject.RequestId
                    no-error.
                    if not available bHeader then
                    do:
                        create bHeader.
                        assign bHeader.ReportContext = bObject.SessId + StringConstant:SPACE + bObject.RequestId
                               bHeader.Type          = 'REQ'
                               .
                    end.
                    assign bHeader.LeakCount = bHeader.LeakCount + 1
                           bHeader.LeakSize  = bHeader.LeakSize + bObject.Size when bObject.Size ne ?
                           .
                end.
                // GROUP
                find bHeader
               where bHeader.ReportContext eq bObject.Grp
                no-error.
                if not available bHeader then
                do:
                    create bHeader.
                    assign bHeader.ReportContext = bObject.Grp
                           bHeader.Type          = 'GRP'
                           .
                end.
                assign bHeader.LeakCount = bHeader.LeakCount + 1
                       bHeader.LeakSize  = bHeader.LeakSize + bObject.Size when bObject.Size ne ?
                       .
            end.
            finally:
                get next q1.
            end finally.
        end.
        
        for each bHeader:
            if bHeader.Type eq 'GRP' then
            do:
                grpData = new JsonObject().
                grpData:Add('cnt',  bHeader.LeakCount).
                grpData:Add('size', bHeader.LeakSize).
                
                cntGrp:Add(bHeader.ReportContext, grpData).
            end.
            else
            if bHeader.Type eq 'SESSION' then
            do:
                assign grpData = new JsonObject()
                       reqGrp  = new JsonObject()
                       // unset as a signal that there are requests
                       reqData = ?
                       .
                cntSess:Add(bHeader.ReportContext, grpData).
                // total leaks & size
                grpData:Add('cnt',  bHeader.LeakCount).
                grpData:Add('size', bHeader.LeakSize).
                
                for each bChildHeader
                   where bChildHeader.Type eq 'REQ'
                     and bChildHeader.ReportContext begins bHeader.ReportContext:
                    assign reqData = new JsonObject().
                    reqGrp:Add(entry(3, bChildHeader.ReportContext, StringConstant:SPACE), reqData).
                    reqData:Add('cnt',  bChildHeader.LeakCount).
                    reqData:Add('size', bChildHeader.LeakSize).
                end.
                if valid-object(reqData) then
                    grpData:Add('req', reqGrp).
            end.    // CTX
        end.
        
        return report.
        finally:
            close query q1.
            empty temp-table bHeader.
        end finally.
    end method.
    
    /* Returns any leaks for a particular session
    
       The session is in one of two forms
       - For PASOE, it takes the form "<agent-pid> <abl-session-id>" (as in the agent log)
       - For other clients, it takes the form "P-<process-id>" (as in a client log)
       
       @param character The context to search. The search is a BEGINS operation, not EQ
       @return JsonObject If there are leaks, an aray of objects, otherwise an empty array returned */
    method public JsonObject GetReportForSession(input pSession as character):
        define variable params as LeakReportParameters no-undo.
        
        assign params            = new LeakReportParameters()
               params:FilterType = LeakReportFilterTypeEnum:Session
               params:Filter     = pSession
               .
        return this-object:GetReport(params).
    end method.
    
    /* Returns any leaks for all groups as a JSON array of objects
       
       @return JsonObject If there are leaks, an aray of objects, otherwise an empty array returned */
    method public JsonObject GetReport():
        define variable params as LeakReportParameters no-undo.
        
        assign params            = new LeakReportParameters()
               params:FilterType = LeakReportFilterTypeEnum:None
               .
        return this-object:GetReport(params).
    end method.
    
    
    
    /* Reads a log file and determines whether there are leaks.
       
       ParseLog can be called multiple times, for multiple files if needed.
       
       LONGCHARs are ignored, since they are memory-safe (aka cannot leak)
       Only lines in the DYNOBJECTS group are read. Parsing errors only refer to lines with DYNOBJECST in them;
       lines that do not contain " DYNOBJECTS " in them are skipped and are not parsed.
       
       @param character A file name representing a client log (LOG-MANAGER)
       @return logical TRUE if there were no parsing errors during this parse, FALSE otherwise. */
    method public logical ParseLog(input pLogfile as character):
        define variable line as character no-undo.
        define variable type as character no-undo.
        define variable grp as character no-undo.
        define variable id as character no-undo.
        define variable sid as character no-undo.
        define variable rid as character no-undo.
        define variable action as character no-undo.
        define variable timestamp as character no-undo.
        define variable dtz as datetime-tz no-undo.
        define variable info as character no-undo.
        define variable pool as character no-undo.
        define variable pos as integer no-undo.
        define variable pos2 as integer no-undo.
        define variable offset as integer no-undo.
        define variable initted as logical no-undo.
        define variable lineNo as int64 no-undo.
        define variable errCnt as int64 no-undo.
        define variable logfile as character no-undo.
        
        define buffer bObject for tObject.
        
        assign initted             = no
               // this variable is only used for reporting an error
               // pLogfile is used elsewhere since it has the complete logfile name
               logfile             = pLogfile
               file-info:file-name = logfile
               pLogfile             = file-info:full-pathname
               .
        // file not found, no-op
        if pLogfile eq ? then
        do:
            // don't report using file-info since the getting of the Logger can mess that up
            Logger:Error(substitute('Log file "&1" not found', logfile)).
            return false.
        end.
        
        input stream sLog from value(pLogfile).
        READ-LOOP:
         repeat:
            import stream sLog unformatted line.
            
            assign lineNo = lineNo + 1.
            
            // Only DYNOBJECTS has the info we need
            // note spaces around word
            assign pos = index(line, ' DYNOBJECTS ').
            if pos eq 0 then
                next READ-LOOP.
            
            // PAS logs have the format
            // 2022-01-31T17:46:15.973-0500 013309 013326 2 AS-4 ROOT:w:00000002 DYNOBJECTS     Allocated   MEMPTR 0x7F0338108190 size: 56 (propGet_Value OpenEdge.Core.ByteBucket @ 52)
            // ie 2 entries between the log level ('2') and the type 'DYNOBJECTS'
            
            // client logs have the format
            // [22/02/04@11:43:38.234-0500] P-024712 T-002860 2 4GL DYNOBJECTS     Allocated   MEMPTR 0x1915716F950 size: 816 (object_memptr_leak EntityWriters.XEW @ 252)
            // ie has 1 entry between log level and type
            if not initted then
            do:
                if entry(ENTRY_SID, line, StringConstant:SPACE) begins 'AS-' then
                    assign offset = 1.
                else
                    assign offset = 0.
                assign initted = yes.
            end.
            
            // parse the timestamp. This is a secondary check for a proper log, in case there are DYNOBJECTS lines elsewhere
            assign timestamp = entry(ENTRY_TIMESTAMP, line, StringConstant:SPACE).
            // strip off the enclosing [ and ]
            if timestamp begins '[' then
                assign timestamp = substring(timestamp, 2, 26).
            assign dtz = OpenEdge.Core.TimeStamp:TryParseTimestamp(timestamp).
            if dtz eq ? then
                undo, throw new AppError(substitute('Unable to parse timestamp "&1"', timestamp), 0).
            
            if offset eq 0 then
                // interactive client
                // process id
                assign sid = entry(ENTRY_PID, line, StringConstant:SPACE)
                       rid = ?
                       .
            else
                // PAS agent
                // process + session id
                assign sid = entry(ENTRY_PID, line, StringConstant:SPACE) + StringConstant:SPACE    // process id ie agent
                           + entry(ENTRY_SID, line, StringConstant:SPACE)                           // session id
                       rid = entry(ENTRY_RID, line, StringConstant:SPACE)                           // request id
                       .
            // Trim off the context, and replace double spaces with singles
            // the 16 chars include the leading space, plus the spaces leading to the action
            assign //pos  = index(line, ' DYNOBJECTS ')
                   line = trim(substring(line, pos + 16))
                   .
            // Basically tr -s <space> ; done to make line parsing simpler
            do while index(line, '  ') gt 0:
                assign line = replace(line, '  ', StringConstant:SPACE).
            end.
            
            assign action = entry(ENTRY_ACTION, line, StringConstant:SPACE)
                   grp    = entry(ENTRY_GROUP , line, StringConstant:SPACE)
                   .
            // get the info - stuff between the ( and )
            assign pos = index(line, StringConstant:PAREN_OPEN).
            // some lines have no ( ) info, eg
            //     DYNOBJECTS     Deallocated MEMPTR 0x2B66A5E8A80 size: 1024
            if pos eq 0 then
                assign info = ''.
            else
            do:
                assign pos2 = index(line, StringConstant:PAREN_CLOSE, pos).
                // guard in case there's only an opening paren
                if pos2 eq 0 then
                    assign info = trim(substring(line, pos + 1)).
                else
                    assign info = trim(substring(line, pos + 1, pos2 - pos - 1)).
            end.
            
            case grp:
                // CREATE: Allocated   MEMPTR 0x2957C047E40 size: 816 (object_memptr_leak EntityWriters.XEW @ 264)
                // DELETE: Deallocated MEMPTR 0x2957C047E40 size: 816 (object_memptr_leak EntityWriters.XEW @ 278)
                // older versions use LONGCHAR/MEMPTR on allocation
                when 'LONGCHAR' or
                when 'LONGCHAR/MEMPTR' or
                when 'MEMPTR' then
                do:
                    if lookup(action, 'Allocated,Deallocated') eq 0
                    or lookup('BLOB', this-object:ExcludeGroups) gt 0
                    then
                        next READ-LOOP.
                    
                    // we need the 0x20DA438C430 lines, not the Handle:0 lines
                    assign id   = entry(ENTRY_ID, line, StringConstant:SPACE)
                           type = 'MEMPTR'
                           .
                    if id begins 'Handle:' then
                        next READ-LOOP.
                    
                    if grp eq 'LONGCHAR' then
                        assign type = grp.
                    
                    // Both LONGCHAR and MEMPTRs are tracked, even though LONGCHARs are memory-managed by the AVM
                    // We cannot definitively determine that a line is a LONGCHAR or MEMPTR and so may end up
                    // with 'loose' create or delete lines, giving false-positive results
                    if action eq 'Allocated' then
                        assign action = 'CREATE'.
                    else
                    if action eq 'Deallocated' then
                        assign action = 'DELETE'.
                    
                    CreateRow(buffer bObject, action, sid, rid, 'BLOB', type, id, pLogfile, lineNo, dtz, info, ?).
                    assign bObject.Size = int64(entry(ENTRY_SIZE, line, StringConstant:SPACE)).
                    
                    MatchRelatedBlob(buffer bObject).
                end.    //MEMPTR
                
                // CREATE: Created        .NET Object Handle:1272 (object_memptr_leak EntityWriters.XEW @ 249) System.String[] Pool:<unnamed> FROM EntityWriters.XEW
                // DELETE: Deleted-by-GC  .NET Object Handle:1272 (object_memptr_leak EntityWriters.XEW @ 283) System.String[]
                when '.NET' then
                do:
                    assign grp = 'PLO'.
                    if lookup(grp, this-object:ExcludeGroups) gt 0 then
                        next READ-LOOP.
                    
                    // Uses the HANDLE entry, not the ID entry because there's an extra 'word' in the string
                    assign id = entry(2, entry(ENTRY_HANDLE, line, StringConstant:SPACE), ':').
                    if action eq 'Created' then
                        assign pos    = r-index(line, StringConstant:PAREN_CLOSE)
                               // there's a widget-pool line for .NET but not sure why or if it means anything, so ignore
                               pos2   = index(line, 'Pool:', pos)
                               type   = trim(substring(line, pos + 1, pos2 - pos - 1))
                               action = 'CREATE'
                               .
                    else
                    // Deleted and Deleted-by-GC
                    if action begins 'Deleted' then
                        assign pos    = r-index(line, StringConstant:PAREN_CLOSE) + 1
                               type   = trim(substring(line, pos))
                               action = 'DELETE'
                               .
                    CreateRow(buffer bObject, action, sid, rid, grp, type, id, pLogfile, lineNo, dtz, info, ?).
                    MatchRelated(buffer bObject).
                end.
                
                // Progress.Lang.Object
                // CREATE: Created        Progress.Lang.Object Handle:1276 (object_memptr_leak EntityWriters.XEW @ 265) OpenEdge.Core.Memptr
                // DELETE: Deleted-by-GC  Progress.Lang.Object Handle:1276 (object_memptr_leak EntityWriters.XEW @ 280) OpenEdge.Core.Memptr
                
                // PROCEDURE
                // CREATE: Created PROCEDURE Handle:1273 (object_memptr_leak EntityWriters.XEW @ 256) EntityWriters/proc.p
                // DELETE: Deleted PROCEDURE Handle:1273 (object_memptr_leak EntityWriters.XEW @ 288) EntityWriters/proc.p
                
                // Session start procedure are run persistently, and are not a leak. These are deleted at session shutdown, by the server
                // CREATE: Created        PROCEDURE               Handle:1001 ( @ 0) session_start.p
                // DELETE: Deleted        PROCEDURE               Handle:1001 ( @ 0) session_start.p
                when 'PROCEDURE' or
                when 'Progress.Lang.Object' then
                do:
                    if grp eq 'Progress.Lang.Object' then
                        assign grp = 'PLO'.
                    
                    // Avoid reusable object actions, like Cached,Purged,etc
                    if lookup(action, 'Created,Deleted,Deleted-by-GC') eq 0
                    or lookup(grp, this-object:ExcludeGroups) gt 0
                    then
                        next READ-LOOP.
                    
                    assign id   = entry(2, entry(ENTRY_ID, line, StringConstant:SPACE), ':')
                           pos  = r-index(line, StringConstant:PAREN_CLOSE)
                           type = trim(substring(line, pos + 1))
                           .
                    if action eq 'Created' then
                    do:
                        // session startup procedures
                        // Only check on create because the AVM does some magic on return, and that's also at "@ 0"
                        if info eq '@ 0' then
                            next READ-LOOP.
                        
                        assign action = 'CREATE'.
                    end.
                    else
                    // Deleted and Deleted-by-GC
                    if action begins 'Deleted' then
                        assign action = 'DELETE'.
                    
                    CreateRow(buffer bObject, action, sid, rid, grp, type, id, pLogfile, lineNo, dtz, info, ?).
                    MatchRelated(buffer bObject).
                end.    // PLO
                
                // SESSION and CLASS widget-pools are never tracked
                
                // Non-persistent widget-pool, created by application. Named or <unnamed>.
                // CREATE: Creating pool  <unnamed> (object_memptr_leak EntityWriters.XEW @ 254)
                // DELETE: Deleting pool  <unnamed> (object_memptr_leak EntityWriters.XEW @ 283) FROM object_memptr_leak EntityWriters.XEW
                
                // Created by the USE-WIDGET-POOL option on the CLASS statement; deletion is as above
                // CREATE: Creating pool  <unnamed> (EntityWriters.MemptrHolder @ 0)
                // DELETE: Deleting pool  <unnamed> (server-leak.p @ 41) FROM Utils.DataHolder
                
                // At session shutdown, for static pools
                // DELETE: Deleting pool  <unnamed> ( @ 0) FROM Utils.HolderLeaf
                
                // Persistent widget-pool, created by application
                // CREATE: Creating pool  req-wp PERS (activate.p @ 19)
                // DELETE: Deleting pool  req-wp (deactivate.p @ 14)
                
                // Session widget-pool - managed by the AVM
                // CREATE: Creating pool  <unnamed> ( @ 0)
                // DELETE: Deleting pool  <unnamed> ( @ 0)
                when 'pool' then
                do:
                    assign grp = 'WIDGET-POOL'.
                    if lookup(grp, this-object:ExcludeGroups) gt 0 then
                        next READ-LOOP.
                    
                    assign id   = entry(ENTRY_ID, line, StringConstant:SPACE)
                           pool = id
                           pos  = index(info, '@')
                           .
                    // Skip session and class widget pools
                    if pos ge 1
                    and trim(substring(info, pos)) eq '@ 0'
                    and pool eq '<unnamed>'
                    then
                        next READ-LOOP.
                    
                    if action eq 'Creating' then
                    do:
                        assign action = 'CREATE'.
                        // persistent widget-pools - this is only specified on the Creating line
                        if entry(ENTRY_ID + 1, line, StringConstant:SPACE) eq 'PERS' then
                            assign type = 'PERSISTENT'.
                        else
                            assign id   = substitute('&1 FROM &2', id, trim(substring(info, 1, pos - 1)))
                                   type = 'PROGRAM'
                                   .
                    end.    // creating pool
                    else
                    if action eq 'Deleting' then
                    do:
                        assign pos    = index(line, 'FROM')
                               action = 'DELETE'
                               .
                        if pos eq 0 then
                            assign type = 'PERSISTENT'.
                        else
                            assign type = 'PROGRAM'
                                   id   = id + StringConstant:SPACE + trim(substring(line, pos))
                                   .
                    end.
                    
                    CreateRow(buffer bObject, action, sid, rid, grp, type, id, pLogfile, lineNo, dtz, info, pool).
                    MatchRelatedPool(buffer bObject).
                end.    // widget-pool
                
                // IMPLICIT
                // CREATE: Created        BUFFER                  Handle:1299 (GetDataset Utils.DataHolder @ 33) IMPLICIT Table:tt Pool:<Session Pool>
                // DELETE: Deleted        BUFFER                  Handle:1299 (data_handles Utils.TestLeakCheck @ 714) IMPLICIT
                
                // EXPLICIT
                // CREATE: Created        BUFFER                  Handle:1312 (explicit_buffer Utils.TestLeakCheck @ 753) Table:tt Pool:<unnamed> FROM adecomm/_runcode.p
                // DELETE: Deleted        BUFFER                  Handle:1312 (explicit_buffer Utils.TestLeakCheck @ 754)
                when 'BUFFER' then
                do:
                    assign type = grp
                           grp = 'DATA'
                           id   = entry(2, entry(ENTRY_ID, line, StringConstant:SPACE), ':')
                           .
                    if lookup(grp, this-object:ExcludeGroups) gt 0
                    or index(line, ' IMPLICIT ':u) gt 0
                    then
                        next READ-LOOP.
                    
                    if action eq 'Created' then
                        assign pos    = r-index(line, StringConstant:PAREN_CLOSE)
                               pos2   = index(line, 'Pool:', pos)
                               pool   = substring(line, pos2 + 5)
                               action = 'CREATE'
                               .
                    else
                    if action begins 'Deleted' then
                        assign action = 'DELETE'.
                    
                    CreateRow(buffer bObject, action, sid, rid, grp, type, id, pLogfile, lineNo, dtz, info, ?).
                    MatchRelated(buffer bObject).
                end.    // buffer
                
                // Delete Pending TEMP-TABLE              Handle:1003 (tt.p @ 18)
                // Delete Pending BUFFER                  Handle:1004 (tt.p @ 18) IMPLICIT
                when 'Pending' then
                do:
                    // skip IMPLICIT buffers 'n stuff
                    if index(line, ' IMPLICIT':u) gt 0 then
                        next READ-LOOP.
                    
                    assign type = entry(ENTRY_GROUP + 1, line, StringConstant:SPACE).
                    if type eq 'TEMP-TABLE'
                    or type eq 'DATASET'
                    or type eq 'DATA-SOURCE'
                    or type eq 'BUFFER'
                    then
                        assign grp = 'DATA'
                               id  = entry(2, entry(ENTRY_ID + 1, line, StringConstant:SPACE), ':')
                               .
                    else
                        // we don't know of any other 'delete pending' operations but this ELSE exists to
                        // give space for the future
                        next READ-LOOP.
                    
                    if lookup(grp, this-object:ExcludeGroups) gt 0 then
                        next READ-LOOP.
                    
                    // Mark the object as pending deletion; there will be a proper "Deleted" line coming soon
                    if action eq 'Delete' then
                    do:
                        CreateRow(buffer bObject, 'DELETE-PENDING', sid, rid, grp, type, id, pLogfile, lineNo, dtz, info, ?).
                        MatchRelated(buffer bObject).
                    end.
                end.
                
                // CREATE: Created X-DOCUMENT Handle:1276 (GetXmlDoc OpenEdge.Net.HTTP.Filter.Payload.XmlEntityWriter @ 124)  Pool:<unnamed> FROM object_memptr_leak EntityWriters.XEW
                // DELETE: Deleted X-DOCUMENT Handle:1276 (object_memptr_leak EntityWriters.XEW @ 283) POOLDEL
                otherwise
                do:
                    assign id   = entry(2, entry(ENTRY_ID, line, StringConstant:SPACE), ':')
                           type = grp
                           .
                    if type begins 'X-'
                    or type begins 'SAX-'
                    or type begins 'SOAP-'
                    then
                        assign grp = 'XML'.
                    else
                    if type eq 'TEMP-TABLE'
                    or type eq 'DATASET'
                    or type eq 'DATA-SOURCE'
                    then
                        assign grp = 'DATA'.
                    else
                        assign grp = 'HANDLE'.
                    
                    if lookup(grp, this-object:ExcludeGroups) gt 0 then
                        next READ-LOOP.
                    
                    if action eq 'Created' then
                        assign pos    = r-index(line, StringConstant:PAREN_CLOSE)
                               pos2   = index(line, 'Pool:', pos)
                               pool   = substring(line, pos2 + 5)
                               action = 'CREATE'
                               .
                    else
                    if action begins 'Deleted' then
                        assign action = 'DELETE'
                               pool   = ?
                               .
                    CreateRow(buffer bObject, action, sid, rid, grp, type, id, pLogfile, lineNo, dtz, info, pool).
                    MatchRelated(buffer bObject).
                end.    // otherwise
            end case.
            catch e as Progress.Lang.Error:
                // Log any parsing errors and continue
                Logger:Error(substitute('Parse error at line number &2 for &1', pLogfile, lineNo), e).
                assign errCnt = errCnt + 1.
                
                if not this-object:MaxErrorLines eq 0
                and errCnt eq this-object:MaxErrorLines
                then
                    return false.
            end catch.
        end.
        
        // even if we have read the entire file, there may be lines that didn't parse; indicate this to the caller
        return (errCnt eq 0).
        catch e as Progress.Lang.Error:
            // Log any other errors
            Logger:Error(substitute('Parser error for &1', pLogfile), e).
            return false.
        end catch.
        finally:
            input stream sLog close.
        end finally.
    end method.
    
    /* Find related BLOB records, by a combo of session/group/id (with LONGCHAR/MEMPTR types checked explicitly)
       
       @param buffer The record for which to find a related record */
    method private void MatchRelatedBlob(buffer pObject for tObject):
        define buffer bRelated for tObject.
        
        if not available pObject then
            return.
        
        case pObject.Action:
            // CREATE <-> DELETE
            when 'CREATE' then
            do:
                find bRelated
               where bRelated.SessId eq pObject.SessId
                 and bRelated.Grp eq pObject.Grp
                 and bRelated.Type eq pObject.Type
                 and bRelated.Id eq pObject.Id
                 and bRelated.Action eq 'DELETE'
                 and bRelated.RelatedObject eq ?
                no-error.
                if available bRelated then
                    assign pObject.RelatedObject  = rowid(bRelated)
                           bRelated.RelatedObject = rowid(pObject)
                           .
                else
                do:
                    find bRelated
                   where bRelated.SessId eq pObject.SessId
                     and bRelated.Grp eq pObject.Grp
                     and bRelated.Type eq 'LONGCHAR'        // was previously deleted as LONGCHAR
                     and bRelated.Id eq pObject.Id
                     and bRelated.Action eq 'DELETE'
                     and bRelated.RelatedObject eq ?
                    no-error.
                    if available bRelated then
                        assign pObject.RelatedObject  = rowid(bRelated)
                               bRelated.RelatedObject = rowid(pObject)
                               .
                end.
            end.    // create
            
            // DELETE <-> CREATE
            when 'DELETE' then
            do:
                find bRelated
               where bRelated.SessId eq pObject.SessId
                 and bRelated.Grp eq pObject.Grp
                 and bRelated.Type eq pObject.Type
                 and bRelated.Id eq pObject.Id
                 and bRelated.Action eq 'CREATE'
                 and bRelated.RelatedObject eq ?
                no-error.
                if available bRelated then
                    assign pObject.RelatedObject  = rowid(bRelated)
                           bRelated.RelatedObject = rowid(pObject)
                           .
                else
                do:
                    find bRelated
                   where bRelated.SessId eq pObject.SessId
                     and bRelated.Grp eq pObject.Grp
                     and bRelated.Type eq 'MEMPTR'      // was allocated as LONGCHAR/MEMPTR
                     and bRelated.Id eq pObject.Id
                     and bRelated.Action eq 'CREATE'
                     and bRelated.RelatedObject eq ?
                    no-error.
                    if available bRelated then
                        assign pObject.RelatedObject  = rowid(bRelated)
                               bRelated.RelatedObject = rowid(pObject)
                               .
                end.
            end.
        end case.
    end method.
    
    /* Find any related records, by a combo of session/group/type/id
       
       CREATE may have DELETE and DELETE-PENDING
       DELETE may have CREATE
       DELETE-PENDING may have CREATE
       
       @param buffer The record for which to find a related record */
    method private void MatchRelated(buffer pObject for tObject):
        define buffer bRelated for tObject.
        
        if not available pObject then
            return.
        
        case pObject.Action:
            // CREATE <-> DELETE
            // CREATE <- DELETE-PENDING
            when 'CREATE' then
            do:
                find bRelated
               where bRelated.SessId eq pObject.SessId
                 and bRelated.Grp eq pObject.Grp
                 and bRelated.Type eq pObject.Type
                 and bRelated.Id eq pObject.Id
                 and bRelated.Action eq 'DELETE'
                 and bRelated.RelatedObject eq ?
                no-error.
                if available bRelated then
                    assign pObject.RelatedObject  = rowid(bRelated)
                           bRelated.RelatedObject = rowid(pObject)
                           .
                find bRelated
               where bRelated.SessId eq pObject.SessId
                 and bRelated.Grp eq pObject.Grp
                 and bRelated.Type eq pObject.Type
                 and bRelated.Id eq pObject.Id
                 and bRelated.Action eq 'DELETE-PENDING'
                 and bRelated.RelatedObject eq ?
                no-error.
                if available bRelated then
                    assign bRelated.RelatedObject = rowid(pObject).
            end.    // create
            
            // DELETE <-> CREATE
            when 'DELETE' then
            do:
                find bRelated
               where bRelated.SessId eq pObject.SessId
                 and bRelated.Grp eq pObject.Grp
                 and bRelated.Type eq pObject.Type
                 and bRelated.Id eq pObject.Id
                 and bRelated.Action eq 'CREATE'
                 and bRelated.RelatedObject eq ?
                no-error.
                if available bRelated then
                    assign pObject.RelatedObject  = rowid(bRelated)
                           bRelated.RelatedObject = rowid(pObject)
                           .
            end.
            // DELETE-PENDING -> CREATE
            when 'DELETE-PENDING' then
            do:
                find bRelated
               where bRelated.SessId eq pObject.SessId
                 and bRelated.Grp eq pObject.Grp
                 and bRelated.Type eq pObject.Type
                 and bRelated.Id eq pObject.Id
                 and bRelated.Action eq 'CREATE'
                 and bRelated.RelatedObject eq ?
                no-error.
                if available bRelated then
                    assign pObject.RelatedObject = rowid(bRelated).
            end.
        end case.
    end method.
    
    /* Finds a related record for a widget-pool, by a combo of session/group/type/id and time
       
       @param buffer The record for which to find a related record */
    method private void MatchRelatedPool(buffer pObject for tObject):
        define buffer bRelated for tObject.
        define query qRelated for bRelated.
        
        if not available pObject then
            return.
        
        // For CREATE, look for matching DELETE that's AFTER the create timestamp.
        if pObject.Action eq 'CREATE' then
            open query qRelated for each bRelated
                                   where bRelated.SessId eq pObject.SessId
                                     and bRelated.Grp eq pObject.Grp
                                     and bRelated.Type eq pObject.Type
                                     and bRelated.Id eq pObject.Id
                                     and bRelated.LogAt ge pObject.LogAt
                                     and bRelated.Action eq 'DELETE'
                                     and bRelated.RelatedObject eq ?
                                      by bRelated.LogAt.
        // For DELETE, look for matching CREATE that's BEFORE the delete timestamp.
        else
        if pObject.Action eq 'DELETE' then
            open query qRelated for each bRelated
                                   where bRelated.SessId eq pObject.SessId
                                     and bRelated.Grp eq pObject.Grp
                                     and bRelated.Type eq pObject.Type
                                     and bRelated.Id eq pObject.Id
                                     and bRelated.LogAt le pObject.LogAt
                                     and bRelated.Action eq 'CREATE'
                                     and bRelated.RelatedObject eq ?
                                      by bRelated.LogAt descending.
        else
        // in case of nonsense data, we'll never find any records
            open query qRelated for each bRelated
                                   where false.
        
        get first qRelated.
        if available bRelated then
            assign bRelated.RelatedObject = rowid(pObject)
                   pObject.RelatedObject  = rowid(bRelated)
                   .
        close query qRelated.
    end method.
    
    /* Creates a new record for a tracked object
       
       @param buffer tObject The buffer in which to create the record
       @param character The action: one of CREATE, DELETE, DELETE-PENDING
       @param character The session id
       @param character The request id, if any
       @param character The object group
       @param character The object type
       @param character The object's unique ID
       @param character The name of the logfile being parsed
       @param int64 The current line in the log
       @param datetime-tz The timestamp of the event
       @param character Line info
       @param character The widget-pool name, if any */
    method private void CreateRow(buffer pObject for tObject,
                                  input pAction as character,
                                  input pSession as character,
                                  input pReqId as character,
                                  input pGroup as character,
                                  input pType as character,
                                  input pId as character,
                                  input pLogname as character,
                                  input pLogLine as int64,
                                  input pTimestamp as datetime-tz,
                                  input pInfo as character,
                                  input pPool as character):
        // Don't repeat identical lines
        find pObject
       where pObject.LogName eq pLogname
         and pObject.LogLine eq pLogLine
        no-error.
        if available pObject then
            return.
        
        create pObject.
        assign pObject.SessId     = pSession
               pObject.RequestId  = pReqId
               pObject.LogLine    = pLogLine
               pObject.LogName    = pLogname
               pObject.Type       = pType
               pObject.Grp        = pGroup
               pObject.Id         = pId
               pObject.LogAt      = pTimestamp
               pObject.Info       = pInfo
               pObject.WidgetPool = pPool
               pObject.Action     = pAction
               .
    end method.
    
end class.