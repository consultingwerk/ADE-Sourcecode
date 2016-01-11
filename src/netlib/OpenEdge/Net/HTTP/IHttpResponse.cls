/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : IHttpResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 22 15:47:26 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.StatusCodeEnum.

interface OpenEdge.Net.HTTP.IHttpResponse inherits IHttpMessage:  
    
    /** The status of the HTTP response. Section 6.1 */
    define public property StatusCode as integer no-undo get. set.
    
    /** The status reason of the HTTP response. Section 6.1 */
    define public property StatusReason as character no-undo get. set.
    
end interface.