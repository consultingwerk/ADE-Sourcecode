/************************************************
Copyright (c) 2015, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MessagePart
    Purpose     : A single part of a multipart entity/message
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jul 07 11:32:21 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.HttpHeaderCollection.
using OpenEdge.Net.ISupportEncoding.
using OpenEdge.Net.ISupportMultipartEntity.
using Progress.Lang.Object.

class OpenEdge.Net.MessagePart:
    /** Holds headers for this part */
    define public property Headers as HttpHeaderCollection no-undo get. private set.
    
    /** The entity's content type (eg text/html). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    define public property ContentType as character no-undo
        get():
            /* Content-Type header */
            if Headers:Has('Content-Type':u) then
                return Headers:Get('Content-Type':u):GetBaseValue().
            else
                return '':u.
        end get.
        set(input pcContentType as character):
            define variable oHeader as HttpHeader no-undo.
            
            Assert:NotNull(pcContentType, 'Content Type').
            
            /* Content-Type */
            if Headers:Has('Content-Type':u) then
                assign oHeader = Headers:Get('Content-Type':u).
            else
            do:
                assign oHeader = HttpHeaderBuilder:Build('Content-Type':u)
                                    :Header.
                Headers:Put(oHeader).
            end.
            
            assign oHeader:Value = pcContentType.
        end set.

    /** The entity's content ID. */
    define public property ContentID as character no-undo
        get():
            /* Content-ID header */
            if Headers:Has('Content-ID':u) then
                return Headers:Get('Content-ID':u):GetBaseValue().
            else
                return '':u.
        end get.
        set(input pcContentID as character):
            define variable oHeader as HttpHeader no-undo.
            
            Assert:NotNull(pcContentID, 'Content ID').
            
            /* Content-ID */
            if Headers:Has('Content-ID':u) then
                assign oHeader = Headers:Get('Content-ID':u).
            else
            do:
                assign oHeader = HttpHeaderBuilder:Build('Content-ID':u)
                                    :Header.
                Headers:Put(oHeader).
            end.
            
            assign oHeader:Value = pcContentID.
        end set.
    
    /** the actual entity body */
    define public property Body as Object no-undo
        get.
        set(input poBody as Object):
            if valid-object(poBody) then
            do:
                if type-of(poBody, ISupportEncoding) then
                    Headers:Get('Content-Type':u)
                        :SetParameterValue('charset':u,
                                           cast(poBody, ISupportEncoding):Encoding).

                if type-of(poBody, ISupportMultipartEntity) then
                    Headers:Get('Content-Type':u)
                        :SetParameterValue('boundary':u,
                                           cast(poBody, ISupportMultipartEntity):Boundary). 
            end.
            
            assign this-object:Body = poBody.
        end set.

    /** Default Constructor. */
    constructor public MessagePart():
        /* A part's Content-Type defaults to this, 
           per http://tools.ietf.org/html/rfc2046#section-5.1 */
        this-object('text/plain':u).
    end constructor.
    
    /** Constructor.
    
        @param character The content type for this part. */
    constructor public MessagePart(input pcContentType as character):
        Assert:NotNull(pcContentType, 'Content type').
        
        assign this-object:Headers     = new HttpHeaderCollection()
               this-object:ContentType = pcContentType
               .
    end constructor.
    
    /** Constructor.
    
        @param character The content type for this part. 
        @param Object The content itself */
    constructor public MessagePart(input pcContentType as character,
                                   input poBody as Object):
        this-object(pcContentType).
        Assert:NotNull(poBody, 'Part body').
        
        assign this-object:Body = poBody.
    end constructor.                                       
    
    method override public character ToString():
        return substitute('&1_&2':u, 
                    this-object:ContentType, 
                    (if valid-object(this-object:Body) then this-object:Body:ToString() else string(int64(this-object)))).
    end method.
end class.