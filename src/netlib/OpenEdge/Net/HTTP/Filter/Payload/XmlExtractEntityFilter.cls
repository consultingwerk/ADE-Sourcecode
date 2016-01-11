/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : XmlExtractEntityFilter
    Purpose     : Constructs a Message Body from a Response's Entity 
                  (extracts data from an Entity)
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.ConcreteHttpResponse.

class OpenEdge.Net.HTTP.Filter.Payload.XmlExtractEntityFilter implements IMessageFilter:
    define private variable mcTypes as character extent 5 no-undo
        initial ['text/xml',
                 'application/xml',
                 'text/xml-external-parsed-entity',
                 'application/xml-external-parsed-entity',
                 'application/xml-dtd'].

    constructor public XmlExtractEntityFilter():
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage):
        define variable lCanFilter as logical no-undo.
        define variable oEntity as Object no-undo.
        define variable iLoop as integer no-undo.
        
        lCanFilter = type-of(poMessage, HttpResponse).
        
        if lCanFilter then
            assign oEntity    = cast(poMessage, HttpResponse):Entity
                   lCanFilter = valid-object(oEntity) and 
                                oEntity:GetClass():IsA(get-class(WidgetHandle)).
                                
        if lCanFilter then
        do iLoop = 1 to extent(mcTypes):
            lCanFilter = (poMessage:ContentType eq mcTypes[iLoop]).            
            if lCanFilter then
                leave.
        end.
        
        return lCanFilter.
    end method.
    
    /** Performs implementation-specific filtering for a message.
        
        @param HttpMessage The message to filter
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage).
        define variable hDocument as handle no-undo.
        define variable oConcreteResponse as ConcreteHttpResponse no-undo.
        
        oConcreteResponse = cast(poMessage, ConcreteHttpResponse).

        create x-document hDocument.
        hDocument:load('memptr',
                       oConcreteResponse:MessageBody:GetBytes():Value,
                       true).
        oConcreteResponse:AddEntity(new WidgetHandle(hDocument)).

        return FilterActionEnum:Stop.
    end method.
    
end class.