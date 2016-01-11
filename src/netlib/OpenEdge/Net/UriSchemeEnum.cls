/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : UriSchemeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:43:01 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.UriSchemeEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Net.UriSchemeEnum serializable inherits EnumMember:
    &global-define EnumMembers 
    
    {Consultingwerk/EnumMember.i http    0        UriSchemeEnum}
    {Consultingwerk/EnumMember.i https   1        UriSchemeEnum}
    {Consultingwerk/EnumMember.i file    2        UriSchemeEnum}
    {Consultingwerk/EnumMember.i ftp     3        UriSchemeEnum}
    
    constructor protected UriSchemeEnum( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    {Consultingwerk/EnumFromString.i OpenEdge.Net.UriSchemeEnum}
    
end class.