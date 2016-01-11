/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : CookieJarDecorator
    Purpose     : Decorator class for decoracting/customising Http Clients
                  without requiring inheritance. This allows us to construct 
                  more complex clients (say with cookies, no proxy OR with cookies,
                  with proxy) without having to have individual types for all the 
                  combinations                  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 21 09:26:18 EST 2015
    Notes       : * There's a decent description of Decorator pattern in Wikipedia
                    at http://en.wikipedia.org/wiki/Decorator_pattern
                  * This class should be extended to provide specific functionality.
                    For instance, adding support for proxies, or cookies 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.HTTP.Cookie.

class OpenEdge.Net.HTTP.CookieJarDecorator abstract implements ICookieJar:
    
    /* the decorated client. this can be a decoration or an actual http client */
    define protected property DecoratedCookieJar as ICookieJar no-undo get. private set.

    /** The location in which cookies are persisted */
    define public property CookieJarPath as character no-undo
        get():
            return DecoratedCookieJar:CookieJarPath.
        end get.
        set(input pcCookieJarPath as character):
            DecoratedCookieJar:CookieJarPath = pcCookieJarPath.
        end set.

	constructor public CookieJarDecorator(input poCookieJar as ICookieJar):
	    Assert:NotNull(poCookieJar, 'Cookie Jar').

	    assign this-object:DecoratedCookieJar = poCookieJar.
    end constructor.
    
    /** Returns the cookies germane to the specified URI.
        @param URI The host/URI for which to return the cookies.
        @param Cookie[] Output array of the cookies 
        @return integer The number of cookies returned */
    method public integer GetCookies(input poUri as URI, output poCookies as Cookie extent).
        return DecoratedCookieJar:GetCookies(input poUri, output poCookies).
    end method.

    /** Adds a cookie to the jar.
        @param Cookie The cookie to add */
    method public void AddCookie(input poCookie as Cookie):
        Assert:NotNull(poCookie, 'Cookie').
        
        this-object:AddCookie(poCookie:Domain, poCookie:Path, poCookie).
    end method.
    
    /** Adds a cookie to the jar, for a given domain/path. This is
        required in cases where the 

        @param character The domain to which this cookie applies
        @param character The path to which this cookie applies
        @param Cookie The cookie to add */
    method public void AddCookie(input pcDomain as character,
                                 input pcPath   as character,
                                 input poCookie as Cookie).
        DecoratedCookieJar:AddCookie(pcDomain, pcPath, poCookie).
    end method.
    
    /** Removes a cookie from the jar.
        
        @param Cookie The cookie to remove 
        @return logical True if the cookie was deleted. */
    method public logical RemoveCookie(input poCookie as Cookie):
        return DecoratedCookieJar:RemoveCookie(poCookie).
    end method.
    
    /** Adds a collection of  cookies to the jar.
        @param Cookie The cookies to add */
    method public void AddCookies(input poCookies as Cookie extent):
        AddCookies(poCookies).
    end method.
    
    /** Removes all session (non-persistent) cookies from the jar */
    method public void ClearSessionCookies():
        DecoratedCookieJar:ClearSessionCookies().
    end method.
    
    /** Clears all persistent cookies */
    method public void ClearPersistentCookies():
        DecoratedCookieJar:ClearPersistentCookies().
    end method.

end class.