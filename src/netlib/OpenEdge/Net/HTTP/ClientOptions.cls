/************************************************
Copyright (c) 2014-2016, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ClientOptions
    Purpose     : A set of options for the HttpClient
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Fri May 23 13:41:30 EDT 2014
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.File.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Trace.TraceConfig.

class OpenEdge.Net.HTTP.ClientOptions:
    /** How many retries of the same request should be attempted */
    define public property NumRetries as integer initial 10  no-undo get. set.
    
    /** The number of seconds (incl. fractions of seconds) between retries */
    define public property PauseBetweenRetry as decimal initial 0 no-undo get. set.
    
    /** Defines the maximum time a request must take */
    define public property RequestTimeout as decimal initial 0 no-undo get. set.
    
    /** Defines whether tracing is allowed for this client */
    @since(rel='12.5.0').
    define public property AllowTracing as logical initial false no-undo
        get.
        set(input lVal as logical):
            /* Did not give an explicit "true" value, so assume "false". */
            if lVal eq ? then
                assign AllowTracing = false.
            else
                assign AllowTracing = lVal. /* True/False */
        end set.
    
    /* (optional) Holds trace config data, either as a JSON object (holding actual config data) or a File object (where config data may exist)
       or TraceConfig (actyual config object) */
    @since(rel='12.5.0').
    define public property TraceConfig as Object no-undo
        get.
        set(input pConfig as Object):
            if valid-object(pConfig)
            and not type-of(pConfig, JsonObject)
            and not type-of(pConfig, File)
            and not type-of(pConfig, TraceConfig)
            then
                undo, throw new AssertionFailedError(substitute('Config object &1 is not of type: &2, &3 or &4',
                                                            string(pConfig),
                                                            get-class(JsonObject):TypeName,
                                                            get-class(File):TypeName,
                                                            get-class(TraceConfig):TypeName ), 0).
            
            assign this-object:TraceConfig = pConfig.
        end set.
    
    constructor public ClientOptions():
        /** Default constructor */
    end constructor.
    
end class.