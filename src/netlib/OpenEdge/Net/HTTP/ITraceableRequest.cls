/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ITraceableRequest
    Purpose     : An interface used to identify a request as allowing tracing.
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : Tue Aug 17 11:34:10 EST 2021
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule.

interface OpenEdge.Net.HTTP.ITraceableRequest: 
    
    /* TRUE if tracing is enabled for this request; FALSE otherwise */
    define public property TracingEnabled as logical no-undo get.
    
    /** Object for storing traced information on this request+response. */
    define public property TraceData as ExchangeData no-undo get. set.
    
    /* A set of Request rules to apply. May be null/indeterminate! */
    define public property RequestRules as ITraceDataRule extent no-undo
        get.
        set.
    
    /* A set of Response rules to apply. May be null/indeterminate! */
    define public property ResponseRules as ITraceDataRule extent no-undo
        get.
        set.
    
    /** Marks the decorated request as permanently opted out of any tracing. */
    method public void DisableTracing().
    
end interface.
