/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : CookieRule
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : dugrau
    Created     : Mon Aug 30 12:06:23 EDT 2021
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule.
using OpenEdge.Net.HTTP.Trace.Rule.TraceRule.
using Progress.Lang.Object.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.CookieRule
inherits TraceRule
implements ITraceDataRule:
    var private character mCookieNames.
    
    // Header may apply to requests or responses, so both rule and policy types are required.
    constructor public CookieRule (input pMessageType as MessageTypeEnum, input pPolicy as PolicyTypeEnum ):
        super (pMessageType, pPolicy).
    end constructor.
    
    /* Setter for Policy Exceptions

       @param Object[] List of exception objects */
    method override public void SetPolicyExceptions(input pExceptions as Object extent):
        var character   delim = '':u.
        var integer loop, cnt = extent(pExceptions).
        
        super:SetPolicyExceptions(pExceptions).
        
        // Build a CSV list of the cookie names. Do a single loop through the exceptions
        // Do this once, when the exceptions are set.
        assign mCookieNames = '':u.
        if this-object:Policy eq PolicyTypeEnum:Allow-All then
        do loop = 1 to cnt:
            if valid-object(PolicyExceptions[loop]) then
                assign mCookieNames += string(PolicyExceptions[loop])
                                     + delim
                       delim         = ',':u
                       .
        end.
    end method.
    
    method private void AddTraceData ( input poCookie   as Cookie,
                                       input pTraceData as ExchangeData ):
        if this-object:MessageType:IsFlagSet(MessageTypeEnum:Request) then
            pTraceData:AddRequestCookie(poCookie).
        
        if this-object:MessageType:IsFlagSet(MessageTypeEnum:Response) then
            pTraceData:AddResponseCookie(poCookie).
    end method.

    /* Method to apply policy (and exceptions) to HTTP messages.

       @param IHttpMessage The Request or Response object (message) being processed
       @param ExchangeData The current trace data. A rule may update this data */
    method public void ApplyPolicy(input pMessage   as IHttpMessage,
                                   input pTraceData as ExchangeData ):
        define variable iExCnt      as integer       no-undo.
        define variable iExLoop     as integer       no-undo.
        define variable iCookie     as integer       no-undo.
        define variable oCookies    as Cookie extent no-undo.
        define variable iNumCookies as integer       no-undo.
        define variable cName       as character     no-undo.
        
        if Policy eq PolicyTypeEnum:Allow-All then do:
            // Obtain the list of all cookies and a total count.
            assign iNumCookies = pMessage:GetCookies(output oCookies).
            if iNumCookies eq ? or iNumCookies eq 0 then
                // If no cookies then nothing to do.
                return .
            
            do iCookie = 1 to iNumCookies:
                // Skips any items in the exception list (ie index() will be >0).
                if index(mCookieNames, oCookies[iCookie]:Name) eq 0
                then
                    this-object:AddTraceData(oCookies[iCookie], pTraceData).
            end.
        end. // AllowAll
        else if Policy eq PolicyTypeEnum:Deny-All then
        do:
            assign iExCnt = extent(PolicyExceptions). // Get the exception count.
            // For deny-all, ONLY the exceptions will be traced.
            do iExLoop = 1 to iExCnt:
                // Get the item by name and add it to trace data.
                assign cName = string(PolicyExceptions[iExLoop]).
                if pMessage:HasCookie(cName) then
                    this-object:AddTraceData(pMessage:GetCookie(cName), pTraceData).
            end.
        end. // DenyAll
    end method.

end class.
