/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ISupportsProxy
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 28 21:07:54 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Net.URI.

interface OpenEdge.Net.HTTP.ISupportProxy:  

    /** The URI to use as a proxy for this request eg. http://proxy.example.com/ */
    define public property ProxyURI as URI no-undo get. set.

end interface.