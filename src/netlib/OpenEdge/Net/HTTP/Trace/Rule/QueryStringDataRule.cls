/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : QueryStringDataRule
    Purpose     : Trace rule to determine whether a query string should be
                  considered for filtering or tracing
    Syntax      :
    Description :
    Author(s)   : dugrau
    Created     : 2021-09-09
    Notes       : * This DATA rule applies only to REQUESTs
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule.
using OpenEdge.Net.HTTP.Trace.Rule.TraceRule.
using Progress.Collections.List.
using Progress.Lang.Object.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.QueryStringDataRule
inherits TraceRule
implements ITraceDataRule:
    
    // holds a CSV list of query names
    var private character mExceptions.
    
    /* Constructor.
       
       @param PolicyTypeEnum The policy to apply. */
    constructor public QueryStringDataRule (input pPolicy as PolicyTypeEnum ):
        super(MessageTypeEnum:Request, pPolicy).
    end constructor.
    
    /* Setter for Policy Exceptions

       @param Object[] List of exception objects */
    method override public void SetPolicyExceptions( input pExceptions as Object extent ):
        var integer loop, cnt.
        var character delim = '':u.
        
        super:SetPolicyExceptions(input pExceptions).
        
        assign cnt         = extent(pExceptions)
               mExceptions = '':u
               .
        do loop = 1 to cnt:
            if valid-object(pExceptions[loop]) then
                assign mExceptions += delim + string(pExceptions[loop])
                       delim        = ',':u
                       .
        end.
    end method.
    
    /* Method to apply policy (and exceptions) to HTTP messages (request ONLY for this class).
       
       @param IHttpMessage The Request or Response object (message) being processed
       @param ExchangeData The current trace data. A rule may update this data  */
    method public void ApplyPolicy(input pMessage as IHttpMessage,
                                   input pTraceData as ExchangeData ):
        var character[] qryNames.
        var integer loop, cnt.
        
        // Cannot handle being given a response type object.
        if type-of(pMessage, IHttpResponse) then
            return.
        
        // Extract the request URI's query string
        if type-of(pMessage, IHttpRequest) then
            assign cnt = cast(pMessage, IHttpRequest):URI:GetQueryNames(output qryNames).
        
        // we need to loop over the whole set of keys because we need to URL Decode
        // the values
        do loop = 1 to cnt:
            // Skips any items in the exception list (ie index() will be >0).
            if (Policy eq PolicyTypeEnum:Allow-All and index(mExceptions, qryNames[loop]) eq 0)
            // skips any items that are NOT in the list (index = 0)
            or (Policy eq PolicyTypeEnum:Deny-All  and index(mExceptions, qryNames[loop]) gt 0)
            then
                // Create a new entry containing a List<String> for any values.
                pTraceData:QueryString:Put(qryNames[loop], cast(pMessage, IHttpRequest):URI:GetQueryValueList(qryNames[loop])).     
        end.
    end method.
    
end class.