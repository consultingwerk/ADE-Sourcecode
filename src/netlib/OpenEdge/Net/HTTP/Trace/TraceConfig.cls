/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : TraceConfig
    Purpose     : Holds the current tracing configuration
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-08-31
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Trace.OutputTypeEnum.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceDataRule.
using OpenEdge.Net.HTTP.Trace.Rule.ITraceFilterRule.
using Progress.Lang.Object.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.TraceConfig:

    /* Is tracing enabled per config data? */
    define public property Enabled as logical no-undo initial false
        get.
        set.
    
    /* A set of filter Filter rules to apply. May be null/indeterminate! */
    define public property FilterRules as ITraceFilterRule extent no-undo
        get.
        set.
    
    /* A set of Request rules to apply. May be null/indeterminate! */
    define public property RequestRules as ITraceDataRule extent no-undo
        get.
        set.
    
    /* A set of Response rules to apply. May be null/indeterminate! */
    define public property ResponseRules as ITraceDataRule extent no-undo
        get.
        set.
    
    /* Should be OutputTypeEnum with Proxy, Local, Default */
    define public property OutputType as OutputTypeEnum no-undo
        get.
        set.
    
    /* For OutputType=PROXY, should be OE.Net.URI
     For OutputType=LOCAL, something else (eg. formatter) */
    define public property OutputConfig as Object no-undo
        get.
        set.
    
    /* Default constructor */
    constructor public TraceConfig():
        OutputType = OutputTypeEnum:None.
    end constructor.

end class.
