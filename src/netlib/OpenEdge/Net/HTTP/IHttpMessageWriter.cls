/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : IHttpMessageWriter
    Purpose     : General interface for writing (serializing) data from an HttpMessage
                  (request or response) to an output location (which is determined
                  by the implementation).
    Syntax      : 
    Description : 
    Author(s)   : pjudge / mbanks
    Created     : Wed Jan 28 12:43:33 EST 2015
    Notes       : * The non-reference types (like CHAR and LONGCHAR) are passed as input-output
                    parameters so that they may act like reference types.
  ----------------------------------------------------------------------*/
using OpenEdge.Net.HTTP.IHttpMessage.
using Progress.Lang.Object.

interface OpenEdge.Net.HTTP.IHttpMessageWriter:
    /** (mandatory) The message that's being written to. The values passed in to the Write() methods
        will be parsed/processed and writted to this message. */  
    define public property Message as IHttpMessage no-undo get.
    
    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open().

    /** Write data to/from the message  
    
        @param Object Data to write */
    method public void Write(input poData as Object).

    /** Write data to/from the message 
        
        @param longchar Data to write */
    method public void Write(input-output pcData as longchar).
    
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle).

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character).
    
    /** Write data to/from the message  
    
        @param memptr Data to write */
    method public void Write(input pmData as memptr).
    
    /**  Flushes data to the output location. What data is flushed depends on the implementation */
    method public void Flush().
    
    /**  Closes the output. See Open() */
    method public void Close().
    
end interface.