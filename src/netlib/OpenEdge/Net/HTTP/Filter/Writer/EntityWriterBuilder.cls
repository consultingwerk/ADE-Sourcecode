/************************************************
Copyright (c) 2015, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : EntityWriterBuilder
    Purpose     : Helper class to builds an entity writer for a given type of content 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 09:30:28 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterRegistry.
using OpenEdge.Net.HTTP.Filter.Writer.MessageWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.MessagePart.

class OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder:
    
    /** Helper method that returns an entity writer for a message part 
        
        @param  MessagePart The message part being processed
        @return MessageWriterBuilder The entity writer to use */
    method static public MessageWriterBuilder Build(input poPart as MessagePart):
        define variable oHeader as HttpHeader no-undo.
        
        if not poPart:Headers:Has('Content-Type':u) then
            undo, throw new AssertionFailedError('Message part Content-Type header cannot be null', 0). 
        
        assign oHeader = poPart:Headers:Get('Content-Type':u).
        
        return EntityWriterBuilder:Build(poPart:ContentType)
                            :Option('encodedAs':u, oHeader:GetParameterValue('charset':u))
                            :Option('multipartBoundary':u, oHeader:GetParameterValue('boundary':u)).
    end method.
    
    /** Returns an entity writer for a message
        
        @param  IHttpMessage The message being processed
        @return MessageWriterBuilder The entity writer builder to use */
    method static public MessageWriterBuilder Build(input poMessage as IHttpMessage):
        define variable oHeader as HttpHeader no-undo.
        
        assign oHeader = poMessage:GetHeader('Content-Type':u).
        
        return EntityWriterBuilder:Build(poMessage:ContentType)
                            :Option('encodedAs':u, oHeader:GetParameterValue('charset':u))
                            :Option('multipartBoundary':u, oHeader:GetParameterValue('boundary':u)).
    end method.
    
    /** Returns an entitywriter for a content type
        
        @param  character The content type being processed. 
        @return MessageWriterBuilder The entity writer to use */
    method static public MessageWriterBuilder Build(input pcContentType as character):
        return MessageWriterBuilder:Build(pcContentType, EntityWriterRegistry:Registry).
    end method.
    
end class.