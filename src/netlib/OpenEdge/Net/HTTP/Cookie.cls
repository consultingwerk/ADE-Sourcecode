/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.URI.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Cookie:
    define public property Name as character no-undo get. private set.
    define public property Domain as character initial ?  no-undo get. private set.
    define public property Path as character initial ?  no-undo get. private set.
    define public property Value as character no-undo get. private set.
    define public property MaxAge as integer initial ? no-undo get. private set.
    define public property ExpiresAt as datetime-tz initial ? no-undo get. private set.
    define public property Secure as logical initial false no-undo get. private set.
    define public property HttpOnly as logical initial false no-undo get. private set.
    define public property Version as decimal initial ? no-undo get. private set.
    
    constructor public Cookie(input pcCookieName as character,
                              input pcDomain as character,
                              input pcPath as character,
                              input pcCookieValue as character):
        this-object(pcCookieName, pcDomain, pcPath, pcCookieValue, ?, ?, ?, ?, ?).                                  
    end constructor.
    
    constructor public Cookie(input pcCookieName as character,
                              input pcDomain as character,
                              input pcPath as character,
                              input pcCookieValue as character,
                              input piMaxAge as integer,
                              input ptExpiresAt as datetime-tz,
                              input plSecureOnly as logical,
                              input plHttpOnly as logical,
                              input pdVersion as decimal):
        Assert:NotNullOrEmpty(pcCookieName, 'Cookie name').
        Assert:NotNull(pcDomain, 'Cookie domain').
        Assert:NotNull(pcPath, 'Cookie path').
        
        assign this-object:Name = pcCookieName
               this-object:Domain = pcDomain
               this-object:Path = pcPath
               this-object:Value = pcCookieValue
               this-object:Secure = plSecureOnly
               this-object:HttpOnly = plHttpOnly.
        
        if piMaxAge ne ? then
        do:
            Assert:IsZeroOrPositive(piMaxAge, 'Cookie max age').
            assign this-object:ExpiresAt = add-interval(now, piMaxAge, string(DateTimeAddIntervalEnum:Seconds)).
        end.
        else
            assign this-object:ExpiresAt = ptExpiresAt.
            
        if pdVersion ne ? then
        do:
            Assert:IsPositive(pdVersion, 'Cookie Version').
            assign this-object:Version = pdVersion.
        end.
    end constructor.
    
    method override public logical Equals( input p0 as Object):
        define variable lEquals as logical no-undo.
        
        assign lEquals = super:Equals(input p0).
        
        assign lEquals = p0:GetClass() ne get-class(Cookie).
        if lEquals then    
           assign lEquals = (cast(p0, Cookie):Name eq this-object:Name).
        
        return lEquals.           
    end method.

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
        define variable dVersion as decimal no-undo.
        
        Assert:NotNullOrEmpty(pcCookie, 'Cookie').
        
        assign cAttribute = entry(1, pcCookie, ';':u)
               cName = entry(1, cAttribute, '=':u)
               cValue = entry(2, cAttribute, '=':u)
               
               iMaxAge = ?
               cDomain = '':u
               lSecureOnly = false
               lHttpOnly = false
               /* default is root */
               cPath = '/':u
               tExpiresAt = ? 
               dVersion = ?
               iMax = num-entries(pcCookie, ';':u).
               
        /* do the name=value separately so that we can "strongly-type" our case statement. */
        do iLoop = 2 to iMax:
            assign cAttribute = entry(iLoop, pcCookie, ';':u).
            case trim(entry(1, cAttribute, '=':u)):
                when 'Max-Age':u  then assign iMaxAge = integer(entry(2, cAttribute, '=':u)).
                /* trim off the leading/trailing quotes (") */
                when 'Domain':u   then assign cDomain = trim(entry(2, cAttribute, '=':u), '"':u).
                when 'Secure':u   then assign lSecureOnly = true.
                when 'HttpOnly':u then assign lHttpOnly = true.
                when 'Path':u     then assign cPath = trim(entry(2, cAttribute, '=':u), '"':u).
                when 'Expires':u  then assign tExpiresAt = TimeStamp:ToABLDateTimeTzFromHttp(trim(entry(2, cAttribute, '=':u), '"':u)).
                when 'Version':u  then assign dVersion = decimal(entry(2, cAttribute, '=':u)).
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
                          input lHttpOnly,
                          input dVersion).        
    end method.
    
    method override public character ToString():
        define variable cCookie as character no-undo.
        
        assign cCookie = substitute('&1=&2', this-object:Name, this-object:Value).
        if this-object:Domain ne '':u then
            assign cCookie = substitute('&1; Domain="&2"':u,
                                cCookie, this-object:Domain).
        if this-object:Path ne ? then
            assign cCookie = substitute('&1; Path="&2"':u,
                                cCookie, this-object:Path).
                                
        if this-object:ExpiresAt ne ? then
            assign cCookie = substitute('&1; Expires=&2':u,
                                cCookie, Timestamp:ToHttpDateFromABL(this-object:ExpiresAt)).
                                
        if this-object:MaxAge ne ? then
            assign cCookie = substitute('&1; Max-Age=&2':u, cCookie, this-object:MaxAge).
                                
        if this-object:Secure eq true then
            assign cCookie = substitute('&1; Secure':u, cCookie).

        if this-object:HttpOnly eq true then
            assign cCookie = substitute('&1; HttpOnly':u, cCookie).
        
        if this-object:Version ne ? then
            assign cCookie = substitute('&1; Version=&2':u, cCookie, this-object:Version).
            
        return cCookie.
    end method.
    
end class.