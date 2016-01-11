/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/** ------------------------------------------------------------------------
    File        : FilterActionEnum
    Purpose     : Actions resulting from the evaluation of a response's status
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 23 14:16:12 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EnumMember.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.

class OpenEdge.Net.HTTP.Filter.FilterActionEnum inherits EnumMember:
    /* everything ok */    
    {Consultingwerk/EnumMember.i OK         0 FilterActionEnum}
    /* fail with an error thrown */
    {Consultingwerk/EnumMember.i Error      1 FilterActionEnum}
    /* retry the request */
    {Consultingwerk/EnumMember.i Retry      2 FilterActionEnum}
    /* abort/fail silently */
    {Consultingwerk/EnumMember.i Abort      3 FilterActionEnum}
    /* stop processing */
    {Consultingwerk/EnumMember.i Stop       4 FilterActionEnum}
    /* continue processing */
    {Consultingwerk/EnumMember.i Continue   5 FilterActionEnum}
    
    
    constructor protected FilterActionEnum( input piValue as integer, input pcName as character):
        super (input piValue, input pcName).
    end constructor.
end class.