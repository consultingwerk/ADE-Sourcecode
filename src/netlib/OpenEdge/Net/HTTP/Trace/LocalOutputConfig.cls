/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LocalOutputConfig
    Purpose     : Holds configuration for "local" trace output
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-09-22
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Trace.IOutputConfig.
using OpenEdge.Net.HTTP.Trace.Formatter.ITraceFormatter.
using OpenEdge.Net.HTTP.Trace.Writer.ITraceWriter.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.LocalOutputConfig
implements IOutputConfig:

    /** The formatter object to use before writing. */
    define public property Formatter as ITraceFormatter no-undo
        get.
        set.
    
    /** A writer obejct used to write formatted data. */
    define public property Writer as ITraceWriter no-undo
        get.
        set.
    
    method override public character ToString():
        return substitute('&1 [Writer: &2; Formatter: &3]',
                          super:ToString(),
                          string(this-object:Writer),
                          string(this-object:Formatter) ).
    end method.
end class.