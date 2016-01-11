 /************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
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

using OpenEdge.Net.HTTP.Filter.Auth.AuthenticationRequestFilter.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.

class OpenEdge.Net.HTTP.Filter.Auth.NoAuthenticationFilter inherits AuthenticationRequestFilter: 
    constructor public NoAuthenticationFilter ( input poRequest as IAuthenticatedRequest ):
        super (input poRequest).
    end constructor.

    /** Build the actual authentication. To be implemented by concrete classes. */
    method override protected void AddAuthentication():
        this-object:Message:RemoveHeader('Authorization':u).
    end method.
            
end class.