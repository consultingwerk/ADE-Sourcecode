/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : EntityContentTypeFilter
    Purpose     : Filter for reading/writing a message's Entity(body/payload)
                  between a MEMPTR and an ABL Object, based on Content-Type
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:43:22 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Entity.EntityContentTypeFilter abstract:
    /** (mandatory) The message (request/response) that this filter is applied to. */
    define public property Message as HttpMessage no-undo get. private set.
    
    /** the EntityType that this filter applies to */
    define public property EntityType as Progress.Lang.Class no-undo get. protected set.
    
    constructor public EntityContentTypeFilter(input poEntityType as class Progress.Lang.Class,
                                               input poMessage as HttpMessage):
        Assert:NotNull(poMessage, 'Message ').
        Assert:NotNull(poEntityType, 'Entity Type').
        
        assign this-object:EntityType = poEntityType
               this-object:Message = poMessage.
    end constructor.
    
    /* to be implemented by the individual filter types*/
    method abstract public logical AddEntity(input poEntity as Object):
        
end class.