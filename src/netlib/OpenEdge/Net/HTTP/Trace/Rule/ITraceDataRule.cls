/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ITraceDataRule
    Purpose     : Interface for tracing rules that add/update trace data on the ExchangeData
                  object
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-12-07
    Notes       :
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceRule.

@since(rel='12.5.0').
interface OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule
inherits ITraceRule:
    
    /* Method to apply policy (and exceptions) to HTTP messages (request or response).
       
       @param IHttpMessage The Request or Response object being processed
       @param ExchangeData The current trace data. A rule may update this data */
    method public void ApplyPolicy (input pMessage as IHttpMessage,
                                    input pTraceData as ExchangeData ).

end interface.