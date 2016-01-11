/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HtmlEntityFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Entity.EntityContentTypeFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Lang.Object.
using OpenEdge.Core.String.

class OpenEdge.Net.HTTP.Filter.Entity.HtmlEntityFilter inherits EntityContentTypeFilter: 
    constructor public HtmlEntityFilter(input poMessage as HttpMessage):
		super (get-class(String), poMessage).
    end constructor.
    
    /** Replaces any existing message body with HTMl content. this is not an append. */
    method override public logical AddEntity(input poEntity as Object):
        assign this-object:Message:ContentType = 'text/html'.
        return true.
    end method.
    
end class.