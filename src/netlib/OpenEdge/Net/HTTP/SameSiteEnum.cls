/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : SameSiteEnum
    Purpose     : Hold the values for the SameSite cookie attribute
    Description : 
    Author(s)   : Dustin Grau
    Created     : Thu Nov 11 13:55:03 EST 2021
    Notes       : 

    https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
    https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Net.HTTP.SameSiteEnum:

    define enum Lax     // Cookies are not sent on normal cross-site subrequests, but are sent when a user is navigating to the origin site.
                None    // Cookies will be sent in all contexts; if set, the cookie Secure attribute must also be set (or the cookie will be blocked).
                Strict  // Cookies will only be sent in a first-party context and not be sent along with requests initiated by third party websites.
                Default = Lax // This is the default cookie value if SameSite has not been explicitly specified in recent browser versions.
                .

end enum.