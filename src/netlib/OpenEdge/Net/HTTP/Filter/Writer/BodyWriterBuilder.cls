/************************************************
Copyright (c) 2015-2016, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BodyWriterBuilder
    Purpose     : Helper class to builds a body writer for a given type of content type
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 09:30:28 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterRegistry.
using OpenEdge.Net.HTTP.Filter.Writer.MessageWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.MessagePart.

class OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder:
    
    /** Helper method that returns a body writer for a message part 
        
        @param  MessagePart The message part being processed
        @return MessageWriterBuilder The entity writer to use */
    method static public MessageWriterBuilder Build(input poPart as MessagePart):
        define variable oHeader as HttpHeader no-undo.
        define variable msgWrtrBuilder as MessageWriterBuilder no-undo.
        
        if not poPart:Headers:Has('Content-Type':u) then
            undo, throw new AssertionFailedError('Message Content-Type header cannot be null', 0). 
            
        assign oHeader        = poPart:Headers:Get('Content-Type':u)
               msgWrtrBuilder = BodyWriterBuilder:Build(poPart:ContentType)
               .
        if oHeader:HasParameter('charset':u) then
            msgWrtrBuilder:Option('encodedAs':u, oHeader:GetParameterValue('charset':u)).
        
        if oHeader:HasParameter('boundary':u) then
            msgWrtrBuilder:Option('multipartBoundary':u, oHeader:GetParameterValue('boundary':u)).                            
        
        return msgWrtrBuilder.
    end method.
    
    /** Helper method that returns a body writer for a message 
        
        @param  IHttpMessage The message being processed
        @return MessageWriterBuilder The entity writer to use */
    method static public MessageWriterBuilder Build(input poMessage as IHttpMessage):
        define variable oHeader as HttpHeader no-undo.
        define variable msgWrtrBuilder as MessageWriterBuilder no-undo.
        
        // Don't do a GetHeader() since that will return a NullHeader if there's no Content-Type set yet.
        if not poMessage:HasHeader('Content-Type':u) then
            undo, throw new AssertionFailedError('Message Content-Type header cannot be null', 0). 
            
        assign oHeader        = poMessage:GetHeader('Content-Type':u)
               msgWrtrBuilder = BodyWriterBuilder:Build(poMessage:ContentType)
               .
        if oHeader:HasParameter('charset':u) then
            msgWrtrBuilder:Option('encodedAs':u, oHeader:GetParameterValue('charset':u)).
        
        if oHeader:HasParameter('boundary':u) then
            msgWrtrBuilder:Option('multipartBoundary':u, oHeader:GetParameterValue('boundary':u)).                            
        
        return msgWrtrBuilder.
    end method.
    
    /** Returns a body writer for a content type
        
        @param  character The content type being processed. 
        @return MessageWriterBuilder The entity writer to use */
    method static public MessageWriterBuilder Build(input pcContentType as character):
        return MessageWriterBuilder:Build(pcContentType, BodyWriterRegistry:Registry).
    end method.
        
end class.