/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ITraceFilterRule
    Purpose     : Interface for tracing rules that determine whether a request or response should be traced
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-12-07
    Notes       :
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceRule.

@since(rel='12.5.0').
interface OpenEdge.Net.HTTP.Trace.Rule.ITraceFilterRule
inherits ITraceRule:
    
    /* Method to apply policy (and exceptions) to HTTP messages (request or response).
       
       @param IHttpMessage The Request or Response object being processed
       @return logical If FALSE then the processing of the rule chain halts; if TRUE the next rule (if any) in the
                       chain is processed */
    method public logical ApplyPolicy (input pMessage as IHttpMessage).

end interface.