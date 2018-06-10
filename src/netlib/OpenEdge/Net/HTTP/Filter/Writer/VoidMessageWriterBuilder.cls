/************************************************
Copyright (c)  2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : VoidMessageWriterBuilder
    Purpose     : Builds a void message writer builder 
    Author(s)   : pjudge
    Created     : 2017-12-14
    Notes       : * A no-op message writer-builder that allows us to still
                    chain calls to the writer builder without breaking when
                    there's no writer defined
                    For example, if there's no content-type header we want this 
                    line to still run, without returning a 'chained references' error 
                        assign oEntityWriter = EntityWriterBuilder:Build(poRequest):Writer.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.MessageWriterBuilder.

class OpenEdge.Net.HTTP.Filter.Writer.VoidMessageWriterBuilder inherits MessageWriterBuilder:
    
    /** Each concrete builder will implement this differently */
    define override public property Writer as MessageWriter no-undo get. 
    
    /** Constructor
        
        @param character The content type this builder is creating.
        @param BuilderRegistry The registry that contains the mappings between content types and writers*/
    constructor public VoidMessageWriterBuilder(input pcContentType as character,
                                                input poRegistry as BuilderRegistry):
        super(pcContentType, poRegistry).
    end method.
    
end class.