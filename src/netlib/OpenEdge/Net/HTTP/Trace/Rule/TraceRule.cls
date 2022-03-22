/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : TraceRule
    Purpose     : Abstract tracerule class - holds information about the rule.
                  Child classes provide the implementation of the rule in
                  their ApplyPolicy() method overrides.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-08-24
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceRule.
using Progress.Lang.Object.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.TraceRule
abstract
implements ITraceRule, ISupportLogging:

    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).

            return this-object:Logger.
        end get.
        set.

    /* Indicates which messages this rule applies to: REQUEST, RESPONSE or both  */
    define public property MessageType as MessageTypeEnum no-undo
        get.
        private set.
    
    /* The policy applicable to this rule (Allow-All or Deny-All) */
    define public property Policy as PolicyTypeEnum no-undo
        get.
        private set.
    
    /* Policy exceptions (may be none) */
    define public property PolicyExceptions as Object extent no-undo
        get.
        private set.
    
    /** Constructor
       
        @param MessageTypeEnum Required. The type of message that this rule applies to.
        @param PolicyTypeEnum Required. The policy the rule applies */
    constructor protected TraceRule( input pMessageType as MessageTypeEnum,
                                     input pPolicy as PolicyTypeEnum ):
        Assert:NotNull(pMessageType, 'Message type').
        Assert:NotNull(pPolicy, 'Policy type').

        assign this-object:Policy      = pPolicy
               this-object:MessageType = pMessageType
               .
    end constructor.
    
    /* Setter for Policy Exceptions

       @param Object[] List of exception objects */
    method public void SetPolicyExceptions ( input pExceptions as Object extent ):
        assign this-object:PolicyExceptions = pExceptions.
    end method.
    
    /* Override method to return a string version of this rule's contents.

       @return character String representation of policy and exceptions */
    method override public character ToString ( ):
        define variable cString as character no-undo.
        define variable iCount  as integer   no-undo.
        define variable iExcept as integer   no-undo.

        assign
            cString = substitute("Trace Rule: &1; MessageType: &2; Policy: &3; Exceptions:",
                                 super:ToString(),
                                 string(this-object:MessageType),
                                 string(this-object:Policy)).
            iCount  = extent(this-object:PolicyExceptions)
            .
        
        if iCount ne ? then
        EXCEPT-LOOP:
        do iExcept = 1 to iCount:
            cString = substitute("&1 &2,":u, cString, this-object:PolicyExceptions[iExcept]:ToString()).
        end.
        
        return trim(cString, ",":u).
    end method.

end class.