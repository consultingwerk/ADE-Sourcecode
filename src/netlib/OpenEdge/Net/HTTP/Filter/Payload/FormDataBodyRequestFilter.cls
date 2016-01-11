/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : FormDataBodyRequestFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Core.Assert.

class OpenEdge.Net.HTTP.Filter.Payload.FormDataBodyRequestFilter inherits DefaultRequestFilter: 
		
	constructor public FormDataBodyRequestFilter(input poMessage as IHttpRequest):
		super (input poMessage).
	end constructor.
	
	method override protected ByteBucket ExtractEntity():
        define variable oIterator as IIterator no-undo.
        define variable cDelimiter as character no-undo.
        define variable oEntry as MapEntry no-undo.
        define variable oBody as ByteBucket no-undo.
        
        Assert:IsType(this-object:Message:Entity, get-class(IStringStringMap)).

        assign cDelimiter = '':u
               oIterator = cast(this-object:Message:Entity, IStringStringMap):EntrySet:Iterator()
               oBody = ByteBucket:Instance().

        do while oIterator:HasNext():
            assign oEntry = cast(oIterator:Next(), MapEntry).
            oBody:PutString(cDelimiter + substitute('&1=&2':u, oEntry:Key:ToString(), oEntry:Value:ToString())).
            assign cDelimiter = '&':u.
        end.
        
        return oBody.
	end method.

end class.