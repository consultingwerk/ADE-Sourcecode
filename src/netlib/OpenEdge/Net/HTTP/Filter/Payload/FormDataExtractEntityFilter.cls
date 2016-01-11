/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : FormDataAddEntityFilter
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
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.ConcreteHttpRequest.

class OpenEdge.Net.HTTP.Filter.Payload.FormDataExtractEntityFilter implements IMessageFilter:
    define private variable mcTypes as character extent 1 no-undo
        initial ['application/x-www-form-urlencoded'].
    
    constructor public FormDataExtractEntityFilter():
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
                                oEntity:GetClass():IsA(get-class(IStringStringMap)).
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
        @param Object Filter data. This argument is input-output because the 
                      filter data objects may be (re)created by the method.
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage).
        define variable oIterator as IIterator no-undo.
        define variable cDelimiter as character no-undo.
        define variable oEntry as MapEntry no-undo.
        define variable oConcreteRequest as ConcreteHttpRequest no-undo.
        
        oConcreteRequest = cast(poMessage, ConcreteHttpRequest).
        oConcreteRequest:AddMessageBody().
        
        assign cDelimiter = ''
               oIterator = cast(poMessage:Entity, IStringStringMap):EntrySet:Iterator().
        do while oIterator:HasNext():
            oEntry = cast(oIterator:Next(), MapEntry).
                        
            oConcreteRequest:MessageBody:PutString(
                            cDelimiter + substitute('&1=&2', oEntry:Key:ToString(), oEntry:Value:ToString())).
            assign cDelimiter = '&'.
        end.

    end method.
    
end class.