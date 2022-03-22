/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IOutputConfig
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2021-09-22
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.Trace.Formatter.ITraceFormatter.
using OpenEdge.Net.HTTP.Trace.Writer.ITraceWriter.

interface OpenEdge.Net.HTTP.Trace.IOutputConfig:  

    /** The formatter object to use before writing */
    define public property Formatter as ITraceFormatter no-undo
        get.
        set.
    
    /** A writer object used to write formatted data. */
    define public property Writer as ITraceWriter no-undo
        get.
        set.
    
end interface.