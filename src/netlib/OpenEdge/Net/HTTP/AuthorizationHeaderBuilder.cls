/************************************************
Copyright (c) 2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : AuthorizationHeaderBuilder
    Purpose     : Bulider to create Authorization header objects
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-12-06
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.DefaultHeaderBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.AuthorizationHeader.
using OpenEdge.Core.StringConstant.

class OpenEdge.Net.HTTP.AuthorizationHeaderBuilder inherits DefaultHeaderBuilder: 
    /* Constructor
       
       @param character The name of the header to  which this builder applies */
    constructor public AuthorizationHeaderBuilder (input pHeaderName as character):
        super(pHeaderName).
        
        ParametersDelimitedBy(StringConstant:SPACE).
        SetOption(get-class(HttpHeader):TypeName, get-class(AuthorizationHeader)).
    end constructor.
    
end class.