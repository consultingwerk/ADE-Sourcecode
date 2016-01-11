/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TransferEncodingEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 12:40:47 EST 2014
    Notes       : * Via http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Net.HTTP.TransferEncodingEnum inherits EnumMember:
    &global-define EnumMembers 
    
    {Consultingwerk/EnumMember.i None       0   TransferEncodingEnum}
    {Consultingwerk/EnumMember.i Chunked    1   TransferEncodingEnum}
    {Consultingwerk/EnumMember.i Identity   2   TransferEncodingEnum} 
    {Consultingwerk/EnumMember.i Gzip       3   TransferEncodingEnum}
    {Consultingwerk/EnumMember.i Compress   4   TransferEncodingEnum} 
    {Consultingwerk/EnumMember.i Deflate    5   TransferEncodingEnum}
    
	constructor protected TransferEncodingEnum ( input piValue as integer, input pcName as character ):
		super (input piValue, input pcName).
	end constructor.

    {Consultingwerk/EnumFromString.i OpenEdge.Net.HTTP.TransferEncodingEnum}
end class.
