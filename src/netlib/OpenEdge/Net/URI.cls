/************************************************
Copyright (c) 2014-2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : URI
    Purpose     : A generic URI object, useful for making request over a network
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:02:50 EST 2013
    Notes       : * W3C spec at  http://tools.ietf.org/html/rfc3986
                  * the grammer for determining valid, non-encoded values is  
        reserved    = gen-delims / sub-delims
        gen-delims  = ":" / "/" / "?" / "#" / "[" / "]" / "@"
        sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
        pchar       = unreserved / pct-encoded / sub-delims / ":" / "@"
                      ALPHA / DIGIT / "-" / "." / "_" / "~" /
                        "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "=" /
                       R:" / "@"        
        unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
        
        Default  : unreserved

        Query    : query         = *( pchar / "/" / "?" )
                      ALPHA / DIGIT / "-" / "." / "_" / "~" /
                        "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "=" /
                        ":" / "@" / 
                        "/" / "?"        
        
        Scheme   : scheme        = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
        
        Fragment : fragment      = *( pchar / "/" / "?" )
        
        Path     : path-abempty  = *( "/" segment )
                   segment       = *pchar
            
        UserInfo : userinfo    = *( unreserved / pct-encoded / sub-delims / ":" )
        
        Host     : host          = IP-literal / IPv4address / reg-name
                   reg-name      = *( unreserved / pct-encoded / sub-delims )
                   IP-literal    = "[" ( IPv6address / IPvFuture  ) "]"
                   IPv4address   = dec-octet "." dec-octet "." dec-octet "." dec-octet
                   dec-octet     = DIGIT                 ; 0-9
                                 / %x31-39 DIGIT         ; 10-99
                                 / "1" 2DIGIT            ; 100-199
                                 / "2" %x30-34 DIGIT     ; 200-249
                                 / "25" %x30-35          ; 250-255
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterable.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.String.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriEncodingTypeEnum.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Lang.AppError.

class OpenEdge.Net.URI:
    
    // true/false flags for the US-ASCII characters that must / not be percent-encoded
    define private static variable mEncFlag_Default  as logical   extent 128 initial false no-undo.
    define private static variable mEncFlag_Scheme   as logical   extent 128 initial false no-undo.
    define private static variable mEncFlag_Userinfo as logical   extent 128 initial false no-undo.
    define private static variable mEncFlag_Host     as logical   extent 128 initial false no-undo.
    define private static variable mEncFlag_Path     as logical   extent 128 initial false no-undo.
    define private static variable mEncFlag_Query    as logical   extent 128 initial false no-undo.
    define private static variable mEncFlag_Fragment as logical   extent 128 initial false no-undo.
    define private static variable mEncFlag_Cookie   as logical   extent 128 initial false no-undo.
    
    /* internal string representation of this object. we don't really want to build it 
       every time we need it */
    define private variable mcUri as character no-undo.
    
    /** (mandatory) The schema of the URI (ie http, https etc) */
    define public property Scheme as character no-undo get. private set.
    
    // Indicates the host value type. One of NAME, IPV4, IPLIT from spec (above)
    define variable mcHostType as character no-undo.
    
    /** (mandatory) The host name*/
    define public property Host as character no-undo
        get.
        private set(input pcHost as character):
            // it's technically [ and ] but [] are reserved chars
            if pcHost begins '[':u then
                assign this-object:Host = substring(right-trim(pcHost, ']':u), 2) 
                       mcHostType       = 'IPLIT':u.
            else
                assign this-object:Host = pcHost
                       mcHostType       = 'NAME':u.
        end set.
    
    /** (optional) A user for this URI */
    define public property User as character no-undo
        get.
        set(input pcUser as character):
            /* flag URI as changed */
            assign mcURI            = ?
                   this-object:User = pcUser.
        end set.
    
    /** (optional) The user's password */
    define public property Password as character no-undo
        get.
        set(input pcPassword as character):
            /* flag URI as changed */
            assign mcURI                = ?
                   this-object:Password = pcPassword.
        end set.
    
    /** (optional) The port for this URI. Some schemes assume a default (ie 80 for http) */
    define public property Port as integer no-undo
        get.
        set(input piPort as integer):
            /* flag URI as changed */
            assign mcUri            = ?
                   this-object:Port = piPort.
        end set.
    
    /** (optional) The URI path. May contain ;-delmited parameters.
        
        If a path contains a / that value MUST be %-encoded before setting
        here. Use URI:EncodePath() on each /-delimited path segment before setting
        this property.
        
        Alternatively use SetPath(segment[]) to set paths with / values
        
        Values cannot be empty or null. */
    define public property Path as character no-undo initial '/':u
        get.
        set(input pcPath as character):
            Assert:NotNullOrEmpty(pcPath, 'path').
            
            if not pcPath begins '/':u then
                assign pcPath = '/':u + pcPath.
            
            /* flag URI as changed */
            assign mcUri            = ?
                   this-object:Path = pcPath.
        end set.
        
    /** (optional) The URI fragment (ie trails the # at the end of the URI) */ 
    define public property Fragment as character no-undo
        get. 
        set(input pcFragment as character):
            /* flag URI as changed */
            assign mcUri                = ?
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
    
    /* Static constructor. Used to build lists of to-encode character flags */ 
    constructor static URI():
        define variable unreserved as character no-undo.
        define variable pchar      as character no-undo.
        define variable chrLoop    as integer   no-undo.
        define variable chrMax     as integer   no-undo.
        define variable allowedChr as character no-undo.
        define variable ALPHA      as character no-undo
            // a..zA..Z
            initial '65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122':u.
        
        define variable DIGIT      as character no-undo
            // 0..9
            initial '48,49,50,51,52,53,54,55,56,57':u.
            
        define variable sub-delims as character no-undo
            // ! $ & ' ( ) * + , ; =
            initial '33,36,38,39,40,41,42,43,44,59,61':u.
            
        assign unreserved = ALPHA + ',':u + DIGIT 
                            // hyphen (-) point (.) underscore (_) tilde (~)
                          + ',45,46,95,126':u
               pchar      = unreserved + ',':u + sub-delims
                          // colon (:) at (@)
                          + ',58,64':u
              .
        // Default = unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"        
        assign allowedChr = unreserved 
               chrMax     = num-entries(allowedChr)
               .
        do chrLoop = 1 to chrMax:
            assign mEncFlag_Default[integer(entry(chrLoop, allowedChr)) + 1] = true.
        end.
        
        // Scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
        assign allowedChr = ALPHA + ',':u + DIGIT + ',43,45,46':u
               chrMax     = num-entries(allowedChr)
               .
        do chrLoop = 1 to chrMax:
            assign mEncFlag_Scheme[integer(entry(chrLoop, allowedChr)) + 1] = true.
        end.
        
        // Host = reg-name      = *( unreserved / pct-encoded / sub-delims )
        // Also IP addresses allowed
        assign allowedChr = unreserved + ',':u + sub-delims
               chrMax     = num-entries(allowedChr)
               .
        do chrLoop = 1 to chrMax:
            assign mEncFlag_Host[integer(entry(chrLoop, allowedChr)) + 1] = true
                   mEncFlag_Userinfo[integer(entry(chrLoop, allowedChr)) + 1] = true
                   .
        end.
        
        // UserInfo : userinfo    = *( unreserved / pct-encoded / sub-delims / ":" = 58 )
        assign mEncFlag_Userinfo[58 + 1] = true.
        
        // Path : path-abempty  = *( "/" segment )
        //        segment       = *pchar
        assign allowedChr = pchar
               chrMax     = num-entries(allowedChr)
               .
        do chrLoop = 1 to chrMax:
            assign mEncFlag_Path[integer(entry(chrLoop, allowedChr)) + 1]     = true
                   mEncFlag_Query[integer(entry(chrLoop, allowedChr)) + 1]    = true
                   mEncFlag_Fragment[integer(entry(chrLoop, allowedChr)) + 1] = true
                   .
        end.
        
        // Query    = *( pchar / "/" / "?" )
        // Fragment = *( pchar / "/" / "?" )
        // pchar's done above: add chars ',47,63':u . 
        assign // "/" = 47
               mEncFlag_Query[47 + 1]    = true
               mEncFlag_Fragment[47 + 1] = true
               // "?" = 63
               mEncFlag_Query[63 + 1]    = true
               mEncFlag_Fragment[63 + 1] = true
               
               /* While the spec at RFC3896 allows ampersands & in the query string,
                  it is extremely standard practice to use that as a delimiter between
                  key-value pairs of query parameters.
                  Section 3.4 refers https://tools.ietf.org/html/rfc3986#section-3.4  */
               // "&" = 38
               mEncFlag_Query[38 + 1] = false
               .
        
        // Cookie US-ASCII characters excluding CTLs, whitespace (32) DQUOTE (34), comma (44), semicolon (59), and backslash (92)       
        // 0-31 and 127+ are control or non-US-ASCII character; 32 is space               
        do chrLoop = 33 to 126:
            if     chrLoop eq 34         // 34=DQUOTE
                or chrLoop eq 44         // 44=comma
                or chrLoop eq 59         // 59=semicolon
                or chrLoop eq 92 then    // 92=backslash
                assign mEncFlag_Cookie[chrLoop + 1] = false.
            else
                assign mEncFlag_Cookie[chrLoop + 1] = true.
        end.
    end constructor.
    
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
                    '/':u,
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
                    '/':u,
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
        Assert:NotNullOrEmpty(pcPath, 'Path').
        
        assign this-object:Scheme      = pcScheme
               this-object:Host        = pcHost
               this-object:QueryMap    = poQueryMap
               this-object:Port        = piPort
               this-object:Path        = pcPath
               this-object:Fragment    = pcFragment
               this-object:User        = ?
               this-object:Password    = ?
               this-object:RelativeURI = ?
               mcUri                   = ?
               .
    end constructor.
    
    /** Parses a string containing a URI and creates a URI object from it
    
        @param character a string URI (eg http://www.progress.com/)
        @return URI A URI representation of the string. */
    method static public URI Parse(input pcURI as character):
        define variable oURI       as URI       no-undo.
        define variable cScheme    as character no-undo.
        define variable cHost      as character no-undo.
        define variable iPort      as integer   no-undo.
        define variable cPath      as character no-undo.
        define variable cQuery     as character no-undo.
        define variable iLoop      as integer   no-undo.
        define variable iMax       as integer   no-undo.
        define variable iPos       as integer   no-undo.
        define variable cUser      as character no-undo.
        define variable cPassword  as character no-undo.
        define variable cDelimiter as character no-undo.
        define variable cQueryPart as character no-undo.
        define variable cValue     as character no-undo.
        
        Assert:NotNullOrEmpty(pcURI, 'URI string').
        
        /* No scheme. Default to HTTP */
        if num-entries(pcURI, ':':u) eq 1 then
            assign pcURI = substitute('&1://&2':u,
                                string(UriSchemeEnum:http),
                                left-trim(pcURI,'/':u)).  
        
        assign iMax = num-entries(pcURI, '/':u).
        /* we need at least 3 entries for this to be a decent URL:
             1  - scheme (eg http:)
             2  - the space between the 2 /'s
             3  - the host, port amnd optionally user/password 
             4+ - the path and other slugs */
        if iMax lt 3 then
            undo, throw new AppError(substitute('Unable to parse malformed URI: &1', pcURI), 0).
        
        if iMax ge 3 then
            assign cScheme = right-trim(entry(1, pcURI, '/':u), ':':u).
        
        Assert:NotNullOrEmpty(cScheme, 'URI scheme').
        
        /* entry 2 is the 'space' between the double slashes */
        assign cHost = URI:Decode(entry(3, pcURI, '/':u))
               iPos  = r-index(cHost, '@':u)
               .
        /* get username/password out of real host */
        if iPos eq 0 then
            assign cUser     = ?
                   cPassword = ?.
        else
        do:
            assign cUser     = substring(cHost, 1, iPos - 1)  
                   cPassword = ?
                   cHost     = substring(cHost, iPos + 1)
                   iPos      = index(cUser, ':':u)
                   .
            if iPos gt 0 then
                assign cPassword = substring(cUser, iPos + 1)
                       cUser     = substring(cUser, 1, iPos - 1)
                       .
        end.
        
        // IPv6 addesses contain : so look for the right-most after any ]
        assign iPos = r-index(cHost, ']':u)
               iPos = index(cHost, ':':u, max(1, iPos)).
        if iPos eq 0 then 
            assign iPort = ?.
        else
            /* port first, else we lose it */
            assign iPort = integer(substring(cHost, iPos + 1))
                   cHost = substring(cHost, 1, iPos - 1).
        
        assign oURI = new URI(URI:Decode(cScheme), 
                              URI:Decode(cHost),
                              iPort).
        
        if cUser ne ? then
            /* no domain string in the URL */
            assign oURI:User     = URI:Decode(cUser)
                   oURI:Password = URI:Decode(cPassword).
        
        /* get path, querystring, fragments */
        /* entry 2 is the 'space' between the double slashes, so we start after the host, at 4 */
        assign cDelimiter = '':u.
        do iLoop = 4 to iMax:
            assign cValue = entry(iLoop, pcURI, '/':u).
            // check for query and fragment on the last segment only
            if iLoop eq iMax then
            do:
                assign iPos = index(cValue, '#':u).
                if iPos gt 0 then
                    assign oURI:Fragment = URI:Decode(substring(cValue, iPos + 1))
                           cValue        = substring(cValue, 1, iPos - 1)
                           .
                assign iPos = index(cValue, '?':u).
                if iPos gt 0 then
                    assign cQuery = substring(cValue, iPos + 1)
                           cValue = substring(cValue, 1, iPos - 1)
                           .
            end.
            assign cPath = '/':u when cPath eq '':u 
                   cPath = cPath + cDelimiter 
                         // encode the paths (especially for unicode chars); leave any %-encoding alone though
                         + URI:EncodeString(cValue, ?, mEncFlag_Path, false)
                   cDelimiter = '/':u.
        end.
        
        if cPath eq '':u then
            assign cPath = '/':u.
                        
        assign oURI:Path = cPath
               cValue    = '':u
               iMax      = 0
               .
        /* QueryMap and fragment */
        if cQuery ne '':u then
            assign iMax = num-entries(cQuery, '&':u).
        do iLoop = 1 to iMax:
            assign cQueryPart = entry(iLoop, cQuery, '&':u)
                   iPos       = index(cQueryPart, '=':u)
                   .
            if cQueryPart eq '':u then
                next.
            
            if iPos eq 0 then
                assign iPos = index(cQueryPart, ';':u).
            
            if iPos eq 0 then
                oURI:AddQuery(URI:Decode(cQueryPart)).
            else
            do:
                assign cValue = URI:Decode(substring(cQueryPart, iPos + 1))
                       no-error.
                if cValue eq ? then
                    assign cValue = '':u.
                oURI:AddQuery(URI:Decode(substring(cQueryPart, 1, iPos - 1)), cValue).
            end.
        end.
        
        return oURI.
    end method.
    
    /* Helper method to return the path as an array of segments.
       
       @return character[] An array of path segments. */
    method public integer GetPathSegments(output pSegments as character extent):
        define variable segmentCnt  as integer no-undo.
        define variable segmentLoop as integer no-undo.
        
        // There is always at least one slash, so start at 2. 
        assign segmentCnt        = num-entries(this-object:Path, '/':u)
               extent(pSegments) = segmentCnt - 1 
               .
        do segmentLoop = 2 to segmentCnt:
            assign pSegments[segmentLoop - 1] = URI:Decode(entry(segmentLoop, this-object:Path, '/':u)).
        end.
        
        return (segmentCnt - 1).
    end method.
    
    /* Sets the Path property from an array of segments. 
       
       Will %-encode the segment values
       Empty/blank segments are ignored
       
       @param character[] An array of path segments. */
    method public void SetPath(input pcSegments as character extent):
        define variable segmentCnt  as integer   no-undo.
        define variable segmentLoop as integer   no-undo.
        define variable slashPos    as integer   no-undo.
        define variable path        as character no-undo.
        define variable segment     as character no-undo.
        define variable pathDelim as character no-undo.
        
        assign segmentCnt = extent(pcSegments)
               pathDelim  = '':u.
        do segmentLoop = 1 to segmentCnt:
            assign segment = URI:EncodePath(pcSegments[segmentLoop]).            
            // Don't add empty segments
            if segment ne '':u then
                assign path      = '/':u when path eq '':u
                       path      = path + pathDelim + segment
                       pathDelim = '/':u
                       .
        end.
        
        assign this-object:Path = path.
    end method.

    /* Adds/appends a segment to the Path property 
       
       Will %-encode the segment value
       Empty/blank segments are ignored
       
       @param character A path segment */
    method public void AddPathSegment(input pcSegment as character):
        // unknown and empty values return empty, which we ignore
        assign pcSegment = URI:EncodePath(pcSegment).
        
        // Don't add empty segments
        if pcSegment ne '':u then
            assign this-object:Path = right-trim(this-object:Path, '/':u) + '/':u + pcSegment. 
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
        define variable lcValue as longchar no-undo.
        
        Assert:NotNullOrEmpty(pcName, 'Query name').
        
        /* flag URI as changed */
        assign mcUri   = ?
               lcValue = pcValue.
        
        this-object:QueryMap:Put(pcName, lcValue).
    end method.
    
    /* Removes a query parameter
       
       @param character The name of the query 
       @return logical TRUE if the named query existed (before removal) */
    method public logical RemoveQuery(input pcName as character):
        define variable hasQuery as logical no-undo.
        
        Assert:NotNullOrEmpty(pcName, 'Query name').
        
        assign hasQuery = this-object:QueryMap:ContainsKey(pcName).
        if hasQuery then
            this-object:QueryMap:Remove(pcName).
        
        return hasQuery.
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
        define variable cRootURI     as character no-undo.
        define variable cRelativeURI as character no-undo.
        define variable cPath        as character no-undo.
        define variable oIterator    as IIterator no-undo.
        define variable oEntry       as MapEntry  no-undo.
        define variable cDelimiter   as character no-undo.
        define variable cQueryString as character no-undo.
        
        assign cRootURI = substitute('&1://':u, this-object:Scheme).
        
        if this-object:User ne ? then
        do: 
            assign cRootURI = cRootURI + this-object:User.
            if this-object:Password ne ? then
                assign cRootURI = cRootURI + substitute(':&1':u, this-object:Password).
            assign cRootURI = cRootURI + '@':u.
        end.
        
        case mcHostType:
            when 'IPLIT':u then
                assign cRootURI = cRootURI + '[':u + this-object:Host + ']':u.
            otherwise
                assign cRootURI = cRootURI + this-object:Host.
        end case.
        
        if this-object:Port ne ? then
            assign cRootURI = cRootURI + substitute(':&1':u, this-object:Port).
        
        assign cPath = this-object:Path. 
        if this-object:QueryMap:Size gt 0 then
        do:
            assign cDelimiter   = '?':u
                   oIterator    = this-object:QueryMap:EntrySet:Iterator()
                   cQueryString = '':u. 
            do while oIterator:HasNext():
                assign oEntry       = cast(oIterator:Next(), MapEntry)
                       cQueryString = cQueryString + substitute('&1&2':u, cDelimiter, oEntry:Key:ToString())
                       cDelimiter   = '&':u.
                if     valid-object(oEntry:Value) 
                    and cast(oEntry:Value, OpenEdge.Core.String):Value ne ? then
                    assign cQueryString = cQueryString + substitute('=&1':u, oEntry:Value:ToString()).
            end.
        end.
        
        /* if there's no QueryMap string, then cQuery will be blank. */
        if cPath ne '':u or cQueryString ne '':u then 
            assign cRelativeURI = substitute('&1&2':u, cPath, cQueryString).
        
        if this-object:Fragment ne ? then
            assign cRelativeURI = substitute('&1#&2':u, cRelativeURI, this-object:Fragment).
        
        assign this-object:BaseURI     = cRootURI
               this-object:RelativeURI = cRelativeURI
               this-object:QueryString = cQueryString
               mcUri                   = substitute('&1&2':u, cRootURI, cRelativeURI)
               .
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
        return URI:EncodeURI(this-object).
    end method.
    
    /** Encodes a URI.
        
        @param URI The URI to encode
        @param character A character representaion of the URI */
    method static public character Encode(input poURI as URI):
        return URI:EncodeURI(poURI).
    end method.
    
    /** Encodes a URI.
        
        @param URI The URI to encode
        @param character A character representaion of the URI */
    method static public character EncodeURI (input poURI as URI):        
        define variable authority  as character no-undo.              
        define variable encodedUri as character no-undo.
        
        Assert:NotNull(poURI, 'URI').
        
        //scheme first 
        assign encodedUri = URI:EncodeScheme(poURI:Scheme) + '://':u.
        
        // authority: user, pw
        if poURI:User ne ? then
            assign encodedUri = encodedUri + poURI:EncodeUserinfo() + '@':u.
        
        // host
        assign encodedUri = encodedUri + poURI:EncodeHost().
        
        if poUri:Port ne ? then
            assign encodedUri = encodedUri + ':':u + string(poUri:Port).
        
        // path & query 
        assign encodedUri = encodedUri 
                          + poURI:Path      // assumed to be already-encoded
                          + poURI:EncodeQuery()
                          .
        // Fragment
        if poURI:Fragment ne ? then
            assign encodedUri = encodedUri + '#':u + URI:EncodeFragment(poUri:Fragment).
        
        return encodedUri.
    end method.
    
    /* Encodes this URI's scheme per URI Scheme encoding rules
       
       @return character An encoded string */
    method public character EncodeScheme():
        return URI:EncodeScheme(this-object:Scheme). 
    end method.
        
    /* Encodes a string per URI Scheme encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
       
       Scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeScheme(input pcString as character):
        return URI:EncodeString(pcString, ?, mEncFlag_Scheme, false). 
    end method.

    /* Encodes a string per URI Scheme encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
       
       Scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeScheme(input pString as String):
        return URI:EncodeString(pString:ToSTring(), pString:Encoding, mEncFlag_Scheme, false). 
    end method.
        
    /* Encodes a string per URI Host encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
        
       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Host       = *( unreserved / pct-encoded / sub-delims )
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeHost(input pcString as character):
        return URI:EncodeString(pcString, ?, mEncFlag_Host, false).
    end method.

    /* Encodes this uri's Host per URI Host encoding rules
       
       @return character An encoded string */
    method public character EncodeHost():
        case mcHostType:
            when 'IPLIT':u then
                return '[':u + URI:EncodeHost(this-object:Host) + ']':u.
            otherwise
                return URI:EncodeHost(this-object:Host).
        end case.
    end method.
    
    /* Encodes a string per URI userinfo encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
       
       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Host       = *( unreserved / pct-encoded / sub-delims / ":" )
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeUserinfo(input pString as String):
        return URI:EncodeString(pString:ToString(), pString:Encoding, mEncFlag_Userinfo, false).
    end method.
    
    /* Encodes a string per URI userinfo encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
        
       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Host       = *( unreserved / pct-encoded / sub-delims / ":" )
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeUserinfo(input pcString as character):
        return URI:EncodeString(pcString, ?, mEncFlag_Userinfo, false).
    end method.

    /* Encodes this uri's Host per URI Host encoding rules
       
       @return character An encoded string */
    method public character EncodeUserinfo():
        define variable authority as character no-undo.
        
        // authority: host, user, pw
        if this-object:User eq ? then
            return '':u.
        
        assign authority = URI:EncodeString(this-object:User, ?, mEncFlag_Host, false).
        if this-object:Password ne ? then
            assign authority = authority 
                             + ':':u
                             + URI:EncodeString(this-object:Password, ?, mEncFlag_Host, false).
        
        return authority.
    end method.
        
    /* Encodes a string per URI Host encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
        
       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Host       = *( unreserved / pct-encoded / sub-delims )
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeHost(input pString as String):
        return URI:EncodeString(pString:ToString(), pString:Encoding, mEncFlag_Host, false).
    end method.    
    
    /* Encodes a string per URI Path encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
        
       sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Path       = 1*( unreserved / pct-encoded / sub-delims / "@" )
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodePath(input pcString as character):
        return URI:EncodeString(pcString, ?, mEncFlag_Path, false).
    end method.
    
    /* Encodes a string per URI Path encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
        
       sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Path       = 1*( unreserved / pct-encoded / sub-delims / "@" )
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodePath(input pString as String):
        return URI:EncodeString(pString:ToString(), pString:Encoding, mEncFlag_Path, false).
    end method.
    
    /* Encodes this URI's Query string per URI Query  encoding rules. 
    
       @return character An encoded path string */
    method public character EncodeQuery():
        return URI:EncodeQuery(this-object).
    end method.
    
    /* Encodes a URI's Path string per URI Path encoding rules. 
       
       This is a separate method since we store the Path whole and
       so you cannot simply call EncodePath(uri:Path) since that 
       will encode the path delimiters that you need unencoded.
       
       @param URI A URI whose path to encode
       @return character An encoded path string */
    method static public character EncodeQuery(input poURI as URI):
        define variable encodedQuery as character no-undo.
        define variable qryString    as character no-undo.
        define variable qryNames     as character extent no-undo.
        define variable numQry       as integer   no-undo.
        define variable cnt          as integer   no-undo.
        define variable qryDelim     as character no-undo.
        
        Assert:NotNull(poURI, 'URI').
        
        // encode the queries
        assign qryDelim = '?':u
               numQry   = poURI:GetQueryNames(output qryNames)
               .
        do cnt = 1 to numQry:
            assign qryString = poURI:GetQueryValue(qryNames[cnt]).
            if qryString eq ? then
                assign qryString = qryNames[cnt].
            else
                assign qryString = qryNames[cnt] + '=':u + qryString.
            
            assign encodedQuery = encodedQuery + qryDelim + URI:EncodeQuery(qryString)
                   qryDelim     = '&':u
                   .
        end.
        
        return encodedQuery.
    end method.
    
    /* Encodes a string per URI Query encoding rules

       https://tools.ietf.org/html/rfc3986#page-11
        
       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
       pchar      = unreserved / pct-encoded / sub-delims / ":" / "@"
       Query      = *( pchar / "/" / "?" )
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeQuery(input pcString as character):
        return URI:EncodeString(pcString, ?, mEncFlag_Query, false).
    end method.
    
    /* Encodes a string per URI Query encoding rules

       https://tools.ietf.org/html/rfc3986#page-11
        
       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
       pchar      = unreserved / pct-encoded / sub-delims / ":" / "@"
       Query      = *( pchar / "/" / "?" )
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeQuery(input pString as String):
        return URI:EncodeString(pString:ToString(), pString:Encoding, mEncFlag_Query, false).
    end method.
    
    /* Encodes this URI's Fragment per URI Fragment encoding rules
       
       @return character An encoded string */
    method public character EncodeFragment():
        return URI:EncodeFragment(this-object:Fragment).
    end method.
    
    /* Encodes a string per URI Fragment encoding rules
        
        https://tools.ietf.org/html/rfc3986#page-11
        
        unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
        sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
        pchar        = unreserved / pct-encoded / sub-delims / ":" / "@"
        Fragment : fragment      = *( pchar / "/" / "?" )
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeFragment(input pcString as character):
        return URI:EncodeString(pcString, ?, mEncFlag_Fragment, false).
    end method.
    
    /* Encodes a string per URI Fragment encoding rules
        
        https://tools.ietf.org/html/rfc3986#page-11
        
        unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
        sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="    
        pchar        = unreserved / pct-encoded / sub-delims / ":" / "@"
        Fragment : fragment      = *( pchar / "/" / "?" )
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeFragment(input pString as String):
        return URI:EncodeString(pString:ToString(), pString:Encoding, mEncFlag_Fragment, false).
    end method.
        
    /* Encodes a string per Cookie encoding rules. This method is here for historical reasons.
       
       Cookie US-ASCII characters excluding CTLs, whitespace (32) DQUOTE (34), comma (44), semicolon (59), and backslash (92)       
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeCookie(input pcString as character):
        return URI:EncodeString(pcString, ?, mEncFlag_Cookie, false).
    end method.

    /* Encodes a string per Cookie encoding rules. This method is here for historical reasons.
       
       Cookie US-ASCII characters excluding CTLs, whitespace (32) DQUOTE (34), comma (44), semicolon (59), and backslash (92)       
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeCookie(input pString as String):
        return URI:EncodeString(pString:ToString(), pString:Encoding, mEncFlag_Cookie, false).
    end method.
    
    /* Encodes a string per URI Default encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
       Default  = unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeString(input pcString as character):
        return URI:EncodeString(pcString, ?, mEncFlag_Default, false). 
    end method.
    
    /* Encodes a string per URI Default encoding rules
       
       https://tools.ietf.org/html/rfc3986#page-11
       Default  = unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeString(input pString as String):
        return URI:EncodeString(pString:ToString(), pString:Encoding, mEncFlag_Default, false). 
    end method.
    
    /* Encodes a string per the input flags
       
       @param character    The string to encode
       @param character    The codepage of the input/source string
       @param logical[128] An array of flags indicating which ASCII chars to encode
       @param logical      TRUE if existing % values must be reencoded as %25
       @return character   The encoded string       */
    method static private character EncodeString(input pcString as character,
                                                 input pcSourceCodepage as character,
                                                 input pcEncodeFlags as logical extent 128,
                                                 input plReEncode as logical):
        define variable chrLoop       as integer   no-undo.
        define variable chrCnt        as integer   no-undo.
        define variable rawChar       as raw       no-undo.
        define variable codepoint     as integer   no-undo.
        define variable chrVal        as character no-undo.
        define variable encodedString as character no-undo.
        define variable byteLoop      as integer   no-undo.
        define variable byteCnt       as integer   no-undo.
        define variable rawByte       as raw       no-undo.
        
        /* Don't bother with blank or unknown. Unknown has no meaning outside of 
           ABL so just no-op it  */
        if    length(pcString) eq 0
           or pcString eq ? then
            return '':u.
        
        //determine or default the source codepage (for non-ascii characters)
        if    pcSourceCodepage eq ? 
           or pcSourceCodepage eq '':u then
            assign pcSourceCodepage = session:cpinternal.
            
        /* Loop through entire input string */
        assign chrCnt = length(pcString).
        do chrLoop = 1 to chrCnt:
            assign chrVal    = substring(pcString, chrLoop, 1)
                   // ASCII value of character using single byte codepage
                   codepoint = asc(chrVal)
                   .
            // percent-encoded 
            if     codepoint eq 37 
               and not plReEncode then
                assign chrVal  = substring(pcString, chrLoop, 3)
                       chrLoop = chrLoop + 2
                       . 
            else
            // outside of US-ASCII range gets pct-encoded
            if     codepoint ge 127
                or codepoint le 31
                or not pcEncodeFlags[codepoint + 1] then
            do:
                // Section 2.4 https://tools.ietf.org/html/rfc3986#section-2.4 describes how
                // to deal with unicode
                put-string(rawChar, 1) = codepage-convert(chrVal, 'utf-8':u, pcSourceCodepage).
                // PUT-STRING() adds a NULL\0x00 byte at the end; we don't want that in our pretty encoding 
                assign byteCnt = length(rawChar, 'raw':u) - 1
                       chrVal  = '':u.
                do byteLoop = 1 to byteCnt:
                    put-byte(rawByte, 1) = get-byte(rawChar, byteLoop).
                    /* Replace character with %hh hexidecimal triplet */
                    assign chrVal = chrVal + caps(substitute('%&1':u, hex-encode(rawByte))).
                end.
            end.
            /* add/create a new string because replacing 1 character with 2 messes up our math */
            assign encodedString = encodedString + chrVal.
        end.
        
        return encodedString.
    end method.

    /** Encodes a string for a particular purpose. Usage of Encode<encoding-type> is recommended. 
        The method does NOT re-encode % characters.
        
        @param character The string to encode
        @param EncondingTypeEnum The type of encoding to apply
        @return character the encoded string */
    method static public character Encode(input pcString as character, 
                                          input poEncodingType as UriEncodingTypeEnum):
        return URI:Encode(pcString, poEncodingType, false).
    end method.
    
    /** Encodes a string for a particular purpose. Usage of Encode<encoding-type> is recommended, 
        unless the re-encoding of % characters is desired.
        
        @param character The string to encode
        @param EncondingTypeEnum The type of encoding to apply
        @param logical TRUE if any percent characters should  be encoded as %25
        @return character the encoded string */
    method static public character Encode(input pString as character, 
                                          input pEncodingType as UriEncodingTypeEnum,
                                          input pReEncode as logical):
        /* Don't bother with blank or unknown  */
        if length(pString) eq 0 or pString eq ? then
            return '':u.
        
        /* What kind of encoding should be used? */
        case pEncodingType:
            when UriEncodingTypeEnum:Scheme   then return URI:EncodeString(pString, session:cpinternal, mEncFlag_Scheme,   pReEncode).
            when UriEncodingTypeEnum:Host     then return URI:EncodeString(pString, session:cpinternal, mEncFlag_Host,     pReEncode).
            when UriEncodingTypeEnum:Path     then return URI:EncodeString(pString, session:cpinternal, mEncFlag_Path,     pReEncode).
            when UriEncodingTypeEnum:Query    then return URI:EncodeString(pString, session:cpinternal, mEncFlag_Query,    pReEncode).
            when UriEncodingTypeEnum:Fragment then return URI:EncodeString(pString, session:cpinternal, mEncFlag_Fragment, pReEncode).
            when UriEncodingTypeEnum:Cookie   then return URI:EncodeString(pString, session:cpinternal, mEncFlag_Cookie,   pReEncode).
            otherwise                              return URI:EncodeString(pString, session:cpinternal, mEncFlag_Default,  pReEncode).
        end case.
    end method.
    
    /** Attempts to decode a previously-encoded URL.        
        
        @return character A decoded URL */
    method public character Decode():
        return OpenEdge.Net.URI:Decode(this-object:ToString()).
    end method.
    
    /** Attempts to decode a previously-encoded string.
        
        @param  character The string to decode
        @return character A decoded URL 
        @throws AppError If the encoding is malformed */
    method static public character Decode(input pcEncodedString as character):
        return URI:Decode(pcEncodedString, ?).
    end method.

    /** Attempts to decode a previously-encoded string.
        
        @param  String The string to decode
        @throws AppError If the encoding is malformed */
    method static public character Decode(input pString as String):
        return URI:Decode(pString:ToString(), pString:Encoding). 
    end method.    
    
    /** Attempts to decode a previously-encoded string.
        
        @param  character The string to decode
        @param  character The target codepage to encode into. Defaults to CPINTERNAL
        @return character A decoded URL 
        @throws AppError If the encoding is malformed */
    method static public character Decode(input pEncodedString as character,
                                          input pTargetCodepage as character):
        define variable decodedString as character no-undo.
        define variable loop as integer no-undo.
        define variable pctPos as integer no-undo.
        define variable hexChar as character no-undo.
        define variable numBytes as integer no-undo.
        define variable startAt as integer no-undo.
        define variable rawChar as raw no-undo.
        define variable decodedChar as character no-undo.
        define variable codepoint     as integer   no-undo.

        if    pEncodedString eq ? 
           or pEncodedString eq '':u then
            return pEncodedString.           
        
        if    pTargetCodepage eq ? 
           or pTargetCodepage eq '':u then
            assign pTargetCodepage = session:cpinternal.
        
        assign startAt = 1
               pctPos  = index(pEncodedString, '%':u, startAt)
               .
        do while pctPos gt 0:
            assign // chop off stuff before the %
                   decodedString = decodedString + substring(pEncodedString, startAt, (pctPos - startAt))
                   
                   hexChar   = substring(pEncodedString, pctPos + 1, 2)
                   rawChar   = hex-decode(hexChar)
                   codepoint = get-byte(rawChar, 1)
                   .
            // US-ASCII, excluding NULL
            // 0 < codepoint < 128
            if (0 lt codepoint and codepoint le 128) then
                assign numBytes    = 1
                       decodedChar = chr(codepoint)
                       startAt     = pctPos + 3
                       .
            else
            // UTF-8 (two byte)
            // 192 <= codepoint < 224
            if (192 le codepoint and codepoint lt 224) then
                assign numBytes = 2.
            else
            // UTF-8 (three byte)
            // 24 <= codepoint < 240
            if (224 le codepoint and codepoint lt 240) then
                assign numBytes = 3.
            else
            // UTF-8 (three byte)
            // 240 <= codepoint < 248
            if (240 le codepoint and codepoint lt 248) then
                assign numBytes = 4.
            else
            // MALFORMED
                assign numBytes = -1.
            
            if numBytes gt 1 then
            do:
                assign length(rawChar) = numBytes
                       // we've got the first byte in codepoint already 
                       pctPos   = pctPos + 3
                       .
                put-byte(rawChar, 1) = codepoint.
                do loop = 2 to numBytes:
                    assign hexChar   = substring(pEncodedString, pctPos + 1, 2)
                           codepoint = get-byte(hex-decode(hexChar), 1)
                           pctPos    = pctPos + 3
                           .
                    // 128 <= codepoint < 192
                    if 128 le codepoint and codepoint lt 192 then
                        put-byte(rawChar, loop) = codepoint.
                    else
                        assign numBytes = -1.
                end.
                
                if numBytes gt 0 then
                    assign decodedChar = codepage-convert(get-string(rawChar, 1, numBytes),
                                                          pTargetCodepage,
                                                          'utf-8':u)
                           startAt     = pctPos.
            end.    //UTF-8
            
            // Malformed data
            if numBytes eq -1 then
                return error new AppError(substitute('Cannot decode malformed string &1', pEncodedString), 0).
            else
                assign decodedString = decodedString + decodedChar
                       pctPos        = index(pEncodedString, '%':u, startAt)
                       .
        end.
        
        /* add anycharacters that appear after the last % */
        return decodedString + substring(pEncodedString, startAt).
    end method.
    
    /** Returns an array of query names 
        @param character[] An array
        @return integer The number */
    method public integer GetQueryNames(output pcNames as character extent):
        define variable iCount    as integer   no-undo.
        define variable oIterator as IIterator no-undo.
        
        assign iCount    = this-object:QueryMap:Size
               oIterator = cast(this-object:QueryMap:KeySet, IIterable):Iterator()
               .
        if iCount gt 0 then
            assign extent(pcNames) = iCount.
        
        assign iCount = 0.
        do while oIterator:HasNext():
            assign pcNames[iCount + 1] = oIterator:Next():ToString()
                   iCount              = iCount + 1. 
        end.
        
        return iCount.
    end method.
    
end class.