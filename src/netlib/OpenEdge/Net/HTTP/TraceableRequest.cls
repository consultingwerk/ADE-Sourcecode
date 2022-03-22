/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TraceableRequest
    Purpose     : Decorates an HTTP request with tracing options/metrics.
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : Tue Aug 17 11:39:10 EST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Net.HTTP.HttpRequestDecorator.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.ITraceableRequest.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule.

class OpenEdge.Net.HTTP.TraceableRequest inherits HttpRequestDecorator implements ITraceableRequest:
    
    /* TRUE if tracing is enabled for this request; FALSE otherwise */
    define public property TracingEnabled as logical no-undo
        get.
        private set.
    
    /* A set of Request rules to apply. May be null/indeterminate! */
    define public property RequestRules as ITraceDataRule extent no-undo
        get.
        set.
    
    /* A set of Response rules to apply. May be null/indeterminate! */
    define public property ResponseRules as ITraceDataRule extent no-undo
        get.
        set.
        
    /** Object for storing traced information on this request+response. */
    define public property TraceData as ExchangeData no-undo 
        get.
        set.
    
    /** Constructor.
        
        @param OpenEdge.Net.HTTP.IHttpRequest Request being decorated */
    constructor public TraceableRequest ( input poHttpRequest as IHttpRequest ):
        super (input poHttpRequest).

        assign this-object:TracingEnabled = true. /* Set as traceable by default. */
    end constructor.
    
    method public void DisableTracing():
        /* Explicitly disable tracing; prevents re-enablement for this request. */
        assign this-object:TracingEnabled        = false
               this-object:TraceData             = ?
               extent(this-object:RequestRules)  = ?
               extent(this-object:ResponseRules) = ?
               .
    end method.

end class.