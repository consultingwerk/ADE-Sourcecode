/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : XmlBodyFilter
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
using OpenEdge.Core.WidgetHandle.

class OpenEdge.Net.HTTP.Filter.Entity.XmlEntityFilter inherits EntityContentTypeFilter: 
    constructor public XmlEntityFilter(input poMessage as HttpMessage):
		super(get-class(WidgetHandle), poMessage).
    end constructor.
    
    method override public logical AddEntity(input poEntity as Object):
        if cast(poEntity, WidgetHandle):Value:type eq 'x-document' then
        do:
            assign this-object:Message:ContentType = 'application/xml'.
            return true.
        end.
        
        return false.            
    end method.
    
end class.