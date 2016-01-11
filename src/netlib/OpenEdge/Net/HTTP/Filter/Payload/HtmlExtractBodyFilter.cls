/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HtmlExtractBodyFilter
    Purpose     : Populates an Entity from the Message Body (extracts data 
                  from a ByteBucket)
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
using OpenEdge.Core.String.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.ConcreteHttpResponse.

class OpenEdge.Net.HTTP.Filter.Payload.HtmlExtractBodyFilter implements IMessageFilter:
    define private variable mcTypes as character extent 1 no-undo
        initial ['text/html'].
     
    constructor public HtmlExtractBodyFilter():
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
        define variable lcData as longchar no-undo.
        define variable cCharset as character no-undo.
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oData as class Memptr no-undo.
        define variable oConcreteResponse as ConcreteHttpResponse no-undo.
        
        iMax = num-entries(poMessage:ContentTypeEncoding, ';').
        
        do iLoop = 1 to iMax:
            assign cName  = entry(iLoop, poMessage:ContentTypeEncoding, ';')
                   cValue = entry(2, cName, '=')
                   cName  = entry(1, cName, '=').
            
            if cName eq 'charset' then
                cCharset = cValue.
        end.
        
        if cCharset eq '' then
            cCharset = 'UTF-8'.
        
        fix-codepage(lcData) = cCharset.
        oConcreteResponse = cast(poMessage, ConcreteHttpResponse).
        
        if poMessage:ContentLength gt 0 then
        do:
            assign oData = oConcreteResponse:MessageBody:GetBytes().
            if session:debug-alert then
                copy-lob from oData:Value to file session:temp-directory + 'body.txt'.
            copy-lob from oData:Value 
                        for poMessage:ContentLength /* - 1 */
                     to lcData.
        end.
        
        oConcreteResponse:AddEntity(new String(lcData)).
        
        return FilterActionEnum:Stop.
    end method.
    
end class.