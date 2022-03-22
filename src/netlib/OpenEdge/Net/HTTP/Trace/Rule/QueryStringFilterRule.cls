/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : QueryStringRule
    Purpose     : Trace rule to determine whether a query string should be
                  considered for filtering or tracing
    Syntax      :
    Description :
    Author(s)   : dugrau
    Created     : 2021-09-09
    Notes       : * This FILTER rule applies only to REQUESTs.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceFilterRule.
using OpenEdge.Net.HTTP.Trace.Rule.TraceRule.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.QueryStringFilterRule
inherits TraceRule
implements ITraceFilterRule:

    /* Constructor.

       @param PolicyTypeEnum The policy to apply. */
    constructor public QueryStringFilterRule(input pPolicy as PolicyTypeEnum ):
        super(MessageTypeEnum:Request, pPolicy).
    end constructor.

    /* Method to apply policy (and exceptions) to HTTP messages (request ONLY for this class).

       @param IHttpMessage The Request or Response object (message) being processed
       @return logical If FALSE then the processing of the rule chain halts; if TRUE the next rule (if any) in the chain is processed  */
    method public logical ApplyPolicy(input pMessage as IHttpMessage):
        define variable iExCnt    as integer          no-undo.
        define variable iLoop     as integer          no-undo.
        define variable oQueryMap as IStringStringMap no-undo.

        // Cannot handle being given a response type object.
        if type-of(pMessage, IHttpResponse) then
            return false. // Stop processing.

        iExCnt = extent(PolicyExceptions).

        // Extract the request URI's query string for a quick check, but only if exceptions exist.
        if type-of(pMessage, IHttpRequest) and iExCnt ne ? and iExCnt gt 0 then
            assign oQueryMap = cast(pMessage, IHttpRequest):URI:GetQueryMap().

        // Only proceed with exceptions if there are query names available in the request.
        if valid-object(oQueryMap) and not oQueryMap:IsEmpty() then
        // Process exceptions to the policy; note that performance will be affeced by the length of this list.
        EXCEPTION-LOOP:
        do iLoop = 1 to iExCnt:
            if not valid-object(PolicyExceptions[iLoop]) then
                next EXCEPTION-LOOP.

            // For allow-all, any matched exceptions will stop rule processing.
            if this-object:Policy eq PolicyTypeEnum:Allow-All
            and oQueryMap:ContainsKey(string(PolicyExceptions[iLoop]))
            then
                return false. // Any exception will cause the query string to be denied from tracing.

            // For deny-all, any matched exceptions will continue rule processing.
            if this-object:Policy eq PolicyTypeEnum:Deny-All
            and oQueryMap:ContainsKey(string(PolicyExceptions[iLoop]))
            then
                return true. // Any exception will cause the query string to be included for tracing.
        end. // oExceptions w/ QueryString (Map)

        // If exception list was empty, proceed as based on the policy itself.
        case this-object:Policy:
            when PolicyTypeEnum:Allow-All then return true. // Default is to consider any query string to be allowed.
            when PolicyTypeEnum:Deny-All then return false. // Default is to consider any query string to be denied.
            otherwise return true. // Other policies, if enum supports additional values in the future.
        end case.

        catch uncaught as Progress.Lang.Error:
            return false. // Assume errors to mean cancelling further processing.
        end catch.
    end method.
    
end class.