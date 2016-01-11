/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : FormDataEntityFilter
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
using OpenEdge.Core.Collections.IStringStringMap.

class OpenEdge.Net.HTTP.Filter.Entity.FormDataEntityFilter inherits EntityContentTypeFilter: 
    constructor public FormDataEntityFilter(input poMessage as HttpMessage):
		super(get-class(IStringStringMap), poMessage).
    end constructor.
    
    method override public logical AddEntity(input poEntity as Object):
        assign this-object:Message:ContentType = 'application/x-www-form-urlencoded'.

        return true.
    end method.
    
end class.