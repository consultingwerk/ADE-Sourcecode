/************************************************
Copyright (c) 2015, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : DefaultMessageWriterBuilder
    Purpose     : Builds a request writer for a given type of entity
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 09:30:28 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.MessageWriterBuilder.
using OpenEdge.Net.ISupportEncoding.
using OpenEdge.Net.ISupportMultipartEntity.

class OpenEdge.Net.HTTP.Filter.Writer.DefaultMessageWriterBuilder inherits MessageWriterBuilder:
    
    /** Each concrete builder will implement this differently */
    define override public property Writer as MessageWriter no-undo 
        get():
            return NewMessageWriter().
        end get.
    
    /** Constructor
    
        @param character The content type this builder is creating.
        @param BuilderRegistry The registry that contains the mappings between content types and writers*/
    constructor public DefaultMessageWriterBuilder(input pcContentType as character,
                                                   input poRegistry as BuilderRegistry):
        super(pcContentType, poRegistry).
    end method.
    
    method private MessageWriter NewMessageWriter():
        define variable oWriter as MessageWriter no-undo.
        define variable oWriterType as class Progress.Lang.Class no-undo.
        define variable cEntityType as character no-undo.
        define variable oEntity as Progress.Lang.Object no-undo.
        
        assign oWriterType = this-object:GetWriter(this-object:ContentType).
        if not valid-object(oWriterType) then
            return oWriter.
        
        /* double-check we have the correct type */
        Assert:IsType(oWriterType, get-class(MessageWriter)).
        
        oWriter= dynamic-new string(oWriterType:TypeName) ().
        
        if HasOption('entity':u) then
            /* Direct property on LHS of assigment a no-go because of PSC00336173. We use a temp/intermediary instead */
            assign oEntity = dynamic-cast(GetOptionObjectValue('entity':u),
                                          GetOptionStringValue('entityType':u))                                          
                   oWriter:Entity = oEntity.
        
        if     HasOption('encodedAs':u) 
           and type-of(oWriter, ISupportEncoding) 
        then
            assign cast(oWriter, ISupportEncoding):Encoding = GetOptionStringValue('encodedAs':u). 
        
        if     type-of(oWriter, ISupportMultipartEntity)
           and HasOption('multipartBoundary':u)
        then
            assign cast(oWriter, ISupportMultipartEntity):Boundary = GetOptionStringValue('multipartBoundary':u).
        
        if type-of(oWriter, ISupportInitialize) then
            cast(oWriter, ISupportInitialize):Initialize().
            
        return oWriter.            
    end method.    
    
end class.