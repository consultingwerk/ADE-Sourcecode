/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : CookieJar
    Purpose     : Stores cookies temporarily and persistently
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 21 13:56:49 EDT 2014
    Notes       : * http://www.ietf.org/rfc/rfc6265.txt
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.CookieJar.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.HTTP.CookieCollection.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.CookieJar implements ICookieJar:
    define static private variable mcCookieJarPath as character no-undo.
    
    define private temp-table SessionCookie no-undo 
        /* denormalised from Cookie object */
        field CookieName as character
        field Domain as character
        field Path as character
        
        /* data */
        field WholeCookie as Object        
        /* cache info */
        field CreatedAt as datetime-tz
        field LastAccessedAt as datetime-tz
        
        index idx1 as primary unique 
            CookieName Domain Path
        .
                    
    define static private temp-table PersistentCookie no-undo
        like SessionCookie.
    
    method static public CookieJar Instance():
        define variable oCookieJar as CookieJar no-undo.
        
        oCookieJar = new CookieJar(). 
        oCookieJar:Initialize().
        
        return oCookieJar.
    end method.
    
    constructor static CookieJar():
        define buffer lbCookie for PersistentCookie.
        
        assign mcCookieJarPath = session:temp-dir + 'cookies.json'.
        
        /* reads any persistent cookies. NO-ERROR in case there are none */
        buffer lbCookie:read-json('file', mcCookieJarPath) no-error.
    end constructor.
    
    method public void Initialize():
        CookieJar:LoadPersistentCookies(this-object).
    end method.

    method public void Destroy():
        /* write out the persistent cookies when this cookie jar (effectively a
           session) closes. we could write the file every time we get a new 
           persistent cookie, but that adds potentially a lot of file I/O. 
           This way we can restrict the frequency of the IO. Since the 
           persistent cookies are static in the AVM session, this should 
           not be too much of a problem. */
        CookieJar:PersistCookieJar().
    end method.
    
    /** Returns a set of cookies for a given URI.
    
        Algorithm from finding relevant cookies derived from 
        https://tools.ietf.org/html/rfc6265#page-25 (section 5.4) 
        
        @param URI The URI/request for which cookies are required.
        @return CookieCollection The set of cookies matchin the URI criteria. */
    method public CookieCollection GetCookies(input poUri as URI):
        define variable oCookies as CookieCollection no-undo.
        define variable oCookie as Cookie no-undo.
        
        define buffer lbCookie for SessionCookie.
        
        oCookies = new CookieCollection().
        
        for each lbCookie where
                 lbCookie.Domain eq poUri:Host and
                 lbCookie.Path eq poUri:Path:
                     
            oCookie = cast(lbCookie.WholeCookie, Cookie).
            if oCookie:ExpiresAt lt now then
            do:
                delete lbCookie.
                next.    
            end.
            
            if oCookie:SecureOnly eq false and 
               poUri:Scheme:Equals(UriSchemeEnum:Https) then
                next.
                        
            if oCookie:HttpOnly and 
               not poUri:Scheme:Name begins 'http' then
                next.
            oCookies:Add(oCookie).                
        end.
        return oCookies.
    end method.
    
    method static private void AddPersistentCookie(input phSessionCookie as handle):
        define buffer lbCookie for PersistentCookie.
        
        find lbCookie where
             lbCookie.CookieName eq phSessionCookie::CookieName and 
             lbCookie.Domain eq phSessionCookie::Domain and
             lbCookie.Path eq phSessionCookie::Path
             no-error.
        if not available lbCookie then
            create lbCookie.
        
        buffer lbCookie:buffer-copy(phSessionCookie).
    end method.
    
    /** populates a cookie jar with persistent cookies  */
    method static private void LoadPersistentCookies(input poCookieJar as CookieJar):
        define variable oCookie as Cookie no-undo.
        
        define buffer lbCookie for PersistentCookie.
        
        for each lbCookie:
            oCookie = cast(lbCookie.WholeCookie, Cookie).
            if oCookie:ExpiresAt lt now then
            do:
                delete lbCookie.
                next.
            end.
            poCookieJar:AddCookie(oCookie).
        end.
    end method.
    
    method static private void LoadCookieJar():
        define variable oParser as ObjectModelParser no-undo.
        define variable oLoad as JsonObject no-undo.
        define variable oArray as JsonArray no-undo.
        define variable oCookie as JsonObject no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        define buffer lbCookie for PersistentCookie.
        
        CookieJar:ClearPersistentCookies().
        
        oParser = new ObjectModelParser().
        oLoad = cast(oParser:Parse(mcCookieJarPath), JsonObject).
        
        if oLoad:Has('cookies') then
            assign oArray = oLoad:GetJsonArray('cookies')
                   iMax = oArray:Length.
        do iLoop = 1 to iMax:
            assign oCookie = oArray:GetJsonObject(iLoop).
            create lbCookie.
            assign lbCookie.CookieName = oCookie:GetCharacter('CookieName')
                   lbCookie.Domain = oCookie:GetCharacter('Domain')
                   lbCookie.Path = oCookie:GetCharacter('Path')
                   lbCookie.CreatedAt = oCookie:GetDatetimeTZ('CreatedAt') 
                   lbCookie.LastAccessedAt  = oCookie:GetDatetimeTZ('LastAccessedAt')
                   lbCookie.WholeCookie = OpenEdge.Net.HTTP.Cookie:Parse(oCookie:GetCharacter('Cookie')).                   
        end.
    end method.
    
    method static private void PersistCookieJar():
        define variable oDump as JsonObject no-undo.
        define variable oArray as JsonArray no-undo.
        define variable oCookie as JsonObject no-undo.
        
        define buffer lbCookie for PersistentCookie.
        
        oDump = new JsonObject().
        oArray = new JsonArray().
        oDump:Add('cookies', oArray).
        
        for each lbCookie:
            oCookie = new JsonObject().
            oArray:Add(oCookie).
            
            oCookie:Add('CookieName', lbCookie.CookieName).
            oCookie:Add('Domain', lbCookie.Domain).
            oCookie:Add('Path', lbCookie.Path).
            oCookie:Add('Cookie', cast(lbCookie.WholeCookie, Cookie):ToString()).
            oCookie:Add('CreatedAt', lbCookie.CreatedAt).
            oCookie:Add('LastAccessedAt', lbCookie.LastAccessedAt).
        end.
        
        /* write cookie file. debug-alert param is for pretty formatting or not. */
        oDump:WriteFile(mcCookieJarPath, session:debug-alert).
    end method.
    
    method public void AddCookies(input poCookies as CookieCollection):
        define variable oIterator as IIterator no-undo.
        
        Assert:NotNull(poCookies, 'Cookies').
        
        assign oIterator = poCookies:Iterator().
        do while oIterator:HasNext():
            AddCookie(cast(oIterator:Next(), Cookie)).
        end.
    end method.
    
    /** Adds a cookie to the jar.
    
        @param character A cookie string as received from the HTTP response. */    
    method public void AddCookie(input poCookie as Cookie):
        define buffer lbCookie for SessionCookie.
        
        Assert:NotNull(poCookie, 'Cookie').
        
        /* A cookie with an empty domain is ignored/thrown away */
        if poCookie:Domain eq '' then
            return.
                    
        Assert:NotNullOrEmpty(poCookie:Name, 'Cookie name').
        Assert:NotNull(poCookie:Domain, 'Cookie domain').
        Assert:NotNull(poCookie:Path, 'Cookie path').
        
        find lbCookie where
             lbCookie.CookieName eq poCookie:Name and 
             lbCookie.Domain eq poCookie:Domain and
             lbCookie.Path eq poCookie:Path
             no-error.
        if not available lbCookie then
        do:
            create lbCookie.
            assign lbCookie.CookieName = poCookie:Name
                   lbCookie.Domain = poCookie:Domain
                   lbCookie.Path = poCookie:Path
                   lbCookie.CreatedAt = now.
        end.
        assign lbCookie.WholeCookie = poCookie.
        
        /* Persistent cookies */
        if poCookie:ExpiresAt ne ? and poCookie:MaxAge eq ? then
            CookieJar:AddPersistentCookie(buffer lbCookie:handle).                
    end method.
    
    method static public void ClearPersistentCookies():
        define buffer lbCookie for PersistentCookie.
        
        empty temp-table lbCookie.
        
        /* will write an empty file */
        CookieJar:PersistCookieJar().
    end method. 
            
    method public void ClearSessionCookies():
        define buffer lbCookie for SessionCookie.
        
        empty temp-table lbCookie.
    end method.
end class.