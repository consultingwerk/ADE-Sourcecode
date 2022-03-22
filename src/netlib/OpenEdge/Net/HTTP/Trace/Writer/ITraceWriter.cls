/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ITraceWriter
    Purpose     : INterface to write formatted trace data
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2021-09-22
    Notes       : 
  ----------------------------------------------------------------------*/

using Ccs.Common.Support.IMemptrHolder.

interface OpenEdge.Net.HTTP.Trace.Writer.ITraceWriter:  

    /** Writes formatted trace data. Eg to disk or a network
        service like a Kafka queue.
        
        @param IMemptrHolder Formatted data. */
    method public void Write (input pData as IMemptrHolder).
    
end interface.