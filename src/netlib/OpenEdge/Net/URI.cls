/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
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

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterable.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriEncodingTypeEnum.
using OpenEdge.Net.UriSchemeEnum.

class OpenEdge.Net.URI:
    /* internal string representation of this object. we don't really want to build it 
       every time we need it */
    define private variable mcUri as character no-undo.
    
    /** (mandatory) The schema of the URI (ie http, https etc) */
    define public property Scheme as character no-undo get. private set.
    
    /** (mandatory) The host */
    define public property Host as character no-undo get. private set.

    /** (optional) A user for this URI */
    define public property User as character no-undo get.
        set(input pcUser as character):
            /* flag URI as changed */
            assign mcURI = ?
                   this-object:User = pcUser.
        end set.
    
    /** (optional) The user's password */
    define public property Password as character no-undo get.
        set(input pcPassword as character):
            /* flag URI as changed */
            assign mcURI = ?
                   this-object:Password = pcPassword.
        end set.
    
    /** (optional) The port for this URI. Some schemes assume a default (ie 80 for http) */
    define public property Port as integer no-undo get.
        set(input piPort as integer):
            /* flag URI as changed */
            assign mcUri = ?
                   this-object:Port = piPort.
        end set.
        
    /** (optional) The URI path. May contain parameters.
        Must be empty or begin with a / */
    define public property Path as character no-undo get.
        set(input pcPath as character):
            Assert:NotNull(pcPath, 'path').
            if pcPath ne '':u and
               not pcPath begins '/':u then
                assign pcPath = '/':u + pcPath.
                
            /* flag URI as changed */
            assign mcUri = ?
                   this-object:Path = pcPath.
        end set.
        
    /** (optional) The URI fragment (ie trails the # at the end of the URI) */ 
    define public property Fragment as character no-undo get. 
        set(input pcFragment as character):
            /* flag URI as changed */
            assign mcUri = ?
                   this-object:Fragment = pcFragment.
        end set.
    
    /** Returns a base URI (scheme, host, etc) */
    define public property BaseURI as character no-undo 
        get():
            if mcUri eq ? then
                BuildUri().
            
            return this-object:BaseURI.
        end get.
        private set.

    /** Returns a relative URI (path, QueryMap et al) */
    define public property RelativeURI as character no-undo 
        get():
            if mcUri eq ? then
                BuildUri().
            
            return this-object:RelativeURI.
        end get.
        private set.
        
    /** Returns the Query string, if any */    
    define public property QueryString as character no-undo
        get():
            if mcUri eq ? then
                BuildUri().
            
            return this-object:QueryString.
        end get.
        private set.
    
    /**  A map of QueryMap arguments. Set these value via AddQueryMap() */
    define protected property QueryMap as IStringStringMap no-undo get. private set.

    /** Constructor. Defaults to HTTP scheme.
     
        @param character The host name. */    
    constructor public URI(input pcHost as character):
        this-object(string(UriSchemeEnum:http), pcHost).
    end constructor.
    
    /** Constructor.
      
        @param character The scheme for this URI.
        @param character The host name. */
    constructor public URI(input pcScheme as character,
                           input pcHost as character):
        this-object(pcScheme,
                    pcHost,
                    ?,
                    '':u,
                    new StringStringMap(),
                    ?).
    end constructor.

    /** Constructor.
      
        @param character The scheme for this URI.
        @param character The host name.
        @param integer The port to use. */
    constructor public URI(input pcScheme as character,
                           input pcHost as character,
                           input piPort as integer):
        this-object(pcScheme,
                    pcHost,
                    piPort,
                    '':u,
                    new StringStringMap(),
                    ?).
    end constructor.

    /** Constructor.
      
        @param character The scheme for this URI.
        @param character The host name.
        @param integer The port to use.
        @param character The path
        @param IStringStringMap the QueryMap arguments
        @param character The fragment, if any */
    constructor public URI(input pcScheme as character,
                           input pcHost as character,
                           input piPort as integer,
                           input pcPath as character,
                           input poQueryMap as IStringStringMap,
                           input pcFragment as character):
        Assert:NotNullOrEmpty(pcScheme, 'Scheme').
        Assert:NotNullOrEmpty(pcHost, 'Host').
        Assert:NotNull(poQueryMap, 'QueryMap').
        
        assign this-object:Scheme = pcScheme
               this-object:Host = pcHost
               this-object:QueryMap = poQueryMap
               
               this-object:Port = piPort
               this-object:Path = pcPath
               this-object:Fragment = pcFragment
        
               this-object:User = ?
               this-object:Password = ?
               
               this-object:RelativeURI = ?
               mcUri  = ?
               .
    end constructor.
    
    /** Parses a string containing a URI and creates a URI object from it
    
        @param character a string URI (eg http://www.progress.com/)
        @return URI A URI representation of the string. */
    method static public URI Parse(input pcURI as character):
        define variable oURI as URI no-undo.
        define variable cScheme as character no-undo.
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
        
        assign iMax = num-entries(pcURI, '/':u).
        /* we need at least 3 entries for this to be a decent URL:
             1  - scheme (eg http:)
             2  - the space between the 2 /'s
             3  - the host, port amnd optionally user/password 
             4+ - the path and other slugs */
        if iMax ge 3 then
            assign cScheme = right-trim(entry(1, pcURI, '/':u), ':':u).
        Assert:NotNullOrEmpty(cScheme, 'URI scheme').
        
        /* entry 2 is the 'space' between the double slashes */
        assign cHost = entry(3, pcURI, '/':u).
        
        /* get username/password out of real host */
        if index(cHost, '@':u) eq 0 then
            assign cUser = ?
                   cPassword = ?.
        else
        do:
            assign cUser = entry(1, cHost, '@':u)
                   cUser = entry(1, cUser, ':':u)
                   cPassword = ?
                   
                   cHost = entry(2, cHost, '@':u).
            if index(cUser, ':':u) gt 0 then
                cPassword = entry(2, cUser, ':':u).    
        end.

        if index(cHost, ':':u) eq 0 then
            assign iPort = ?.
        else
            /* port first, else we lose it */
            assign iPort = integer(entry(2, cHost, ':':u))
                   cHost = entry(1, cHost, ':':u).
        
        assign oURI = new URI(cScheme, cHost, iPort).
        
        if cUser ne ? then
               /* no domain string in the URL */
            assign oURI:User     = cUser
                   oURI:Password = cPassword.
        
        /* get path, querystring, fragments */
        /* entry 2 is the 'space' between the double slashes, so we start after the host, at 4 */
        assign cDelimiter = '/':u
               cPath      = '':u.
        do iLoop = 4 to iMax:
            assign cPath = cPath
                         + cDelimiter
                         + entry(iLoop, pcURI, cDelimiter).
        end.
        if num-entries(cPath, '?':u) gt 1 then
            assign cQuery = entry(2, cPath, '?':u)
                   cPath = entry(1, cPath, '?':u).
            
        assign oURI:Path = cPath.
        
        /* QueryMap and fragment */            
        if num-entries(cQuery, '#':u) gt 1 then
            assign oURI:Fragment = entry(2, cQuery, '#':u)
                   cQuery = entry(1, cQuery, '#':u).
        
        assign iMax = num-entries(cQuery, '&':u).
        do iLoop = 1 to iMax:
            assign cQueryPart = entry(iLoop, cQuery, '&':u).
            if index(cQueryPart, '=':u) eq 1 then
                oURI:AddQuery(cQueryPart).
            else
                oURI:AddQuery(entry(1, cQueryPart, '=':u), entry(2, cQueryPart, '=':u)).
        end.
        
        return oURI.
    end method.
    
    /** Adds a name-only QueryMap argument. Equivalent to calling 
        AddQueryMap(pcname, ?).
    
        @param character The QueryMap name */
    method public void AddQuery(input pcName as character):
        AddQuery(pcName, ?).
    end method.
    
    /** Adds a query argument
        @param character The query name 
        @param character The query value */
    method public void AddQuery (input pcName as character, input pcValue as character):
        Assert:NotNullOrEmpty(pcName, 'Query name').
        
        /* flag URI as changed */
        assign mcUri = ?.
        
        this-object:QueryMap:Put(pcName, pcValue).
    end method.

    /** Get a char query value from the query 
        @param character The query name */
    method public character GetQueryValue(input pcName as character):
        define variable val as longchar no-undo.
        
        Assert:NotNullOrEmpty(pcName, 'Query name').
        
        val = QueryMap:Get(input pcName).

        return string(val). 
    end method.

    /* constructs a string representation */
    method private void BuildUri():
        define variable cRootURI as character no-undo.
        define variable cRelativeURI as character no-undo.
        define variable cPath as character no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oEntry as MapEntry no-undo.
        define variable cDelimiter as character no-undo.
        define variable cQueryString as character no-undo.
        
        assign cRootURI = substitute('&1://':u, this-object:Scheme).
        
        if this-object:User ne ? then
        do: 
            assign cRootURI = cRootURI + this-object:User.
            if this-object:Password ne ? then
                assign cRootURI = cRootURI + substitute(':&1':u, this-object:Password).
            assign cRootURI = cRootURI + '@':u.
        end.
                
        assign cRootURI = cRootURI + this-object:Host.
        if this-object:Port ne ? then
            assign cRootURI = cRootURI + substitute(':&1':u, this-object:Port).
        
        assign cPath = this-object:Path.
        if this-object:QueryMap:Size gt 0 then
        do:
            assign cDelimiter = '?':u
                   oIterator = this-object:QueryMap:EntrySet:Iterator()
                   cQueryString = '':u. 
            do while oIterator:HasNext():
                assign oEntry = cast(oIterator:Next(), MapEntry)
                       cQueryString = cQueryString + substitute('&1&2':u, cDelimiter, oEntry:Key:ToString())
                       cDelimiter = '&':u.
                if valid-object(oEntry:Value) then 
                    assign cQueryString = cQueryString + substitute('=&1':u, oEntry:Value:ToString()).
            end.
            
            if cPath eq '':u then
                assign cPath = '/':u.
        end.
                    
        /* if there's no QueryMap string, then cQuery will be blank. */
        if cPath ne '':u or cQueryString ne '':u then 
            assign cRelativeURI = substitute('&1&2':u, cPath, cQueryString).
        
        if this-object:Fragment ne ? then
            assign cRelativeURI = substitute('&1#&2':u, cRelativeURI, this-object:Fragment).
        
        assign this-object:BaseURI     = cRootURI
               this-object:RelativeURI = cRelativeURI
               this-object:QueryString = cQueryString
               
               mcUri = substitute('&1&2':u, cRootURI, cRelativeURI).
    end method.
    
    /** Returns a string representation of this URI 
        @return character The string URI */
    method override public character ToString():
        if mcUri eq ? then
            BuildUri().
        
        return mcUri.
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
        define variable cEncodedQueryString as character no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable cNames as character extent no-undo.
        define variable cDelimiter as character no-undo.
        define variable cValue as character no-undo.
        
        Assert:NotNull(poURI, 'URI').
        
        /* individual query values are encoded, not the names */
        assign cDelimiter   = '?':u
               cEncodedQueryString = '':u
               iMax = poURI:GetQueryNames(output cNames)
               .
        do iLoop = 1 to iMax:
            assign cEncodedQueryString = cEncodedQueryString 
                                       + substitute('&1&2':u, cDelimiter, cNames[iLoop])
                   cValue     = poURI:GetQueryValue(cNames[iLoop])
                   cDelimiter = '&':u.
            if cValue ne ? then 
                assign cEncodedQueryString = cEncodedQueryString 
                                           + substitute('=&1':u, cValue).
        end.

        return substitute('&1&2&3':u,
                        OpenEdge.Net.URI:Encode(poURI:BaseURI,     UriEncodingTypeEnum:Default),
                        OpenEdge.Net.URI:Encode(poURI:Path,        UriEncodingTypeEnum:Default),
                        cEncodedQueryString).
    end method.
    
    /** Encodes a string for a particular purpose
    
        @param character The string to encode
        @param EncondingTypeEnum The type of encoding to apply
        @return character the encoded string */
    method static public character Encode(input pcString       as character, 
                                          input poEncodingType as UriEncodingTypeEnum):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable rChar as raw no-undo.
        define variable iAsc as integer no-undo.
        define variable cChar as character no-undo.
        define variable cEncodeList as character no-undo.
        define variable cEncodedString as character no-undo.
        
        /* Unsafe characters that must be encoded in URL's.  See RFC 1738 Sect 2.2. */
        define variable cUrlUnsafe as character no-undo 
            initial " <>~"#%~{}|~\^~~[]`":u.
        
        /* Reserved characters that normally are not encoded in URL's */
        define variable cUrlReserved as character no-undo 
            initial "~;/?:@=&":u.
        
        /* Don't bother with blank or unknown  */
        if length(pcString) eq 0 or pcString eq ? then
            return '':u.

        Assert:NotNull(poEncodingType, 'Encoding Type').            
        
        /* What kind of encoding should be used? */
        case poEncodingType:
            when UriEncodingTypeEnum:Query then     /* Query_STRING name=value parts */
                assign cEncodeList = cUrlUnsafe + cUrlReserved + "+":U.
            when UriEncodingTypeEnum:Cookie then    /* Persistent Cookies */
                assign cEncodeList = cUrlUnsafe + " ,~;":U.
            when UriEncodingTypeEnum:Default then   /* Standard URL encoding */
                assign cEncodeList = cUrlUnsafe.
        end case.
        
        /* Loop through entire input string */
        assign iloop = 0
               iMax = length(pcString, 'raw':u)
               length(rChar) = 1.
               
        do iLoop = 1 to iMax:
            assign /* ASCII value of character using single byte codepage */
                   cChar = substring(pcString, iLoop, 1, "RAW":U)
                   iAsc  = asc(cChar, "1252":U, "1252":U).
            
            /* 32 < lower, upper alphas, numbers < 127*/
            if iAsc le 31 or iAsc ge 127 or index(cEncodeList, chr(iAsc)) gt 0 then 
            do:
                /* use put-byte so as not to have a null terminator */
                put-byte(rChar, 1) = iAsc.
                
                /* Replace character with %hh hexidecimal triplet */
                assign cChar = substitute('%&1', hex-encode(rChar)).
            end.
            
            /* add/create a new string because replacing 1 character with 2 messes up our math */            
            assign cEncodedString = cEncodedString + cChar.
        end.
        
        return cEncodedString.
    end method.

    /** Attempts to decode a previously-encoded URL.        
        
        @return character A decoded URL */
    method public character Decode():
        return OpenEdge.Net.URI:Decode(this-object:ToString()).
    end method.
    
    /** Attempts to decode a previously-encoded URL.
        
        @param  character The URL to decode
        @return character A decoded URL */
    method static public character Decode(input pcURI as character):
        define variable cDecodedURI as character no-undo.
        define variable iStart as integer no-undo.
        define variable iPos as integer no-undo.
        define variable iAsc as integer no-undo.
        define variable cHex as character no-undo.
        define variable rDecoded as raw no-undo.
        define variable cAscChar as character no-undo.
        
        Assert:NotNullOrEmpty(pcURI, 'URI').
        
        assign iStart = 1
               iPos   = index(pcURI, '%':u, iStart).
               . 
        do while iPos gt 0:
            assign cHex     = substring(pcURI, iPos + 1, 2)
                   rDecoded = hex-decode(cHex)
                   iAsc     = get-byte(rDecoded, 1)
                   cAscChar = chr(iAsc, '1252':u, '1252':u)
                   
                   cDecodedURI = cDecodedURI 
                               + substring(pcURI, iStart, (iPos - iStart)) 
                               + cAscChar                   
                   
                   iStart = iPos + 3
                   iPos   = index(pcURI, '%':u, iStart).
        end.
        
        /* add anycharacters that appear after the last % */
        assign cDecodedURI = cDecodedURI + substring(pcURI, iStart).
        
        return cDecodedURI.
    end method.
    
    /** Returns an array of query names 
        @param character[] An array
        @return integer The number */
    method public integer GetQueryNames(output pcNames as character extent):
        define variable iCount as integer no-undo.
        define variable oIterator as IIterator no-undo.
        
        assign iCount = this-object:QueryMap:Size
               oIterator = cast(this-object:QueryMap:KeySet, IIterable):Iterator().
        
        if iCount gt 0 then
            extent(pcNames) = iCount.
        
        assign iCount = 0.
        do while oIterator:HasNext():
            assign pcNames[iCount + 1] = oIterator:Next():ToString()
                   iCount = iCount + 1. 
        end.
        
        return iCount.
    end method.
    
end class.