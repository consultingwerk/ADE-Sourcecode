/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : BodyRule
    Purpose     : Applies tracing rules for the message body
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-11-17
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.BodyRule.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceFilterRule.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.BodyFilterRule
implements ITraceFilterRule
inherits BodyRule:
    // Body may apply to requests or responses, so both rule and policy types are required.
    constructor public BodyFilterRule(input pMessageType as MessageTypeEnum, input pPolicy as PolicyTypeEnum ):
        super(pMessageType, pPolicy).
    end constructor.

    /* Method to apply policy (and exceptions) to HTTP messages.

       @param IHttpMessage The Request or Response object (message) being processed
       @return logical If FALSE then the processing of the rule chain halts; if TRUE the next rule (if any) in the chain is processed  */
    method public logical ApplyPolicy ( input pMessage as IHttpMessage):
        // for filter rules, we only check if the content-type meets the policy
        if (this-object:Policy eq PolicyTypeEnum:Allow-All and index(this-object:MimeTypes, pMessage:ContentType) gt 0)
        or (this-object:Policy eq PolicyTypeEnum:Deny-All and index(this-object:MimeTypes, pMessage:ContentType) eq 0)
        then
            return false.
        
        // the request passed the filter!
        return true.
           
        catch uncaught as Progress.Lang.Error:
            return false. // Assume errors to mean cancelling further processing.
        end catch.
    end method.
    
end class.
