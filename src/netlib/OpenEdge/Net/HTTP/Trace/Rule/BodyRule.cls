/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : BodyRule
    Purpose     : Message body rule - for FILTER and DATA policies
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-08-24
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.PolicyTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.TraceRule.
using Progress.Lang.Object.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Rule.BodyRule
inherits TraceRule
abstract:
    
    /* Holds the array values as a CSV */
    define protected property MimeTypes as character no-undo
        get.
        private set.
    
    // Body may apply to requests or responses, so both rule and policy types are required.
    constructor protected BodyRule(input pMessageType as MessageTypeEnum,
                                   input pPolicy as PolicyTypeEnum ):
        super(pMessageType, pPolicy).
    end constructor.
    
    /* Setter for Policy Exceptions

       @param Object[] List of exception objects */
    method override public void SetPolicyExceptions(input pExceptions as Object extent):
        var character   delim = '':u.
        var integer loop, cnt = extent(pExceptions).
        
        super:SetPolicyExceptions(pExceptions).
        
        // Build a CSV list of the mime type. Do a single loop through the exceptions
        // Do this once, when the exceptions are set.
        assign this-object:MimeTypes = '':u.
        do loop = 1 to cnt:
            if valid-object(PolicyExceptions[loop]) then
                assign this-object:MimeTypes = this-object:MimeTypes
                                             + string(PolicyExceptions[loop])
                                             + delim
                       delim      = ',':u
                       .
        end.
    end method.
    
end class.
