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

using OpenEdge.Core.EnumMember.
using OpenEdge.Net.HTTP.TransferEncodingEnum.

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

    method public static TransferEncodingEnum FromString (input pcMemberName as character):
        define variable iEntry as integer no-undo.
        
        /* Http spec says that x-gzip and otehrs are equivalent to gzip and others */
        if pcMemberName begins 'X-':u then
            assign pcMemberName = entry(2, pcMemberName, '-':u).
        
        assign iEntry = lookup(pcMemberName, '{&EnumMembers}':u) .
        
        OpenEdge.Core.Assert:IsPositive(iEntry, 'entry').
        
        return get-class(TransferEncodingEnum):GetPropertyValue(pcMemberName) .
        
        /* Error handling, when invalid member name was passed in */
        catch err as Progress.Lang.Error:
            return ? .  
        end catch.
    end method .
    
end class.
