/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ITraceFormatter
    Purpose     : Interface for formatting tracing data 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2021-09-22
    Notes       : 
  ----------------------------------------------------------------------*/

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Net.HTTP.Trace.ExchangeData.

interface OpenEdge.Net.HTTP.Trace.Formatter.ITraceFormatter:  

    /** Formats the input tracing data into a set of bytes to be written (typically).
        This method may produce JSON or some other structured representation.
       
        @param ExchangeData[] An array of trace data
        @return IMemptrHolder The formatted representation of the trace data */
    method public IMemptrHolder Format (input pTraceData as ExchangeData extent).

end interface.