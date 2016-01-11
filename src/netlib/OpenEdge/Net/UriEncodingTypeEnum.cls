/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : UrlEncodingTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jun 03 17:01:20 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EnumMember.
using OpenEdge.Net.UriEncodingTypeEnum.

class OpenEdge.Net.UriEncodingTypeEnum serializable inherits EnumMember: 
    &global-define EnumMembers 
    
    {Consultingwerk/EnumMember.i Default    0        UriEncodingTypeEnum}
    {Consultingwerk/EnumMember.i Query      1        UriEncodingTypeEnum}
    {Consultingwerk/EnumMember.i Cookie     2        UriEncodingTypeEnum}
    
    constructor protected UriEncodingTypeEnum( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    {Consultingwerk/EnumFromString.i OpenEdge.Net.UriEncodingTypeEnum}

end class.