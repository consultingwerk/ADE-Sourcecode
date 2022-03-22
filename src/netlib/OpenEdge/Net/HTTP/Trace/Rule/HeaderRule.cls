/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HeaderRule
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : dugrau
    Created     : Mon Aug 30 12:06:23 EDT 2021
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule.
using OpenEdge.Net.HTTP.Trace.Rule.TraceRule.
using Progress.Lang.Object.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.HeaderRule
inherits TraceRule
implements ITraceDataRule:

    /* Holds the array values as a CSV */
    define private variable mExceptionHeaderNames as character no-undo.

    // Header may apply to requests or responses, so both rule and policy types are required.
    constructor public HeaderRule ( input pMessageType as MessageTypeEnum, input pPolicy as PolicyTypeEnum ):
        super (pMessageType, pPolicy).
    end constructor.
    
    method private void AddTraceData ( input poHeader   as HttpHeader,
                                       input pTraceData as ExchangeData ):
        if this-object:MessageType:IsFlagSet(MessageTypeEnum:Request) then
            pTraceData:AddRequestHeader(poHeader).
        
        if this-object:MessageType:IsFlagSet(MessageTypeEnum:Response) then
            pTraceData:AddResponseHeader(poHeader).
    end method.
    
    /* Setter for Policy Exceptions

       @param Object[] List of exception objects */
    method override public void SetPolicyExceptions(input pExceptions as Object extent):
        var character delim.
        var integer loop, cnt.
        
        super:SetPolicyExceptions(pExceptions).
        
        // Build a CSV list of the header names to skip. Do a single loop through the exceptions
        // Do this once, when the exceptions are set.
        assign delim = '':u
               cnt   = extent(pExceptions)
               mExceptionHeaderNames = '':u
               .
        if this-object:Policy eq PolicyTypeEnum:Allow-All then
        do loop = 1 to cnt:
            if valid-object(PolicyExceptions[loop]) then
                assign mExceptionHeaderNames = mExceptionHeaderNames
                                             + string(PolicyExceptions[loop])
                                             + delim
                       delim                 = ',':u
                       .
        end.
    end method.

    /* Method to apply policy (and exceptions) to HTTP messages.

       @param IHttpMessage The Request or Response object (message) being processed
       @param ExchangeData The current trace data. A rule may update this data */
    method public void ApplyPolicy(input pMessage   as IHttpMessage,
                                   input pTraceData as ExchangeData ):
        define variable iExCnt      as integer           no-undo.
        define variable iExLoop     as integer           no-undo.
        define variable iHeader     as integer           no-undo.
        define variable oHeaders    as HttpHeader extent no-undo.
        define variable iNumHeaders as integer           no-undo.
        define variable cName       as character         no-undo.
        
        iExCnt = extent(PolicyExceptions).
        if Policy eq PolicyTypeEnum:Allow-All then do:
            assign iNumHeaders = pMessage:GetHeaders(output oHeaders).
            if iNumHeaders eq ? or iNumHeaders eq 0 then
                return.
            
            // If no exceptions, all will be traced.
            do iHeader = 1 to iNumHeaders:
                // Skips any items in the exception list (ie index() will be >0).
                if index(mExceptionHeaderNames, oHeaders[iHeader]:Name) eq 0
                then
                    this-object:AddTraceData(oHeaders[iHeader], pTraceData).
            end.
        end. // AllowAll
        else if Policy eq PolicyTypeEnum:Deny-All then
        // For deny-all, ONLY the exceptions will be traced.
        do iExLoop = 1 to iExCnt:
            // Get the item by name and add it to trace data.
            assign cName = string(PolicyExceptions[iExLoop]).
            if pMessage:HasHeader(cName) then
                this-object:AddTraceData(pMessage:GetHeader(cName), pTraceData).
        end. // DenyAll
    end method.

end class.
