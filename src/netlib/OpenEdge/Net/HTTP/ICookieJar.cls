/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.CookieCollection.
using OpenEdge.Net.URI.

interface OpenEdge.Net.HTTP.ICookieJar:
    /* Initializer/Startup */
    method public void Initialize().
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy().
    
    /** Returns the cookies germane to the specified URI.
        @param URI The host/URI for which to return the cookies.
        @return CookieCollection A collection of cookies. */
    method public CookieCollection GetCookies(input poUri as URI).
    
    /** Adds a cookie to the jar.
        @param Cookie The cookie to add */
    method public void AddCookie(input poCookie as Cookie).
    
    /** Adds a collection of  cookies to the jar.
        @param CookieCollection The cookies to add */
    method public void AddCookies(input poCookies as CookieCollection).
    
    /** Removes all session (non-persistent) cookies from the jar */
    method public void ClearSessionCookies().
    
end interface.