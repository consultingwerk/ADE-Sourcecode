/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
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
    {Consultingwerk/EnumMember.i Other   4        AuthenticationMethodEnum}
    
    constructor protected AuthenticationMethodEnum( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    method public static AuthenticationMethodEnum FromString (input pcMemberName as character):
        define variable iEntry as integer no-undo.
        assign iEntry = lookup(pcMemberName, '{&EnumMembers}':u) .
        
        /* If it's no none, or a standard http method, then it's always 'other' */
        if iEntry eq 0 then
            assign iEntry = lookup(AuthenticationMethodEnum:Other:Name, '{&EnumMembers}':u) .
        
        OpenEdge.Core.Assert:IsPositive(iEntry, 'entry').
        
        return get-class(AuthenticationMethodEnum):GetPropertyValue(pcMemberName) .
        
        /* Error handling, when invalid member name was passed in */
        catch err as Progress.Lang.Error:
            return ?.
        end catch.
    end method .
    
end class.