/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ClientOptions
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 23 13:41:30 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

class OpenEdge.Net.HTTP.ClientOptions:
    
    define public property NumRetries as integer initial 0  no-undo get. set.
    define public property PauseBetweenRetry as integer initial 0 no-undo get. set.
    define public property RequestTimeout as integer initial 0 no-undo get. set.

end class.