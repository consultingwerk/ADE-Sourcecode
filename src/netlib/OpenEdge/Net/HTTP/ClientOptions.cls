/************************************************
Copyright (c) 2014-2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ClientOptions
    Purpose     : A set of options for the HttpClient
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 23 13:41:30 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

class OpenEdge.Net.HTTP.ClientOptions:
    /** How many retries of the same request should be attempted */
    define public property NumRetries as integer initial 10  no-undo get. set.
    
    /** The number of seconds (incl. fractions of seconds) between retries */
    define public property PauseBetweenRetry as decimal initial 0 no-undo get. set.
    
    /** Defines the maximum time a request must take */
    define public property RequestTimeout as decimal initial 0 no-undo get. set.
    
    /** Constructor. */
    constructor public ClientOptions():
    end constructor.
    
end class.