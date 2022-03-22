/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : BodyDataRule
    Purpose     : Applies tracing rules for the message body
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Tue Aug 24 15:41:39 EDT 2021
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.BodyRule.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.BodyDataRule
implements ITraceDataRule
inherits BodyRule:
    // Body may apply to requests or responses, so both rule and policy types are required.
    constructor public BodyDataRule (input pMessageType as MessageTypeEnum, input pPolicy as PolicyTypeEnum ):
        super(pMessageType, pPolicy).
    end constructor.
    
    /* Method to apply policy (and exceptions) to HTTP messages.

       @param IHttpMessage The Request or Response object (message) being processed
       @param ExchangeData The current trace data. A rule may update this data */
    method public void ApplyPolicy(input pMessage as IHttpMessage,
                                   input pTraceData as ExchangeData ):
        if not valid-object(pMessage:Entity)
        or pMessage:ContentType eq '':u
        then
            return.
        
            // exceptions for allow-all = do not trace
        if (this-object:Policy eq PolicyTypeEnum:Allow-All and index(this-object:MimeTypes, pMessage:ContentType) eq 0)
            // exceptions for deny-all = do trace
        or (this-object:Policy eq PolicyTypeEnum:Deny-All and index(this-object:MimeTypes, pMessage:ContentType) gt 0)
        then
        do:
            // we should have the raw body in here; if not, then go no further
            if not type-of(pMessage:Entity, IMemptrHolder) then
                return.
            
            if MessageType:IsFlagSet(MessageTypeEnum:Request) then
                assign pTraceData:RequestBody = cast(pMessage:Entity, IMemptrHolder).
            
            if MessageType:IsFlagSet(MessageTypeEnum:Response) then
                assign pTraceData:ResponseBody = cast(pMessage:Entity, IMemptrHolder).
        end.
    end method.
    
end class.
