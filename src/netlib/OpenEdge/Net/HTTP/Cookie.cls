/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : Cookie
    Purpose     : HTTP Cookie class
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 22 13:17:03 EDT 2014
    Notes       : * W3C spec at https://tools.ietf.org/html/rfc6265
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.TimeStamp.
using OpenEdge.Net.HTTP.Cookie.

class OpenEdge.Net.HTTP.Cookie:
    define public property Name as character no-undo get. private set.
    define public property Domain as character initial ?  no-undo get. private set.
    define public property Path as character initial ?  no-undo get. private set.
    define public property Value as character no-undo get. private set.
    define public property MaxAge as integer initial ? no-undo get. private set.
    define public property ExpiresAt as datetime-tz initial ? no-undo get. private set.
    define public property SecureOnly as logical initial false no-undo get. private set.
    define public property HttpOnly as logical initial false no-undo get. private set.
    
    constructor public Cookie(input pcCookieName as character,
                              input pcDomain as character,
                              input pcPath as character,
                              input pcCookieValue as character):
        this-object(pcCookieName, pcDomain, pcPath, pcCookieValue, ?, ?, ?, ?).                                  
    end constructor.
    
    constructor public Cookie(input pcCookieName as character,
                              input pcDomain as character,
                              input pcPath as character,
                              input pcCookieValue as character,
                              input piMaxAge as integer,
                              input ptExpiresAt as datetime-tz,
                              input plSecureOnly as logical,
                              input plHttpOnly as logical):
        Assert:NotNullOrEmpty(pcCookieName, 'Cookie name').
        
        assign this-object:Name = pcCookieName
               this-object:Domain = pcDomain
               this-object:Path = pcPath
               this-object:Value = pcCookieValue
               this-object:SecureOnly = plSecureOnly
               this-object:HttpOnly = plHttpOnly.
        
        if piMaxAge ne ? then
            assign this-object:ExpiresAt = add-interval(now, piMaxAge, 'seconds').
        else
            assign this-object:ExpiresAt = ptExpiresAt.
    end constructor.
    
    /** Creates a Cookie object from the string representation of a cookie.
    
        @param character The cookie in string form, typically from a HTTP
                         response header.
        @return Cookie The Cookie object corresponding to that string.  */
    method static public Cookie Parse(input pcCookie as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        define variable cAttribute as character no-undo.
        define variable cPath as character no-undo.
        define variable iMaxAge as integer no-undo.
        define variable cDomain as character no-undo.
        define variable lSecureOnly as logical no-undo.
        define variable lHttpOnly as logical no-undo.
        define variable tExpiresAt as datetime-tz no-undo.
        
        Assert:NotNullOrEmpty(pcCookie, 'Cookie').
        
        assign cName = entry(1, pcCookie, '=')
               cValue = entry(2, pcCookie, '=')
               iMaxAge = ?
               cDomain = ''
               lSecureOnly = false
               lHttpOnly = false
               cPath = ''
               tExpiresAt = ? 
               iMax = num-entries(cValue, ';').
               
        do iLoop = 1 to iMax:
            assign cAttribute = entry(iLoop, cValue, ';').
            
            case entry(1, cAttribute, '='):
                when 'Max-Age'  then assign iMaxAge = integer(entry(2, cAttribute, '=')).
                when 'Domain'   then assign cDomain = entry(2, cAttribute, '=').
                when 'Secure'   then assign lSecureOnly = true.
                when 'HttpOnly' then assign lHttpOnly = true.
                when 'Path'     then assign cPath = entry(2, cAttribute, '=').
                when 'Expires'  then assign tExpiresAt = TimeStamp:ToABLDateTimeTzFromHttp(entry(2, cAttribute, '=')).
            end case.            
        end.
        
        Assert:NotNullOrEmpty(cName, 'Cookie name').
        Assert:NotNull(cDomain, 'Cookie domain').
        Assert:NotNull(cPath, 'Cookie path').
        
        return new Cookie(input cName,
                          input cDomain,
                          input cPath,
                          input cValue,
                          input iMaxAge,
                          input tExpiresAt,
                          input lSecureOnly,
                          input lHttpOnly).        
    end method.
    
    method override public character ToString():
        define variable cCookie as character no-undo.
        
        assign cCookie = substitute('&1=&2; Domain=&3',
                            this-object:Name,
                            this-object:Value,
                            this-object:Domain).
        if this-object:Path ne ? then
            assign cCookie = substitute('&1; Path=&2',
                                cCookie, this-object:Path).
        if this-object:MaxAge eq ? then
            assign cCookie = substitute('&1; Expires=&2',
                                cCookie, Timestamp:ToHttpDateFromABL(this-object:ExpiresAt)).
        else
            assign cCookie = substitute('&1; MaxAge=&2',
                                cCookie, this-object:MaxAge).
                                
        if this-object:SecureOnly eq true then
            assign cCookie = substitute('&1; Secure', cCookie).

        if this-object:HttpOnly eq true then
            assign cCookie = substitute('&1; HttpOnly', cCookie).
        
        return cCookie.
    end method.
    
    /* 5.1.3.  Domain Matching
           A string domain-matches a given domain string if at least one of the
           following conditions hold:
        
           o  The domain string and the string are identical.  (Note that both
              the domain string and the string will have been canonicalized to
              lower case at this point.)
        
           o  All of the following conditions hold:
        
              *  The domain string is a suffix of the string.
        
              *  The last character of the string that is not included in the
                 domain string is a %x2E (".") character.
        
              *  The string is a host name (i.e., not an IP address). */    
    method public logical DomainMatches(input pcHost as character):
        define variable lMatches as logical no-undo.
        
        Assert:NotNullOrEmpty(pcHost, 'Host').
        
        if this-object:Domain eq '' then
            return false.        

        if this-object:Domain eq pcHost then
            return true.
        
        /* TODO: more complete implementation */
        return lMatches.
    end method.

end class.