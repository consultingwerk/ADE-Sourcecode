/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ICookieJar
    Purpose     : Interface describing the manager of HTTP Cookies 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 21 15:19:57 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.URI.

interface OpenEdge.Net.HTTP.ICookieJar:
    /** The location in which cookies are persisted */
    define public property CookieJarPath as character no-undo get. set.
    
    /** Returns the cookies germane to the specified URI.
        @param URI The host/URI for which to return the cookies.
        @param Cookie[] Output array of the cookies 
        @return integer The number of cookies returned */
    method public integer GetCookies(input poUri as URI, output poCookies as Cookie extent).
    
    /** Adds a cookie to the jar.
        @param Cookie The cookie to add */
    method public void AddCookie(input poCookie as Cookie).

    /** Adds a cookie to the jar, for a given domain/path. This is
        required in cases where the 

        @param character The domain to which this cookie applies
        @param character The path to which this cookie applies
        @param Cookie The cookie to add */
    method public void AddCookie(input pcDomain as character,
                                 input pcPath   as character,
                                 input poCookie as Cookie).

    /** Removes a cookie from the jar.
        
        @param Cookie The cookie to remove 
        @return logical True if the cookie was deleted. */
    method public logical RemoveCookie(input poCookie as Cookie).
    
    /** Adds a collection of  cookies to the jar.
        @param Cookie The cookies to add */
    method public void AddCookies(input poCookies as Cookie extent).
    
    /** Removes all session (non-persistent) cookies from the jar */
    method public void ClearSessionCookies().
    
    /** Clears all persistent cookies */
    method public void ClearPersistentCookies().
    
end interface.