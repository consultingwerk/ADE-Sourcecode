/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MethodEnum
    Purpose     : Generic HTTP methods. Based on W3C lib and HTTP spec.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Feb 11 09:18:45 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Net.HTTP.MethodEnum inherits EnumMember:
    /* define this preprocessor to get convert names to enums */
    &global-define EnumMembers
    
    {Consultingwerk/EnumMember.i INVALID   -1 MethodEnum}
    {Consultingwerk/EnumMember.i GET       0  MethodEnum}
    
    {Consultingwerk/EnumMember.i HEAD      1  MethodEnum}
    {Consultingwerk/EnumMember.i POST      2  MethodEnum}
    {Consultingwerk/EnumMember.i PUT       3  MethodEnum}
    {Consultingwerk/EnumMember.i PATCH     4  MethodEnum}
    {Consultingwerk/EnumMember.i DELETE    5  MethodEnum}
    {Consultingwerk/EnumMember.i TRACE     6  MethodEnum}
    {Consultingwerk/EnumMember.i OPTIONS   7  MethodEnum}
    {Consultingwerk/EnumMember.i LINK      8  MethodEnum}

    /* WebDAV Methods */
    {Consultingwerk/EnumMember.i LOCK      10 MethodEnum}
    {Consultingwerk/EnumMember.i UNLOCK    11 MethodEnum}

    {Consultingwerk/EnumMember.i PROPFIND  12 MethodEnum}
    {Consultingwerk/EnumMember.i PROPPATCH 13 MethodEnum}
    {Consultingwerk/EnumMember.i MKCOL     14 MethodEnum}
    {Consultingwerk/EnumMember.i COPY      15 MethodEnum}
    {Consultingwerk/EnumMember.i MOVE      16 MethodEnum}

    /* Extension methods */
    {Consultingwerk/EnumMember.i EXT_0     17 MethodEnum}
    {Consultingwerk/EnumMember.i EXT_1     18 MethodEnum}
    {Consultingwerk/EnumMember.i EXT_2     19 MethodEnum}
    {Consultingwerk/EnumMember.i EXT_3     20 MethodEnum}
    {Consultingwerk/EnumMember.i EXT_4     21 MethodEnum}
    {Consultingwerk/EnumMember.i EXT_5     22 MethodEnum}
    {Consultingwerk/EnumMember.i EXT_6     23 MethodEnum}

    {Consultingwerk/EnumMember.i UNLINK    9  MethodEnum}

    constructor protected MethodEnum(input piValue as integer, input pcName as character):
        super (input piValue, input pcName).
    end constructor.
    
    {Consultingwerk/EnumFromString.i OpenEdge.Net.HTTP.MethodEnum}
    
end class.