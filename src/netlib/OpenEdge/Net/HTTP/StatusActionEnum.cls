/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/** ------------------------------------------------------------------------
    File        : StatusActionEnum
    Purpose     : Actions resulting from the evaluation of a response's status
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 23 14:16:12 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EnumMember.
using OpenEdge.Net.HTTP.StatusActionEnum.

class OpenEdge.Net.HTTP.StatusActionEnum inherits EnumMember:
    /* everything ok */    
    {Consultingwerk/EnumMember.i OK     0 StatusActionEnum}
    /* fail with an error thrown */
    {Consultingwerk/EnumMember.i Error  1 StatusActionEnum}
    /* retry the request */
    {Consultingwerk/EnumMember.i Retry  2 StatusActionEnum}
    /* abort/fail silently */
    {Consultingwerk/EnumMember.i Abort  3 StatusActionEnum}
    
    constructor protected StatusActionEnum( input piValue as integer, input pcName as character):
        super (input piValue, input pcName).
    end constructor.
end class.