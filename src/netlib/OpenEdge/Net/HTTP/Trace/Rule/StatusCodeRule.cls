/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StatusCodeRule
    Purpose     : Filter rule for response status codes
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-11-16
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IInt64Holder.
using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceFilterRule.
using OpenEdge.Net.HTTP.Trace.Rule.TraceRule.
using Progress.Lang.Object.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.StatusCodeRule
inherits TraceRule
implements ITraceFilterRule:
    // holds a CSV list of exception values
    var private character mExceptions.
    
    /* Constructor
       
       @param PolicyTypeEnum This rules' policy type */
    constructor public StatusCodeRule( input pPolicy as PolicyTypeEnum ):
        super (MessageTypeEnum:Response, pPolicy).
    end constructor.
    
    /* Setter for Policy Exceptions
       
       @param Object[] List of exception objects */
    method public override void SetPolicyExceptions ( input pExceptions as Object extent ):
        var character   delim = '':u.
        var integer loop, cnt.
        
        Assert:IsType(pExceptions, get-class(IInt64Holder)).
        
        super:SetPolicyExceptions(pExceptions).
        
        // Build a CSV list of the status codes to skip. Do a single loop through the exceptions
        // Do this once, when the exceptions are set, rather than on each call to ApplyPolicy
        assign mExceptions = '':u
               cnt         = extent(pExceptions)
               .
        do loop = 1 to cnt:
            if valid-object(pExceptions[loop]) then
                assign mExceptions += string(cast(pExceptions[loop], IInt64Holder):Value)
                                    + delim
                       delim        = ',':u
                       .
        end.
    end method.
    
    /* Method to apply policy (and exceptions) to HTTP messages (request ONLY for this class).
       
       @param IHttpMessage The Request or Response object (message) being processed
       @return logical If FALSE then the processing of the rule chain halts; if TRUE the next rule (if any) in the chain is processed  */
    method public logical ApplyPolicy(input pMessage as IHttpMessage):
        var character sc.
        
        // make extra sure
        if type-of(pMessage, IHttpRequest) then
            return false.
        
        assign sc = string(cast(pMessage, IHttpResponse):StatusCode).
        
        // for filter rules, we only check if the content-type meets the policy
        if (this-object:Policy eq PolicyTypeEnum:Allow-All and index(mExceptions, sc) gt 0)
        or (this-object:Policy eq PolicyTypeEnum:Deny-All and index(mExceptions, sc) eq 0)
        then
            return false.
        
        // the request passed the filter!
        return true.
        catch uncaught as Progress.Lang.Error:
            return false. // Assume errors to mean cancelling further processing.
        end catch.
    end method.
    
end class.