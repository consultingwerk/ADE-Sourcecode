/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : IHttpRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 22 15:43:51 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.URI.

interface OpenEdge.Net.HTTP.IHttpRequest inherits IHttpMessage:

    /** (mandatory) GET/PUT/POST etc, Maps to MethodEnum, although there are extension methods too */
    define public property Method as character no-undo get. set.
    
    /** (mandatory) The URI to request eg. http://progress.com/ */
    define public property URI as URI no-undo get.  set.

end interface.