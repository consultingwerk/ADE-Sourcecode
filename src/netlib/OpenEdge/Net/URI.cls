/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : URI
    Purpose     : A generic URI object, useful for making request over a network
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:02:50 EST 2013
    Notes       : * W3C spec at  http://tools.ietf.org/html/rfc3986 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using OpenEdge.Net.UriEncodingTypeEnum.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Assert.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.Credentials.

class OpenEdge.Net.URI:
    /** (mandatory) The schema of the URI (ie http, https etc) */
    define public property Scheme as UriSchemeEnum no-undo get. private set.
    /** (mandatory) The host */
    define public property Host as character no-undo get. private set.
    
    /** (optional) A set of credentials for this URI.
        Setting properties on this object will not flag the URI as changed;
        to do that, use the individual User/Password/Domain properties instead */
    define public property Credentials as Credentials no-undo get.
        set(input poCredentials as Credentials):
            /* flag URI as changed */
            assign this-object:URI = ?
                   this-object:Credentials = poCredentials.
        end set.
    
    /** (optional) A user for this URI */
    define public property User as character no-undo
        get():
            if not valid-object(this-object:Credentials) then
                return ?.
            return this-object:Credentials:UserName.
        end get.
        set(input pcUser as character):
            if not valid-object(this-object:Credentials) then
                assign this-object:Credentials = new Credentials().
            
            /* flag URI as changed */
            assign this-object:URI = ?
                   this-object:Credentials:UserName = pcUser.
        end set.
    
    /** (optional) The user's password */
    define public property Password as character no-undo
        get():
            if not valid-object(this-object:Credentials) then
                return ?.
            return this-object:Credentials:Password.
        end get.
        set(input pcPassword as character):
            if not valid-object(this-object:Credentials) then
                assign this-object:Credentials = new Credentials().
            
            /* flag URI as changed */
            assign this-object:URI = ?
                   this-object:Credentials:Password = pcPassword.
        end set.

    /** (optional) The domain in which the user resides */
    define public property Domain as character no-undo
        get():
            if not valid-object(this-object:Credentials) then
                return ?.
            return this-object:Credentials:Domain.
        end get.
        set(input pcDomain as character):
            if not valid-object(this-object:Credentials) then
                assign this-object:Credentials = new Credentials().
            /* no URI change needed, since the domain is not part of the URI */
            assign this-object:Credentials:Domain = pcDomain.
        end set.
    
    /** (optional) The port for this URI. Some schemes assume a default (ie 80 for http) */
    define public property Port as integer no-undo get.
        set(input piPort as integer):
            /* flag URI as changed */
            assign this-object:URI = ?
                   this-object:Port = piPort.
        end set.
        
    /** (optional) The URI path. Contains parameters */        
    define public property Path as character no-undo get.
        set(input pcPath as character):
            /* flag URI as changed */
            assign this-object:URI = ?
                   this-object:Path = pcPath.
        end set.
        
    /** (optional) The URI fragment (ie trails the # at the end of the URI) */ 
    define public property Fragment as character no-undo get. 
        set(input pcFragment as character):
            /* flag URI as changed */
            assign this-object:URI = ?
                   this-object:Fragment = pcFragment.
        end set.
    
    /** Returns the complete URI (scheme, host, path et al) */
    define public property URI as character no-undo
        get():
            if this-object:URI eq ? then
                BuildUri().
            
            return this-object:URI.
        end get.
        private set.
    
    /** Returns a base URI (scheme, host, etc) */
    define public property BaseURI as character no-undo 
        get():
            if this-object:URI eq ? then
                BuildUri().
            
            return this-object:BaseURI.
        end get.
        private set.

    /** Returns a relative URI (path, query et al) */
    define public property RelativeURI as character no-undo 
        get():
            if this-object:URI eq ? then
                BuildUri().
            
            return this-object:RelativeURI.
        end get.
        private set.

    /**  A map of query arguments. Set these value via AddQuery() */
    define protected property Query as IStringStringMap no-undo get. private set.

    /** Constructor. Defaults to HTTP scheme.
     
        @param character The host name. */
    
    constructor public URI(input pcHost as character):
        this-object(UriSchemeEnum:Http, pcHost).
    end constructor.
    
    /** Constructor.
      
        @param UriSchemeEnum The scheme for this URI.
        @param character The host name. */
    constructor public URI(input poScheme as UriSchemeEnum,
                           input pcHost as character):
        this-object(poScheme,
                    pcHost,
                    ?,
                    ?,
                    new StringStringMap(),
                    ?).
    end constructor.

    /** Constructor.
      
        @param UriSchemeEnum The scheme for this URI.
        @param character The host name.
        @param integer The port to use. */
    constructor public URI(input poScheme as UriSchemeEnum,
                           input pcHost as character,
                           input piPort as integer):
        this-object(poScheme,
                    pcHost,
                    piPort,
                    ?,
                    new StringStringMap(),
                    ?).
    end constructor.

    /** Constructor.
      
        @param UriSchemeEnum The scheme for this URI.
        @param character The host name.
        @param integer The port to use.
        @param character The path
        @param IStringStringMap the query arguments
        @param character The fragment, if any */
    constructor public URI(input poScheme as UriSchemeEnum,
                           input pcHost as character,
                           input piPort as integer,
                           input pcPath as character,
                           input poQuery as IStringStringMap,
                           input pcFragment as character):
        Assert:NotNull(poScheme, 'Scheme').
        Assert:NotNullOrEmpty(pcHost, 'Host').
        Assert:NotNull(poQuery, 'Query').
        
        assign this-object:Scheme = poScheme
               this-object:Host = pcHost
               this-object:Query = poQuery
               
               this-object:Port = piPort
               this-object:Path = pcPath
               this-object:Fragment = pcFragment
        
               this-object:Credentials = ?
               
               this-object:RelativeURI = ?
               this-object:URI  = ?
               .
    end constructor.
    
    /** Parses a string containing a URI and creates a URI object from it
    
        @param character a string URI (eg http://www.progress.com/)
        @return URI A URI representation of the string. */
    method static public URI Parse(input pcURI as character):
        define variable oURI as URI no-undo.
        define variable oScheme as UriSchemeEnum no-undo.
        define variable cHost as character no-undo.
        define variable iPort as integer no-undo.
        define variable cPath as character no-undo.
        define variable cQuery as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cUser as character no-undo .
        define variable cPassword as character no-undo.
        define variable cDelimiter as character no-undo.
        define variable cQueryPart as character no-undo.
        
        Assert:NotNullOrEmpty(pcURI, 'URI string').
        
        iMax = num-entries(pcURI, '/').
        oScheme = UriSchemeEnum:FromString(right-trim(entry(1, pcURI, '/'), ':')).
        Assert:NotNull(oScheme, 'URI scheme').
        
        /* entry 2 is the 'space' between the double slashes */
        cHost = entry(3, pcURI, '/').
        
        /* get username/password out of real host */
        if index(cHost, '@') eq 0 then
            assign cUser = ?
                   cPassword = ?.
        else
        do:
            assign cUser = entry(1, cHost, '@')
                   cUser = entry(1, cUser, ':')
                   cPassword = ?
                   
                   cHost = entry(2, cHost, '@').
            if index(cUser, ':') gt 0 then
                cPassword = entry(2, cUser, ':').    
        end.

        if index(cHost, ':') eq 0 then
            assign iPort = ?.
        else
            /* port first, else we lose it */
            assign iPort = integer(entry(2, cHost, ':'))
                   cHost = entry(1, cHost, ':').
        
        assign oURI = new URI(oScheme, cHost)
               oURI:Port = iPort.
        
        if cUser ne ? then
               /* no domain string in the URL */
            assign oURI:User     = cUser
                   oURI:Password = cPassword.
        
        /* get path, query. fragments */
        /* entry 2 is the 'space' between the double slashes, so we start after the host, at 4 */
        assign cDelimiter = ''.
        do iLoop = 4 to iMax:
            assign cPath = cPath
                         + cDelimiter
                         + entry(iLoop, pcURI, '/')
                   cDelimiter = '/'.
        end.
        if num-entries(cPath, '?') gt 1 then
            assign cQuery = entry(2, cPath, '?')
                   cPath = entry(1, cPath, '?').
        else
        if cPath eq '' then
            assign cPath = ?.
            
        assign oURI:Path = cPath.
        
        /* query and fragment */            
        if num-entries(cQuery, '#') gt 1 then
            assign oURI:Fragment = entry(2, cQuery, '#')
                   cQuery = entry(1, cQuery, '#').
        
        assign iMax = num-entries(cQuery, '&').
        do iLoop = 1 to iMax:
            assign cQueryPart = entry(iLoop, cQuery, '&').
            if index(cQueryPart, '=') eq 1 then
                oURI:AddQuery(cQueryPart).
            else
                oURI:AddQuery(entry(1, cQueryPart, '='), entry(2, cQueryPart, '=')).
        end.
        
        return oURI.
    end method.
    
    /** Adds a name-only query argument. Equivalent to calling 
        AddQuery(pcname, ?).
    
        @param character The query name */
    method public void AddQuery(input pcName as character):
        AddQuery(pcName, ?).
    end method.
    
    /** Adds a query argument
        @param character The query name 
        @param character The query value */
    method public void AddQuery(input pcName as character, input pcValue as character):
        /* flag URI as changed */
        assign this-object:URI = ?.
        
        this-object:Query:Put(pcName, pcValue).
    end method.

    /* constructs a string representation */
    method private void BuildUri():
        define variable cRootURI as character no-undo.
        define variable cRelativeURI as character no-undo.
        define variable cPath as character no-undo.
        define variable cQuery as character no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oEntry as MapEntry no-undo.
        define variable cDelimiter as character no-undo.
        
        assign cRootURI = substitute('&1://', this-object:Scheme:Name).
        
        if valid-object(this-object:Credentials) and 
           this-object:Credentials:UserName ne ? then
        do: 
            assign cRootURI = cRootURI + this-object:Credentials:UserName.
            if this-object:Credentials:Password ne ? then
                assign cRootURI = cRootURI + substitute(':&1', this-object:Credentials:Password).
            assign cRootURI = cRootURI + '@'.
        end.
        
        assign cRootURI = cRootURI + this-object:Host.
        if this-object:Port ne ? then
            assign cRootURI = cRootURI + substitute(':&1', this-object:Port).
        
        if this-object:Path ne ? then
            assign cPath = this-object:Path
                   /* we re-add the leading / when building the URL */
                   cPath = left-trim(cPath, '/').

        if this-object:Query:Size gt 0  then
        do:
            assign cDelimiter = '?'
                   oIterator = this-object:Query:EntrySet:Iterator(). 
            do while oIterator:HasNext():
                assign oEntry = cast(oIterator:Next(), MapEntry)
                       cQuery = cQuery + substitute('&1&2', cDelimiter, oEntry:Key:ToString())
                       cDelimiter = '&'.
                if valid-object(oEntry:Value) then 
                    assign cQuery = cQuery + substitute('=&1', oEntry:Value:ToString()).
            end.
        end.
        
        /* if there's no query string, then cQuery will be blank. */
        assign cRelativeURI = substitute('/&1&2', cPath, cQuery).
        
        if this-object:Fragment ne ? then
            assign cRelativeURI = substitute('&1#&2', cRelativeURI, this-object:Fragment).
        
        assign this-object:BaseURI     = cRootURI
               this-object:RelativeURI = cRelativeURI
               this-object:URI         = substitute('&1&2', cRootURI, cRelativeURI).
    end method.
    
    /** Returns a string representation of this URI 
        @return character The string URI */
    method override public character ToString():
        return this-object:URI.
    end.
    
    /** Encodes this URI
        
        @return character An encoded version of the URI */
    method public character Encode():
        return OpenEdge.Net.URI:Encode(this-object).
    end method.
    
    /** Encodes a URI.
        
        @param URI The URI to encode
        @param character A character representaion of the URI */
    method static public character Encode(input poURI as URI):
        Assert:NotNull(poURI, 'URI').
        
        return substitute('&1&2',
                        OpenEdge.Net.URI:Encode(poURI:BaseURI,     UriEncodingTypeEnum:Default),
                        OpenEdge.Net.URI:Encode(poURI:RelativeURI, UriEncodingTypeEnum:Query)).
    end method.
    
    /** Encodes a string for a particular purpose
    
        @param character The string to encode
        @param EncondingTypeEnum The type of encoding to apply
        @return character the encoded string */
    method static public character Encode(input pcString       as character, 
                                          input poEncodingType as UriEncodingTypeEnum):
        define variable iLoop as integer   no-undo.
        define variable iMax as integer no-undo.
        define variable rChar as raw no-undo.
        define variable iAsc as integer no-undo.
        define variable cEncodeList as character no-undo.
        
        /* Unsafe characters that must be encoded in URL's.  See RFC 1738 Sect 2.2. */
        define variable cUrlUnsafe as character no-undo 
            initial " <>~"#%~{}|~\^~~[]`".
        
        /* Reserved characters that normally are not encoded in URL's */
        define variable cUrlReserved as character no-undo 
            initial "~;/?:@=&".
        
        /* Don't bother with blank or unknown  */
        if length(pcString) eq 0 or pcString = ? then
            return "".

        Assert:NotNull(poEncodingType, 'Encoding Type').            
        
        /* What kind of encoding should be used? */
        case poEncodingType:
            when UriEncodingTypeEnum:Query then     /* QUERY_STRING name=value parts */
                assign cEncodeList = cUrlUnsafe + cUrlReserved + "+":U.
            when UriEncodingTypeEnum:Cookie then    /* Persistent Cookies */
                assign cEncodeList = cUrlUnsafe + " ,~;":U.
            when UriEncodingTypeEnum:Default then   /* Standard URL encoding */
                assign cEncodeList = cUrlUnsafe.
        end case.
        
        /* Loop through entire input string */
        assign iloop = 0
               iMax = length(pcString, 'raw')
               length(rChar) = 1.
        do iLoop = 1 to iMax:
            assign /* ASCII value of character using single byte codepage */
                   iAsc = asc(substring(pcString, iLoop, 1, "RAW":U), "1252":U, "1252":U).
            /* 32 < lower, upper alphas, numbers < 127*/
            if iAsc le 31 or iAsc ge 127 or index(cEncodeList, chr(iAsc)) gt 0 then 
            do:
                /* use put-byte so as not to have a null terminator */
                put-byte(rChar, 1) = iAsc.
                /* Replace character with %hh hexidecimal triplet */
                substring(pcString, iLoop, 1, "RAW":U) = '%' + hex-encode(rChar).  
            end.
        end.
        
        return pcString.
    end method.
    
end class.