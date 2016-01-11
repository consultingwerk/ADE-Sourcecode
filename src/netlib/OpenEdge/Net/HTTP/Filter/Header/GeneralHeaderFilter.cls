/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : GeneralHeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:47:30 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Header.HeaderFilter.
using OpenEdge.Net.HTTP.HttpMessage.

class OpenEdge.Net.HTTP.Filter.Header.GeneralHeaderFilter inherits HeaderFilter:
	constructor public GeneralHeaderFilter (input poMessage as HttpMessage):
		super (input '*', input poMessage).
	end constructor.
	
	method override public logical AddHeader( input pcName as character, input pcValue as character):
	    this-object:Message:SetHeaderEntry(pcName, pcValue).
	    
	    return false.
	end method.
	
	method override public logical RemoveHeader(input pcName as character):
        this-object:Message:RemoveHeaderEntry(pcName).
        
        return false.
	end method.
	
end class.