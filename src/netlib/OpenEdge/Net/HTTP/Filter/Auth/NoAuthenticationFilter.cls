 /************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : NoAuthenticationFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 07 13:30:12 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.Filter.Auth.AuthFilter.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.HttpMessage.

class OpenEdge.Net.HTTP.Filter.Auth.NoAuthenticationFilter inherits AuthFilter:
		
	constructor public NoAuthenticationFilter():
		super (input AuthenticationMethodEnum:None).
	end constructor.
	
    /** The worker/filter method that each filter type impements.       
        
        @param  HttpRequest The requeste being challenged/filtered
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK */ 
    method override public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage):
        /* Remove the header with the credentials (in case it already exists) */
        poMessage:RemoveHeader('Authorization').
        
        return FilterActionEnum:OK.
    end method.
	
end class.