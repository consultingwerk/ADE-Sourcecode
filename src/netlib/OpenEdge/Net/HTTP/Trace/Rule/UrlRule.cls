/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : UrlRule
    Purpose     : Trace rule to determine whether a request URL should be traced or not
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-08-24
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceFilterRule.
using OpenEdge.Net.HTTP.Trace.Rule.TraceRule.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Object.
 
@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.UrlRule
inherits TraceRule
implements ITraceFilterRule:

    // URL rules only apply as a request filter, so only policy type is required.
    constructor public UrlRule ( input pPolicy as PolicyTypeEnum ):
        super(MessageTypeEnum:Request, pPolicy).
    end constructor.
        
    /* Setter for Policy Exceptions

       @param Object[] List of exception objects */
    method public override void SetPolicyExceptions ( input pExceptions as Object extent ):
        define variable iExCnt as integer no-undo.
        define variable iLoop  as integer no-undo.

        /* Convert any special object types to String for consistency. */
        assign iExCnt = extent(pExceptions).
        EXCEPTION-LOOP:
        do iLoop = 1 to iExCnt:
            if not valid-object(pExceptions[iLoop]) then
                next EXCEPTION-LOOP.

            // Determine how to map the incoming object to a String, with a format of "METHOD URL" similar to Curl, et al.
            if type-of(pExceptions[iLoop], JsonObject) then do:
                // Convert a JsonObject with method and url properties.
                if JsonPropertyHelper:HasTypedProperty(cast(pExceptions[iLoop], JsonObject), "method", JsonDataType:String) and
                   JsonPropertyHelper:HasTypedProperty(cast(pExceptions[iLoop], JsonObject), "url", JsonDataType:String) then
                    pExceptions[iLoop] = new String(substitute("&1 &2",
                                                               cast(pExceptions[iLoop], JsonObject):GetCharacter("method"),
                                                               cast(pExceptions[iLoop], JsonObject):GetCharacter("url"))).
                else if not JsonPropertyHelper:HasTypedProperty(cast(pExceptions[iLoop], JsonObject), "method", JsonDataType:String) and
                       JsonPropertyHelper:HasTypedProperty(cast(pExceptions[iLoop], JsonObject), "url", JsonDataType:String) then
                        pExceptions[iLoop] = new String(substitute("* &1", cast(pExceptions[iLoop], JsonObject):GetCharacter("url"))).
            end.
            else if type-of(pExceptions[iLoop], ICharacterHolder) then
                // Utilize the value of character objects.
                pExceptions[iLoop] = new String(substitute("* &1", cast(pExceptions[iLoop], ICharacterHolder):Value)).
            else if type-of(pExceptions[iLoop], ILongcharHolder) then
                // Utilize the value of longchar objects.
                pExceptions[iLoop] = new String(substitute("* &1", cast(pExceptions[iLoop], ILongcharHolder):Value)).
            else if type-of(pExceptions[iLoop], URI) then
                // Convert any URI objects using the ToString() method.
                pExceptions[iLoop] = new String(substitute("* &1", pExceptions[iLoop]:ToString())).
            else
                return error new Progress.Lang.AppError(substitute("Unknown policy exception type: &1", pExceptions[iLoop]:GetClass():TypeName), 0).
        end.

        super:SetPolicyExceptions(pExceptions).
    end method.

    /* Method to apply policy (and exceptions) to HTTP messages (request ONLY for this class).
       
       @param IHttpMessage The Request or Response object (message) being processed
       @return logical If FALSE then the processing of the rule chain halts; if TRUE the next rule (if any) in the chain is processed  */
    method public logical ApplyPolicy(input pMessage as IHttpMessage):
        define variable iExCnt     as integer no-undo.
        define variable iLoop      as integer no-undo.
        define variable oUriString as String  no-undo.

        // Cannot handle being given a response type object.
        if type-of(pMessage, IHttpResponse) then
            return false. // Stop processing.
        
        // Build request URI's as "METHOD URL" (eg. "GET http://localhost/") for use with "matches".
        // It is expected the URL exceptions may contain wildcards (eg. "* http://localhost/*/web").
        if type-of(pMessage, IHttpRequest) then
            oUriString = new String(substitute("&1 &2",
                                               cast(pMessage, IHttpRequest):Method,
                                               cast(pMessage, IHttpRequest):URI:ToString())).

        // Process exceptions to the policy; note that performance will be affeced by the length of this list.
        iExCnt = extent(PolicyExceptions).
        if iExCnt ne ? and iExCnt gt 0 then
        EXCEPTION-LOOP:
        do iLoop = 1 to iExCnt:
            if not valid-object(PolicyExceptions[iLoop]) then
                next EXCEPTION-LOOP.

            // For allow-all, matched exceptions will stop rule processing.
            if Policy eq PolicyTypeEnum:Allow-All
            and (string(oUriString:Value) matches string(PolicyExceptions[iLoop]))
            then
                return false. // Exception is to deny this method+url.

            // For deny-all, matched exceptions will continue rule processing.
            if Policy eq PolicyTypeEnum:Deny-All
            and (string(oUriString:Value) matches string(PolicyExceptions[iLoop]))
            then
                return true. // Exception is to allow this method+url.
        end. // oExceptions
        
        // If exception list was empty or no exceptions allowed, proceed as based on the policy itself.
        case Policy:
            when PolicyTypeEnum:Allow-All then
                return true. // Default is to consider any request to be allowed.
            when PolicyTypeEnum:Deny-All then
                return false. // Default is to consider any request to be denied.
            otherwise
                return true. // Other policies, if enum supports additional values in the future.
        end case.

        catch uncaught as Progress.Lang.Error:
            return false. // Assume errors to mean cancelling further processing.
        end catch.
    end method.
    
end class.