/************************************************
Copyright (c)  2014-2016, 2018-2019 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.CookieCollection.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.CookieJar.

class OpenEdge.Net.HTTP.CookieJar use-widget-pool 
            implements ICookieJar, ISupportInitialize, ISupportLogging:
    
    /* Top-level domains. 
        
       From https://support.google.com/webmasters/answer/1347922?hl=en */
    define private variable mcGenericTLDs as character no-undo
        initial 'aero,asia,biz,cat,com,coop,edu,eu,gov,info,int,jobs,mil,mobi,museum,name,net,org,pro,tel,travel':u.
    define private variable mcGenericCountryTLDs as character no-undo
        initial 'ad,as,bz,cc,cd,co,dj,fm,io,la,me,ms,nu,sc,sr,su,tv,tk,ws':U.
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.
    
    /** The location in which the cookies are persisted */
    define public property CookieJarPath as character no-undo get. set.
    
    /* data store for session/temporary cookies */
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
    
    /* data store for persistent cookies */
    define static private temp-table PersistentCookie no-undo
        like SessionCookie.
        
    /* static constructor */    
    constructor static CookieJar():
    end constructor.
    
    /* Default constructor */
    constructor public CookieJar():
        assign this-object:Logger        = LoggerBuilder:GetLogger(get-class(CookieJar))
               // Set the path in the constructor, so that it can be potentially overridden before initialize() is called
               this-object:CookieJarPath = session:temp-dir + 'cookies.json':u
               .
    end constructor.
    
    destructor CookieJar():
        Destroy().
    end destructor.
    
    /* Initializer/Startup */
    method public void Initialize():
        CookieJar:LoadCookieJar(this-object:CookieJarPath).
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        /* write out the persistent cookies when this cookie jar (effectively a
           session) closes. we could write the file every time we get a new 
           persistent cookie, but that adds potentially a lot of file I/O. 
           This way we can restrict the frequency of the IO. Since the 
           persistent cookies are static in the AVM session, this should 
           not be too much of a problem. */
        CookieJar:PersistCookieJar(this-object:CookieJarPath).
    end method.
    
    /** Returns a set of cookies for a given URI.
    
        Algorithm from finding relevant cookies derived from 
        https://tools.ietf.org/html/rfc6265#page-25 (section 5.4) 
        
        @param URI The host/URI for which to return the cookies.
        @param Cookie[] Output array of the cookies 
        @return integer The number of cookies returned */
    method public integer GetCookies(input poUri as URI, output poCookies as Cookie extent).
        define variable oCookies as CookieCollection no-undo.
        define variable oCookie as Cookie no-undo.
        define variable cPath as character no-undo.
        
        define buffer lbSession for SessionCookie.
        define buffer lbPersistent for PersistentCookie.

        assign oCookies = new CookieCollection()
               cPath = poURI:Path.
        if cPath eq '':u then
            assign cPath = '/':u.
        
        /* http://curl.haxx.se/rfc/cookie_spec.html
        
            When searching the cookie list for valid cookies, a comparison of the domain attributes of 
            the cookie is made with the Internet domain name of the host from which the URL will be 
            fetched. If there is a tail match, then the cookie will go through path matching to see if 
            it should be sent. "Tail matching" means that domain attribute is matched against the tail 
            of the fully qualified domain name of the host. A domain attribute of "acme.com" would 
            match host names "anvil.acme.com" as well as "shipping.crate.acme.com".
    
            Only hosts within the specified domain can set a cookie for a domain and domains must have 
            at least two (2) or three (3) periods in them to prevent domains of the form: ".com", 
            ".edu", and "va.us". Any domain that fails within one of the seven special top level 
            domains listed below only require two periods. Any other domain requires at least three. 
            
            The default value of domain is the host name of the server which generated the cookie 
            response.       
            
            The path attribute is used to specify the subset of URLs in a domain for which the 
            cookie is valid. If a cookie has already passed domain matching, then the pathname 
            component of the URL is compared with the path attribute, and if there is a match, the 
            cookie is considered valid and is sent along with the URL request. The path "/foo" 
            would match "/foobar" and "/foo/bar.html". The path "/" is the most general path.
    
            If the path is not specified, it as assumed to be the same path as the document being 
            described by the header which contains the cookie.  */
        
        for each lbSession where
                 ( poURI:Host matches ('*~.':u + lbSession.Domain) or
                   lbSession.Domain eq poURI:Host                    ) and
                 poURI:Path begins lbSession.Path   :
            
            /* exclude fuzzy matches when the cookie's domain does not have a leading . */
            if not lbSession.Domain begins '.':u and
               lbSession.Domain ne poURI:Host then
                next.
                             
            assign oCookie = cast(lbSession.WholeCookie, Cookie).
            case CheckCookie(poUri, oCookie):
                when  1 then oCookies:Add(oCookie).
                when -1 then delete lbSession.
                when  0 then next.
            end case.
        end.
        
        for each lbPersistent where
                 ( poURI:Host matches ('*~.':u + lbPersistent.Domain) or
                   lbPersistent.Domain eq poURI:Host                    ) and
                 poURI:Path begins lbPersistent.Path   :
            
            /* exclude fuzzy matches when the cookie's domain does not have a leading . */
            if not lbPersistent.Domain begins '.':u and
               lbPersistent.Domain ne poURI:Host then
                next.
                
            assign oCookie = cast(lbPersistent.WholeCookie, Cookie).
            case CheckCookie(poUri, oCookie):
                when  1 then oCookies:Add(oCookie).
                when -1 then delete lbPersistent.
                when  0 then next.
            end case.
        end.
        
        assign poCookies = oCookies:ToCookieArray(). 
        return oCookies:Size.
    end method.
    
    /** Checks whether a cookie is valid for a URI
        
        @param URI The uri for which to retrieve cookies
        @param Cookie The cookie to check
        @return integer  1: cookie matches URI
                         0: cookie does not match URI
                        -1: cookie matches URI and has expired */        
    method private integer CheckCookie (input poURI as URI,
                                        input poCookie as Cookie):
        if poCookie:ExpiresAt lt now then
            return -1.
                            
        if poCookie:HttpOnly and 
           not poUri:Scheme eq string(UriSchemeEnum:http)  and
           not poUri:Scheme eq string(UriSchemeEnum:https) then
            return 0.
        
        if poCookie:Secure and
           not poUri:Scheme eq string(UriSchemeEnum:https) then
            return 0.           
        
        return 1.
    end method.

    /** Removes a persistent cookie that corresponds to a session cookie.
        
        @param handle The buffer handle for the temp-table store
        @param Cookie The cookie to add into the store. 
        @return logical True if the cookie was deleted from the store. */
    method private logical DeleteCookie(input phStore as handle,
                                        input poCookie as Cookie):
        phStore:find-unique(substitute('where &1.CookieName eq "&2" and &1.Domain eq "&3" and &1.Path eq "&4"':u,
                        phStore:name,
                        poCookie:Name,
                        poCookie:Domain,
                        poCookie:Path)) no-error.
        // for not available records
        assign error-status:error = false.
        if phStore:available then
        do:
            phStore:buffer-delete().
            phStore:buffer-release().
            
            return true.
        end.
        
        return false.
    end method.
    
    /** Loads the cookie jar with persisted cookies, from disk. 
        
        @param character The JOSN file in which the cookies are persisted. */
    method static private void LoadCookieJar(input pcCookieJarPath as character):
        define variable oParser as ObjectModelParser no-undo.
        define variable oLoad as JsonObject no-undo.
        define variable oArray as JsonArray no-undo.
        define variable oCookie as JsonObject no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable cookieName as character no-undo.
        define variable domain as character no-undo.
        define variable path as character no-undo.
        
        define buffer lbCookie for PersistentCookie.
        
        assign file-info:file-name = pcCookieJarPath.
        if file-info:full-pathname eq ? then
            return.
        
        oParser = new ObjectModelParser().
        oLoad = cast(oParser:ParseFile(pcCookieJarPath), JsonObject).
        
        if oLoad:Has('cookies':u) then
            assign oArray = oLoad:GetJsonArray('cookies':u)
                   iMax   = oArray:Length.
        do iLoop = 1 to iMax:
            assign oCookie    = oArray:GetJsonObject(iLoop)
                   cookieName = oCookie:GetCharacter('CookieName':u)
                   domain     = oCookie:GetCharacter('Domain':u)
                   path       = oCookie:GetCharacter('Path':u)
                   .
                   
            find lbCookie 
            where lbCookie.CookieName = cookieName
              and lbCookie.Domain     = domain
              and lbCookie.Path       = path
              no-error.
            if not available lbCookie then
            do:     
                create lbCookie.
                assign lbCookie.CookieName = cookieName
                       lbCookie.Domain     = domain
                       lbCookie.Path       = path
                       .
            end.
            assign lbCookie.CreatedAt      = oCookie:GetDatetimeTZ('CreatedAt':u) 
                   lbCookie.LastAccessedAt = oCookie:GetDatetimeTZ('LastAccessedAt':u)
                   lbCookie.WholeCookie    = OpenEdge.Net.HTTP.Cookie:Parse(oCookie:GetCharacter('Cookie':u))
                   .
        end.
    end method.
    
    /** Persists - to disk - the current set of persistent cookies */
    method static private void PersistCookieJar(input pcCookieJarPath as character):
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
        oDump:WriteFile(pcCookieJarPath, session:debug-alert).
    end method.
    
    /** Adds a collection of  cookies to the jar.
        @param Cookie The cookies to add */
    method public void AddCookies(input poCookies as Cookie extent ).
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        Assert:NotNull(poCookies, 'Cookies').
        
        assign iMax = extent(poCookies).
        do iLoop = 1 to iMax:
            AddCookie(poCookies[iLoop]).
        end.
    end method.
    
    /** Removes a cookie from the jar.
        
        @param Cookie The cookie to remove 
        @return logical True if the cookie was deleted. */
    method public logical RemoveCookie(input poCookie as Cookie):
        define variable lDeleted as logical no-undo.
        
        Assert:NotNull(poCookie, 'Cookie').
        
        assign lDeleted = DeleteCookie(buffer SessionCookie:handle, poCookie).
        if not lDeleted then
            assign lDeleted = DeleteCookie(buffer PersistentCookie:handle, poCookie).
        
        return lDeleted.
    end method.
    
    /** Adds a cookie to the jar, for a given domain/path.

        Do not save bad cookies:
            - that do not have matching domains 
            - that are too broad in scope 
            
        @param character The domain to which this cookie applies
        @param character The path to which this cookie applies
        @param Cookie The cookie to add */
    method public void AddCookie(input pcDomain as character,
                                 input pcPath   as character,
                                 input poCookie as Cookie):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cDomain as character no-undo.
        define variable iMinSlugs as integer no-undo.
        
        Assert:NotNull(poCookie, 'Cookie').

        /* cannot have wild-card cookies on original top-level or
           country-code top-level domains 
           
           https://en.wikipedia.org/wiki/List_of_Internet_top-level_domains
           
           reject if
                - .X where X = a TLD
                - .X.Y where Y not a TLD */
        if pcDomain begins '.':u then
        do:
            /* domain needs to be at least X.Y (for the 7) or X.Y.Z (the others).
               can also have leading . (so .X.Y or .X.Y.Z) */
            assign cDomain = entry(num-entries(pcDomain, '.':u), pcDomain, '.':u).
            if index(mcGenericTLDs, cDomain) gt 0 or
               index(mcGenericCountryTLDs, cDomain) gt 0 then
                assign iMinSlugs = 3.
            else
                assign iMinSlugs = 4.
            
            /* return silently */
            if num-entries(pcDomain, '.':u) lt iMinSlugs then
            do:
                Logger:Debug(substitute('Bad domain &1 for cookie &2',
                                pcDomain, poCookie:ToString())).
                return.
            end.
        end.
        
        /* so we have some well-formed domain in the cookie now.
           make sure it's matched. */
        if not pcDomain matches '*':u + left-trim(poCookie:Domain, '.':u) then
        do:
            Logger:Debug(substitute('Bad domain &1 for cookie &2',
                            pcDomain, poCookie:ToString())).
            return.
        end.
        
        /* we only store a cookie in one place (either session or persistent) */
        if poCookie:ExpiresAt eq ? then
            PutCookie(buffer SessionCookie:handle, pcDomain, pcPath, poCookie).
        else
            PutCookie(buffer PersistentCookie:handle, pcDomain, pcPath, poCookie).
    end method.
    
    /** Adds a single cookie to the jar (and persists, if needed).
    
        @param character A cookie string as received from the HTTP response. */    
    method public void AddCookie(input poCookie as Cookie):
        Assert:NotNull(poCookie, 'Cookie').
        
        AddCookie(poCookie:Domain, poCookie:Path, poCookie).
    end method.
    
    /** Helper method for creating cookies in the relevant store (session or persistent).
        
        @param handle The buffer handle for the temp-table store
        @param character The domain to which this cookie applies
        @param character The path to which this cookie applies
        @param Cookie The cookie to add into the store. */
    method private void PutCookie(input phStore as handle,
                                  input pcDomain as character,
                                  input pcPath   as character,
                                  input poCookie as Cookie):
        Assert:IsType(phStore, DataTypeEnum:Buffer).
        Assert:NotNullOrEmpty(pcDomain, 'Cookie Domain').
        Assert:NotNull(pcPath, 'Cookie Path').
        
        if pcPath eq '':u then
            assign pcPath = '/':u.
        
        phStore:find-unique(substitute('where &1.CookieName eq "&2" and &1.Domain eq "&3" and &1.Path eq "&4"':u,
                    phStore:name,
                    poCookie:Name,
                    pcDomain,
                    pcPath)) no-error.
        // for not available records
        assign error-status:error = false.
        if not phStore:available then
        do:
            phStore:buffer-create().
            assign phStore::CookieName = poCookie:Name
                   phStore::Domain     = pcDomain
                   phStore::Path       = pcPath
                   phStore::CreatedAt  = now.
        end.
        assign phStore::WholeCookie = poCookie.
        
        phStore:buffer-release().
    end method.
    
    /** Clears all persistent cookies */
    method public void ClearPersistentCookies():
        define buffer lbCookie for PersistentCookie.
        
        empty temp-table lbCookie.
        
        /* will write an empty file */
        CookieJar:PersistCookieJar(this-object:CookieJarPath).
        
        Logger:Debug(substitute('Cleared persistent cookies: &1', iso-date(now))).
    end method. 
    
    /** Clears all session cookies */
    method public void ClearSessionCookies():
        define buffer lbCookie for SessionCookie.
        
        empty temp-table lbCookie.
        
        Logger:Debug(substitute('Cleared session cookies: ', iso-date(now))).
    end method.
end class.
