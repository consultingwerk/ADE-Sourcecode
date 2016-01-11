/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MessageBodyFilter
    Purpose     : Filter for reading/writing a message's Entity(body/payload)
                  between a MEMPTR and an ABL Object, based on Content-Type  
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:43:22 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.Filter.Body.MessageBodyFilter.  
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Body.MessageBodyFilter abstract:
    /** (mandatory) The message (request/response) that this filter is applied to. */
    define public property Message as HttpMessage no-undo get. private set.

    /** the ContentType that this filter applies to */
    define public property ContentType as character extent no-undo get. protected set.

    constructor public MessageBodyFilter(input pcContentType as character extent,
                                         input poMessage as HttpMessage):
        Assert:NotNull(poMessage, 'Message ').
        Assert:HasDeterminateExtent(pcContentType, 'Content Type').
        
        assign this-object:ContentType = pcContentType
               this-object:Message = poMessage.
    end constructor.
    
    /* To be implemented by the individual filter types.
       These methods are input-output because the Object and ByteBucket objects
       may be (re)created by the method. */
    method abstract public logical ExtractBody(input-output poEntity as Object):        
    method abstract public logical InsertBody(input-output poMessageBody as ByteBucket):
end class.