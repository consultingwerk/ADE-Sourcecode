/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HtmlExtractEntityFilter
    Purpose     : Constructs a Message Body from a request's Entity 
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
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Core.String.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.ConcreteHttpRequest.

class OpenEdge.Net.HTTP.Filter.Payload.HtmlExtractEntityFilter implements IMessageFilter:
    define private variable mcTypes as character extent 1 no-undo
        initial ['text/html'].
     
    constructor public HtmlExtractEntityFilter():
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage):
        define variable lCanFilter as logical no-undo.
        define variable oEntity as Object no-undo.
        define variable iLoop as integer no-undo.
        
        lCanFilter = type-of(poMessage, HttpRequest).
        
        if lCanFilter then
            assign oEntity    = cast(poMessage, HttpRequest):Entity
                   lCanFilter = valid-object(oEntity) and 
                                oEntity:GetClass():IsA(get-class(String)).

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
        define variable oConcreteRequest as ConcreteHttpRequest no-undo.
        
        oConcreteRequest = cast(poMessage, ConcreteHttpRequest).
        oConcreteRequest:AddMessageBody().
        oConcreteRequest:MessageBody
            :PutString(cast(oConcreteRequest:Entity, String)).

        return FilterActionEnum:Stop.
    end method.
    
end class.