/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AuthenticationMethodEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 07 13:39:27 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Net.HTTP.AuthenticationMethodEnum inherits EnumMember: 
    &global-define EnumMembers 
    
    {Consultingwerk/EnumMember.i None    0        AuthenticationMethodEnum}
    {Consultingwerk/EnumMember.i Basic   1        AuthenticationMethodEnum}
    {Consultingwerk/EnumMember.i Digest  2        AuthenticationMethodEnum}
    {Consultingwerk/EnumMember.i Form    3        AuthenticationMethodEnum}
    
    constructor protected AuthenticationMethodEnum( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    {Consultingwerk/EnumFromString.i OpenEdge.Net.HTTP.AuthenticationMethodEnum}
    
end class.