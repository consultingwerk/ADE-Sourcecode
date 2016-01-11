/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonExtractBodyFilter
    Purpose     : Populates an Entity from the Message Body (extracts data 
                  from a ByteBucket)
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.ConcreteHttpRequest.
using Progress.Json.ObjectModel.JsonConstruct.
using OpenEdge.Net.HTTP.ConcreteHttpResponse.
using OpenEdge.Net.HTTP.HttpResponse.

class OpenEdge.Net.HTTP.Filter.Payload.JsonExtractBodyFilter implements IMessageFilter:
    define variable moParser as ObjectModelParser no-undo.
    
    define private variable mcTypes as character extent 2 no-undo
        initial ['application/json', 'application/vnd.progress+json'].
    
    constructor public JsonExtractBodyFilter():
        moParser  = new ObjectModelParser().
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage):
        define variable lCanFilter as logical no-undo.
        define variable iLoop as integer no-undo.
                        
        lCanFilter = type-of(poMessage, HttpResponse).
        
        if lCanFilter then
            assign lCanFilter = valid-object(cast(poMessage, ConcreteHttpResponse):MessageBody).
        
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
        define variable oConcreteResponse as ConcreteHttpResponse no-undo.
        
        oConcreteResponse = cast(poMessage, ConcreteHttpResponse).
        oConcreteResponse
            :AddEntity(cast(moParser:Parse(oConcreteResponse:MessageBody:GetBytes():Value)
                                            , JsonConstruct)).
        
        return FilterActionEnum:Stop.
    end method.    
end class.