/*------------------------------------------------------------------------
    File        : ISupportCookies
    Purpose     : Indicates that a client supports cookies (is stateful) 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jan 30 13:11:11 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Net.HTTP.ICookieJar.

interface OpenEdge.Net.HTTP.ISupportCookies:    
    /** The cookie storage */
    define public property CookieJar as ICookieJar no-undo get. set.
    
end interface.