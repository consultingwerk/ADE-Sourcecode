/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : FormDataBodyFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Body.MessageBodyFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.ByteBucket.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Body.FormDataBodyFilter inherits MessageBodyFilter: 
    define private variable mcTypes as character extent 1 no-undo
        initial ['application/x-www-form-urlencoded'].
    
    constructor public FormDataBodyFilter(input poMessage as HttpMessage):
		super(mcTypes, poMessage).
    end constructor.
    
    /** Replaces any existing object with JSON content. this is not an append. */
	method override public logical ExtractBody(input-output poEntity as Object):
	    /* No-op: data will be 'normal'. In fact, we should never get here. */
        return false.
	end method.
	
	/** Replaces the existing message body with the contents of the Entity */
	method override public logical InsertBody(input-output poMessageBody as ByteBucket):
	    define variable oIterator as IIterator no-undo.
	    define variable cDelimiter as character no-undo.
	    define variable oEntry as MapEntry no-undo.
	    
        if not valid-object(poMessageBody) then
            poMessageBody = ByteBucket:Instance().
        
        assign cDelimiter = ''
               oIterator = cast(this-object:Message:Entity, IStringStringMap):EntrySet:Iterator().
        do while oIterator:HasNext():
            oEntry = cast(oIterator:Next(), MapEntry).
                        
            poMessageBody:PutString(cDelimiter + substitute('&1=&2', oEntry:Key:ToString(), oEntry:Value:ToString())).
            
            assign cDelimiter = '&'.
        end.
        
        return true.
	end method.
	
end class.