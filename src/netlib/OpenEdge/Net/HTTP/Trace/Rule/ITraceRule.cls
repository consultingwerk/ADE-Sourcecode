/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ITraceRule
    Purpose     : Interface for tracing rules. Individual rules implement this face
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-08-24
    Notes       :
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using Progress.Lang.Object.

@since(rel='12.5.0').
interface OpenEdge.Net.HTTP.Trace.Rule.ITraceRule:
    
    /* Indicates which messages this rule applies to: REQUEST, RESPONSE or both  */
    define public property MessageType as MessageTypeEnum no-undo
        get.
    
    /* The policy applicable to this rule (allow-all or deny-all) */
    define public property Policy as PolicyTypeEnum no-undo
        get.
    
    /* Policy exceptions (may be none). The actual type of the exception varies per rule */
    define public property PolicyExceptions as Object extent no-undo
        get.
    
    /* Setter for Policy Exceptions

       @param Object[] List of exception objects */
    method public void SetPolicyExceptions ( input pExceptions as Object extent ).

end interface.