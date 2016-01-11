/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonentityFilter
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
using Progress.Json.ObjectModel.JsonConstruct.

class OpenEdge.Net.HTTP.Filter.Entity.JsonEntityFilter inherits EntityContentTypeFilter: 
    constructor public JsonEntityFilter(input poMessage as HttpMessage):
		super(get-class(JsonConstruct), poMessage).
    end constructor.
    
    method override public logical AddEntity(input poEntity as Object):
        assign this-object:Message:ContentType = 'application/json'.
        return true.
    end method.
    
end class.