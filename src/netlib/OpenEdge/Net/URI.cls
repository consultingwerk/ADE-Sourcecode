/**********************************************************************************
Copyright (c) 2014-2019, 2021-2022 by Progress Software Corporation. All rights reserved.
************************************************************************************/
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
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.String.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriEncoder.
using OpenEdge.Net.UriEncodingTypeEnum.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Collections.List.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.URI serializable:

    /* The _PART are the indexes for the URI parts produced by the SplitUri() method */
    define static public property SCHEME_PART_IDX       as integer no-undo initial 1 get.
    define static public property AUTHORITY_PART_IDX    as integer no-undo initial 2 get.
    define static public property PATH_PART_IDX         as integer no-undo initial 3 get.
    define static public property QUERY_PART_IDX        as integer no-undo initial 4 get.
    define static public property FRAGMENT_PART_IDX     as integer no-undo initial 5 get.
    
    /* This instance takes care of all URI-related encoding and decoding
       This is a static property because the of URI's many static Encode*() methods.
       It is a property specifically because the Procedure Editor deletes things willy-nilly. */
    define static private property Encoder as UriEncoder no-undo
        get():
            if not valid-object(Encoder) then
                assign Encoder = new UriEncoder().
            
            return Encoder.
        end get.
        set.
    
    /* internal string representation of this object. we don't really want to build it
       every time we need it */
    define private variable mcUri as character no-undo.
    
    /** (mandatory) The schema of the URI (ie http, https etc) */
    define public property Scheme as character no-undo get. private set.
    
    /** (mandatory) The host name*/
    define public property Host as character no-undo
        get.
        private set.
    
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
        here. Use EncodePath() on each /-delimited path segment before setting
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
            if pcFragment eq ? then
                assign pcFragment = '':u.
            
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
    
    /** Returns a relative URI (path, query params, et al) */
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

    /** [Deprecated] A map of QueryMap arguments (now a wrapper to QueryParams) */
    define protected property QueryMap as IStringStringMap no-undo
        get():
            // Convert the QueryParams object into the expected QueryMap format.
            return this-object:ConvertToQueryMap(this-object:QueryParams).
        end get.

    /** A map of Query Parameters with values in a List<String>. Set these value via AddQuery() */
    define private variable QueryParams as IStringKeyedMap no-undo.

    /* Static constructor */
    constructor static URI():
        assign encoder = new UriEncoder().
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
        this-object(pcScheme, pcHost, ?, '/':u, new StringKeyedMap(), '':u).
    end constructor.

    /** Constructor.
      
        @param character The scheme for this URI.
        @param character The host name.
        @param integer The port to use. */
    constructor public URI(input pcScheme as character,
                           input pcHost as character,
                           input piPort as integer):
        this-object(pcScheme, pcHost, piPort, '/':u, new StringKeyedMap(), '':u).
    end constructor.

    /** Constructor.
        
        @param character The scheme for this URI
        @param character The authority (contains at least host, and potentially port, user, passwd)
        @param character The path
        @param character The query string
        @param character The fragment */
    constructor public URI(input pScheme as character,
                           input pAuthority as character,
                           input pPath as character,
                           input pQuery as character,
                           input pFragment as character):
        Assert:NotNullOrEmpty(pScheme, 'URI Scheme').
        
        assign this-object:Scheme      = pScheme
               this-object:QueryParams = new StringKeyedMap() // Contains values as a List<String>.
               mcUri                   = ?
               .
        SetAuthority(pAuthority, true). //decode?
        SetPath(pPath).
        
        // Finally add the fragment
        assign this-object:Fragment = pFragment.
        
        AddQueryString(pQuery, true).   //Decode
    end constructor.

    /** Constructor [Deprecated].
       
        @param character The scheme for this URI.
        @param character The host name.
        @param integer The port to use.
        @param character The path
        @param IStringStringMap the (deprecated) QueryMap arguments
        @param character The fragment, if any */
    constructor public URI (input pcScheme   as character,
                            input pcHost     as character,
                            input piPort     as integer,
                            input pcPath     as character,
                            input poQueryMap as IStringStringMap,
                            input pcFragment as character):
        Assert:NotNullOrEmpty(pcScheme, 'Scheme').
        Assert:NotNullOrEmpty(pcHost, 'Host').
        Assert:NotNull(poQueryMap, 'QueryMap').
        Assert:NotNullOrEmpty(pcPath, 'Path').
        
        assign this-object:Scheme      = pcScheme
               this-object:Host        = pcHost
               this-object:QueryParams = this-object:ConvertToQueryParams(poQueryMap)
               this-object:Port        = piPort
               this-object:Path        = pcPath
               this-object:Fragment    = pcFragment
               this-object:User        = ?
               this-object:Password    = ?
               this-object:RelativeURI = ?
               mcUri                   = ?
               .
    end constructor.

    /** Constructor.
       
        @param character The scheme for this URI.
        @param character The host name.
        @param integer The port to use.
        @param character The path
        @param IStringKeyedMap the QueryParams arguments
        @param character The fragment, if any */
    constructor public URI (input pcScheme      as character,
                            input pcHost        as character,
                            input piPort        as integer,
                            input pcPath        as character,
                            input poQueryParams as IStringKeyedMap,
                            input pcFragment    as character):
        Assert:NotNullOrEmpty(pcScheme, 'Scheme').
        Assert:NotNullOrEmpty(pcHost, 'Host').
        Assert:NotNull(poQueryParams, 'QueryParams').
        Assert:NotNullOrEmpty(pcPath, 'Path').
        
        assign this-object:Scheme      = pcScheme
               this-object:Host        = pcHost
               this-object:QueryParams = poQueryParams
               this-object:Port        = piPort
               this-object:Path        = pcPath
               this-object:Fragment    = pcFragment
               this-object:User        = ?
               this-object:Password    = ?
               this-object:RelativeURI = ?
               mcUri                   = ?
               .
    end constructor.

    /** Convert a legacy QueryMap (StringStringMap) to the QueryParams (StringKeyedMap) structure

        @param IStringStringMap A QueryMap structured object
        @return IStringKeyedMap A QueryParams compatible object */
    method private IStringKeyedMap ConvertToQueryParams (input pQueryMap as IStringStringMap):
        var IStringKeyedMap oKeyedMap.
        var IIterator iter.
        var MapEntry me.

        Assert:NotNull(pQueryMap, 'Query map').

        // Create the new map object.
        assign oKeyedMap = new StringKeyedMap().

        // Iterate over the QueryMap to get key/value pairs.
        assign iter = pQueryMap:EntrySet:Iterator().
        do while iter:HasNext():
            assign me = cast(iter:Next(), MapEntry).

            // Create a new List for key if not present.
            if not oKeyedMap:ContainsKey(me:Key) then
                oKeyedMap:Put(me:Key, new List<String>()).

            // Add the value as a String in the List.
            cast(oKeyedMap:Get(me:Key), List<String>):Add(cast(me:Value, String)).
        end. // do while

        return oKeyedMap.
    end method.

    /** Convert a QueryParams (StringKeyedMap) to the legacy QueryMap (StringStringMap) structure

        @param IStringKeyedMap A QueryParams structured object
        @return IStringStringMap A QueryMap compatible object */
    method private IStringStringMap ConvertToQueryMap (input pQueryParams as IStringKeyedMap):
        var IStringStringMap oStringMap.
        var IIterator iter.
        var MapEntry me.
        var List<String> sl.

        Assert:NotNull(pQueryParams, 'Query params').

        // Create the new map object.
        assign oStringMap = new StringStringMap().

        // Iterate over the pQueryParams to get key/value pairs.
        assign iter = pQueryParams:EntrySet:Iterator().
        do while iter:HasNext():
            assign me = cast(iter:Next(), MapEntry).

            // Add the last item of the List<String> as a new value of the String Map.
            // This is meant to maintain existing behavior of the original QueryMap object
            // which only retained the last value for multiple occurences of a param name.
            if valid-object(me:Value) then do:
                assign sl = cast(me:Value, List<String>). // Get the String List from the MapEntry.
                oStringMap:Put(me:Key, sl:Get(sl:Count)). // Add value as a string (even if unknown).
            end. // valid-object
        end. // do while

        return oStringMap.
    end method.

    /** Parses a string containing a URI and creates a URI object from it
    
        @param character a string URI (eg http://www.progress.com/)
        @return URI A URI (object) representation of the string. */
    method static public URI Parse (input pcURI as character):
        return URI:Parse(pcURI, true).
    end method.
    
    /* Parses this URI into its component parts.
       
       @return character[] An array of component parts
                            [1] scheme (http/https)
                            [2] authority (host:port)
                            [3] path
                            [4] query
                            [5] fragment        */
    method public character extent Split ( ):
        define variable uriParts as character extent 5 no-undo.
        
        if mcUri eq ? then
            BuildUri().
        
        assign uriParts[SCHEME_PART_IDX]    = string(this-object:Scheme)
               uriParts[PATH_PART_IDX]      = this-object:Path
               uriParts[QUERY_PART_IDX]     = substring(this-object:QueryString, 2) // has a leading ?
               uriParts[FRAGMENT_PART_IDX]  = this-object:Fragment
               .
        // authority is a little more complex
        if not this-object:User eq ? then
        do:
            assign uriParts[AUTHORITY_PART_IDX] = uriParts[AUTHORITY_PART_IDX] + this-object:User.
            if not this-object:Password eq ? then
                assign uriParts[AUTHORITY_PART_IDX] = uriParts[AUTHORITY_PART_IDX] + substitute(':&1':u, this-object:Password).
            assign uriParts[AUTHORITY_PART_IDX] = uriParts[AUTHORITY_PART_IDX] + '@':u.
        end.
        
        assign uriParts[AUTHORITY_PART_IDX] = uriParts[AUTHORITY_PART_IDX] + this-object:Host.
        
        if not this-object:Port eq ? then
            assign uriParts[AUTHORITY_PART_IDX] = substitute('&1:&2':u, uriParts[AUTHORITY_PART_IDX], this-object:Port).
        
        return uriParts.
    end method.
    
    /* Parses an potentially-URI-containing string into URI component parts.
       
       This method will not fail, and will return empty values for an element of the
       URI if the string cannot be parsed or fails to parse somehow. So if the string contains
            http//example.com
       the auhority will be 'example.com' and the scheme empty (since there's no :).
       
       @param  character A string URI (or part thereof)
       @return character[] An array of component parts
                            [1] scheme (http/https)
                            [2] authority (host:port)
                            [3] path
                            [4] query
                            [5] fragment        */
    method static public character extent SplitUri (input pData as character):
        define variable uriParts as character extent 5 no-undo initial ['':u,'':u,'':u,'':u,'':u].
        define variable chrPos as integer no-undo.
        define variable chrPos2 as integer no-undo.
        
        if String:IsNullOrEmpty(pData) then
            return uriParts.
        
        //extract the fragment and URI before processing the /-delimited stuff   the fragment is always the last element
        // of the URI per the spec: URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ] - so we cut that off first,
        // then the query. The 'heir-part' consists of
        // hier-part  = "//" authority path-abempty
        //              / path-absolute
        //              / path-rootless
        //              / path-empty
        assign chrPos = index(pData, '#':u).
        if chrPos gt 0 then
            assign uriParts[FRAGMENT_PART_IDX] = substring(pData, chrPos + 1)
                   pData                       = substring(pData, 1,        chrPos - 1)
                   .
        // extract the query, if any
        assign chrPos = index(pData, '?':u).
        if chrPos gt 0 then
            assign uriParts[QUERY_PART_IDX] = substring(pData, chrPos + 1)
                   pData                    = substring(pData, 1,        chrPos - 1)
                   .
        // the colon indicates the scheme delimiter
        assign chrPos = index(pData, ':':u).
        if chrPos gt 0 then
            assign uriParts[SCHEME_PART_IDX] = substring(pData, 1,    chrPos - 1)
                   pData                     = substring(pData, chrPos + 1)
                   .
        // use double-slashes to get the authority
        assign chrPos  = index(pData, '//':u)
               chrPos2 = index(pData, '/':u, chrPos + 2)
               .
        if chrPos gt 0 then
        do:
            if chrPos2 eq 0 then
                assign uriParts[AUTHORITY_PART_IDX] = substring(pData, chrPos + 2)
                       pData                        = '':u
                       .
            else
                assign uriParts[AUTHORITY_PART_IDX] = substring(pData, chrPos + 2, chrPos2 - (chrPos + 2))
                       // keep the leading slash
                       pData                        = substring(pData, chrPos2)
                       .
        end.
        
        //paths are what's left
        assign uriParts[PATH_PART_IDX] = pData.
        
        return uriParts.
    end method.
    
    /* Sets this URI's complete Path, replacing the existing path.
       
       @param character The complete to add */
    method protected void SetPath (input pPath as character):
        define variable delim as character no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable cpath as character no-undo.
        define variable segment as character no-undo.
        
        if not String:IsNullOrEmpty(pPath) then
            assign delim = '':u
                   cnt   = num-entries(pPath, '/':u)
                   cpath = '':u
                   .
        do loop = 1 to cnt:
            assign segment = entry(loop, pPath, '/':u)
                   cpath   = cpath + delim
                             // encode the paths (especially for unicode chars); leave any %-encoding alone though
                             + encoder:EncodePath(segment)
                             
                   delim   = '/':u
                   .
        end.
        
        //we need at least a "/" in order to set the Path property
        if cpath eq '':u then
            assign this-object:Path = '/':u.
        else
            // if there's no leading / then the setting of the Path property will provide one
            assign this-object:Path = cpath.
    end method.
    
    /* Adds a URI's authority components to this instance
       
       @param character The authority to add
       @param logical TRUE if the authority needs to be decoded */
    method protected void SetAuthority(input pAuthority as character,
                                       input pDecode as logical):
        define variable iPort as integer no-undo.
        define variable cHost as character no-undo.
        define variable chrPos as integer no-undo.
        define variable usr as character no-undo.
        define variable passwd as character no-undo.
        
        Assert:NotNullOrEmpty(pAuthority, 'URI Authority').
        
        // default is to DECODE
        if pDecode eq ? then
            assign pDecode = true.
        
        if pDecode then
            assign pAuthority = encoder:Decode(pAuthority).
        
        /* get username/password out of real host */
        assign chrPos = r-index(pAuthority, '@':u).
        if chrPos eq 0 then
            assign usr    = ?
                   passwd = ?
                   .
        else
        do:
            assign usr        = substring(pAuthority, 1, chrPos - 1)
                   passwd     = ?
                   pAuthority = substring(pAuthority, chrPos + 1)
                   chrPos     = index(usr, ':':u)
                   .
            if chrPos gt 0 then
                assign passwd = substring(usr, chrPos + 1)
                       usr    = substring(usr, 1, chrPos - 1)
                       .
        end.
        
        // IPv6 addesses contain : so look for the right-most after any ]
        assign chrPos = r-index(pAuthority, ']':u)
               chrPos = index(pAuthority, ':':u, max(1, chrPos))
               .
        if chrPos eq 0 then
            assign iPort = ?
                   cHost = pAuthority
                   .
        else
            /* port first, else we lose it */
            assign iPort = integer(substring(pAuthority, chrPos + 1))
                   cHost = substring(pAuthority, 1, chrPos - 1)
                   .
        
        assign this-object:Host     = cHost
               this-object:Port     = iPort
               this-object:User     = usr
               this-object:Password = passwd
               .
    end method.
    
    /** Parses a string containing a URI's QUERY and adds it to this URI
        
        @param character A query string
        @param logical TRUE if the incoming strings should be URL-decoded */
    method public void AddQueryString(input pQuery as character,
                                      input pDecode as logical):
        define variable qryPart as character no-undo.
        define variable qryVal as character no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable chrPos as integer no-undo.
        
        // nothing here
        if    pQuery eq ?
           or pQuery eq '':u
        then
            return.
        
        // default is to DECODE
        if pDecode eq ? then
            assign pDecode = true.
        
        assign qryVal = '':u
               cnt    = num-entries(pQuery, '&':u)
               .
        QUERY-STRING-LOOP:
        do loop = 1 to cnt:
            assign qryPart = entry(loop, pQuery, '&':u)
                   chrPos  = index(qryPart, '=':u)
                   .
            if qryPart eq '':u then
                next QUERY-STRING-LOOP.
            
            if chrPos eq 0 then
                assign chrPos = index(qryPart, ';':u).
            
            if chrPos eq 0 then
            do:
                if pDecode then
                    assign qryPart = encoder:Decode(qryPart).
                this-object:AddQuery(qryPart).
            end.
            else
            do:
                assign qryVal = substring(qryPart, chrPos + 1)
                       no-error.
                if qryVal eq ? then
                    assign qryVal = '':u.
                else
                if pDecode then
                    assign qryVal = encoder:Decode(qryVal).
                
                // query-name
                assign qryPart = substring(qryPart, 1, chrPos - 1).
                if pDecode then
                    assign qryPart = encoder:Decode(qryPart).
                this-object:AddQuery(qryPart, qryVal).
            end.
        end.
        finally:
            assign error-status:error = false.
        end finally.
    end method.
    
    /** Parses a string containing a URI and creates a URI object from it
        
        @param character a string URI (eg http://www.progress.com/)
        @param logical TRUE if the incoming strings should be URL-decoded
        @return URI A URI (object) representation of the string. */
    method static public URI Parse(input pcURI as character,
                                   input pDecode as logical):
        define variable uriParts as character extent 5 no-undo.
        define variable newURI as URI no-undo.
        
        Assert:NotNullOrEmpty(pcURI, 'URI string').
        
        // default is to DECODE
        if pDecode eq ? then
            assign pDecode = true.
        
        // Missing parts are represented by empty/blank strings
        assign uriParts = SplitUri(pcURI).
        
        /* No scheme. Default to HTTP */
        if uriParts[SCHEME_PART_IDX] eq '':u then
            assign uriParts[SCHEME_PART_IDX] = string(UriSchemeEnum:http).
        
        /* we need at least a schema and an authority/host for this to be a decent URL */
        if    uriParts[SCHEME_PART_IDX] eq '':u
           or uriParts[AUTHORITY_PART_IDX] eq '':u
        then
            undo, throw new AppError(substitute('Unable to parse malformed URI: &1', pcURI), 0).
        
        // don't decode the path and query as a whole, since we need to split those into their
        // component parts first
        // Don't decode the path , since the decoded values may contain slashes
        if pDecode then
            assign uriParts[SCHEME_PART_IDX]    = encoder:Decode(uriParts[SCHEME_PART_IDX])
                   uriParts[AUTHORITY_PART_IDX] = encoder:Decode(uriParts[AUTHORITY_PART_IDX])
                   uriParts[FRAGMENT_PART_IDX]  = encoder:Decode(uriParts[FRAGMENT_PART_IDX])
                   .
        // Build a URI from the component parts
        assign newURI = new URI(uriParts[SCHEME_PART_IDX],
                                uriParts[AUTHORITY_PART_IDX],
                                uriParts[PATH_PART_IDX],
                                ?,  // don't pass in the query string
                                uriParts[FRAGMENT_PART_IDX]).
        
        // the constructor always decodes the query string, regardless of what's passed in here
        //  Calling AddQueryString() respects that value
        newURI:AddQueryString(uriParts[QUERY_PART_IDX], pDecode).
        
        return newURI.
    end method.
    
    /* Helper method to return the path as an array of segments.
       
       @param character[] A character extent of path segments
       @return integer The count of path segments */
    method public integer GetPathSegments(output pSegments as character extent):
        define variable segmentCnt  as integer no-undo.
        define variable segmentLoop as integer no-undo.
        
        // There is always at least one slash, so start at 2.
        assign segmentCnt        = num-entries(this-object:Path, '/':u)
               extent(pSegments) = segmentCnt - 1
               .
        do segmentLoop = 2 to segmentCnt:
            assign pSegments[segmentLoop - 1] = encoder:Decode(entry(segmentLoop, this-object:Path, '/':u)).
        end.
        
        return (segmentCnt - 1).
    end method.
    
    /* Sets the Path property from an array of segments.
       
       Will %-encode the segment values
       Empty/blank segments are ignored
       Dotted paths are added as-is
       
       @param character[] An array of path segments. */
    method public void SetPath (input pcSegments as character extent):
        define variable segmentCnt  as integer   no-undo.
        define variable segmentLoop as integer   no-undo.
        define variable cPath       as character no-undo.
        define variable segment     as character no-undo.
        define variable pathDelim   as character no-undo.
        
        assign segmentCnt = extent(pcSegments)
               pathDelim  = '':u.
        SEGMENT-LOOP:
        do segmentLoop = 1 to segmentCnt:
            assign segment = encoder:EncodePath(pcSegments[segmentLoop]).
            // Don't add empty segments
            case segment:
                // skip empty paths
                when '':u then
                    next SEGMENT-LOOP.
                otherwise
                    assign cPath     = '/':u when cPath eq '':u
                           cPath     = cPath + pathDelim + segment
                           pathDelim = '/':u
                           .
            end case.
        end.
        
        assign this-object:Path = cPath.
    end method.
    
    /* Adds/appends a segment to the Path property
       
       Will %-encode the segment value
       Empty/blank segments are ignored
       
       @param character A path segment */
    method public void AddPathSegment (input pcSegment as character):
        // unknown and empty values return empty, which we ignore
        assign pcSegment = encoder:EncodePath(pcSegment).
        
        // Don't add empty segments
        if pcSegment ne '':u then
            assign this-object:Path = right-trim(this-object:Path, '/':u) + '/':u + pcSegment.
    end method.
    
    /** Adds a name-only QueryParams entry. Equivalent to calling AddQuery(pcname, ?).
    
        @param character The query parameter name */
    method public void AddQuery (input pcName as character):
        AddQuery(pcName, ?).
    end method.
    
    /** Adds a query argument (name/value pair)
        
        @param character The query parameter name
        @param character The query parameter value */
    method public void AddQuery (input pcName  as character,
                                 input pcValue as character):
        define variable lcValue as longchar no-undo.
        
        Assert:NotNullOrEmpty(pcName, 'Query name').
        
        /* flag URI as changed */
        assign mcUri = ?.
        if pcValue eq ? then
           assign lcValue = ?.
        else
           assign lcValue = encoder:EncodeQuery(pcValue).

        // Create a new list for values of key (pcName).
        if not this-object:QueryParams:ContainsKey(pcName) then
            this-object:QueryParams:Put(pcName, new List<String>()).

        // Add the value as a new element of the array for this key.
        cast(this-object:QueryParams:Get(pcName), List<String>):Add(new String(lcValue)).
    end method.
    
    /* Removes a query parameter and its value(s)
       
       @param character The name of the query parameter
       @return logical TRUE if the named query parameter existed (before removal) */
    method public logical RemoveQuery (input pcName as character):
        define variable hasQuery as logical no-undo.
        
        Assert:NotNullOrEmpty(pcName, 'Query name').

        assign hasQuery = this-object:QueryParams:ContainsKey(pcName).
        if hasQuery then
            this-object:QueryParams:Remove(pcName).

        return hasQuery.
    end method.
    
    /** Returns a count of query values for a given parameter name

        @param character The query parameter name
        @return integer The count of query parameter values */
    method public integer GetQueryValueCount (input pcName as character):
        define variable val as longchar no-undo.
        
        Assert:NotNullOrEmpty(pcName, 'Query name').

        if not QueryParams:ContainsKey(pcName) then
            return 0.

        return cast(QueryParams:Get(pcName), List<String>):Count.
    end method.

    /** Get a character value from the query
        Deprecated, use GetQueryValues to return all potential query values

        @param character The query parameter name
        @return character The query value (decoded) */
    method public character GetQueryValue (input pcName as character):
        var character[] vals.

        Assert:NotNullOrEmpty(pcName, 'Query name').

        vals = this-object:GetQueryValues(pcName).
        
        if extent(vals) eq ? then return ?.

        // For backwards compatibility, return the last decoded element
        return vals[extent(vals)].
    end method.

    /** Get all character values from the query

        @param character The query parameter name
        @return character[] The query values (decoded) as an extent */
    method public character extent GetQueryValues (input pcName as character):
        var List<String> original.
        var character[] decoded.
        var integer iCount, iLoop.

        Assert:NotNullOrEmpty(pcName, 'Query name').

        // If the query parameter exists, extract and decode the values.
        if QueryParams:ContainsKey(pcName) then do:
            assign original = cast(QueryParams:Get(pcName), List<String>).
            assign iCount = original:Count.
            if iCount gt 0 then do:
                // Proceed with setting extent and looping when count is non-zero.
                extent(decoded) = iCount.
                do iLoop = 1 to iCount:
                    // When calling AddQuery() we always encode the value, so decode it now (stored as a new String).
                    decoded[iLoop] = encoder:Decode(string(original:Get(iLoop))).
                end.
            end.
        end.

        return decoded. // New character extent of decoded values.
    end method.

    /** Get all character values from the query

        @param character The query parameter name
        @return List<String> The query values as a List<String> object */
    method public List<String> GetQueryValueList (input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Query name').

        // If the query parameter exists, extract and decode the values.
        if QueryParams:ContainsKey(pcName) then do:
            return cast(QueryParams:Get(pcName), List<String>).
        end.

        return (new List<String>()). // At least return an empty List.
    end method.

    /** [Deprecated] Gets the complete set of query names and values. The map returned is
        a new mapping of this URI's query params (as string values)
        
        @return IStringStringMap A map of query names and values (as longchar's) */
    method public IStringStringMap GetQueryMap ():
        return this-object:ConvertToQueryMap(this-object:QueryParams).
    end method.
        
    /** Gets the complete set of query names and values. The map returned is
        a deep copy/clone of this URI's query params (List<String>)
        
        @return IStringKeyedMap A map of query names and values (as List<String>) */
    method public IStringKeyedMap GetQueryParams ():
        return new StringKeyedMap(this-object:QueryParams).
    end method.

    /** Sets (merges) a set of query names and values into this URI
        
        @param IStringStringMap A map of query names and values (as longchar's) */
    method public void SetQueryMap (input pQueryMap as IStringStringMap ):
        var IStringKeyedMap newMap.

        if     valid-object(pQueryMap)
           and pQueryMap:Size gt 0
        then
            newMap = this-object:ConvertToQueryParams(pQueryMap).

        this-object:SetQueryParams(newMap).
    end method.

    /** Sets (merges) a set of query names and values into this URI
        Does not perform a check for duplicates among parameter values!
        
        @param IStringKeyedMap A map of query names and values (array of String objects) */
    method public void SetQueryParams (input pQueryParams as IStringKeyedMap ):
        var IIterator iter.
        var MapEntry me.
        var List<String> queryList.

        if     valid-object(pQueryParams)
           and pQueryParams:Size gt 0
        then do:
            assign iter = pQueryParams:EntrySet:Iterator().
            do while iter:HasNext():
                assign me = cast(iter:Next(), MapEntry).
    
                // Use the given list for key if not present in QueryParams.
                if not this-object:QueryParams:ContainsKey(me:Key) then
                    this-object:QueryParams:Put(me:Key, me:Value).
                else do:
                    // Otherwise, merge incoming list to the existing param list.
                    assign queryList = cast(this-object:QueryParams:Get(me:Key), List<String>).
                    queryList:AddAll(cast(me:Value, List<String>)). // No dupe check with AddAll!
                end.
            end. // do while
        end.
    end method.

    /* Constructs a string representation */
    method private void BuildUri ():
        var character cRootURI, cRelativeURI, cPath, cDelimiter, cQueryString.
        var IIterator oIterator.
        var MapEntry oEntry.
        var List<String> sl.
        var integer iCount, iLoop.
        var character paramVal.
        
        assign cRootURI = substitute('&1://':u, this-object:Scheme).
        
        if this-object:User ne ? then
        do:
            assign cRootURI = cRootURI + encoder:EncodeUserinfo(this-object:User).
            if this-object:Password ne ? then
                assign cRootURI = cRootURI + substitute(':&1':u, encoder:EncodeUserinfo(this-object:Password)).
            assign cRootURI = cRootURI + '@':u.
        end.
        
        assign cRootURI = cRootURI + this-object:Host.
        
        if this-object:Port ne ? then
            assign cRootURI = cRootURI + substitute(':&1':u, this-object:Port).
        
        assign cPath = this-object:Path.
        if this-object:QueryParams:Size gt 0 then
        do:
            assign cDelimiter   = '?':u
                   oIterator    = this-object:QueryParams:EntrySet:Iterator()
                   cQueryString = '':u
                   .

            do while oIterator:HasNext():
                assign oEntry = cast(oIterator:Next(), MapEntry).

                assign sl = cast(oEntry:Value, List<String>).
                assign iCount = sl:count.
                do iLoop = 1 to iCount:
                    assign paramVal = string(sl:Get(iLoop)). // Gets string of value (or unknown).

                    if paramVal eq ? then // No value, just start a new named parameter in the query string.
                        assign cQueryString = substitute('&1&2&3':u, cQueryString, cDelimiter, oEntry:Key:ToString()). // eg. "[?|&]key"
                    else
                        assign cQueryString = substitute('&1&2&3=&4':u, cQueryString, cDelimiter, oEntry:Key:ToString(), paramVal). // eg. "[?|&]key=value"

                    assign cDelimiter = '&':u.
                end. // doo iLoop
            end. // do while
        end.
        
        /* if there's no QueryParams, then cQueryString will be blank. */
        if cPath ne '':u or cQueryString ne '':u then
            assign cRelativeURI = substitute('&1&2':u, cPath, cQueryString).
        
        if not this-object:Fragment eq '':u then
            assign cRelativeURI = substitute('&1#&2':u, cRelativeURI, this-object:Fragment).
        
        assign this-object:BaseURI     = cRootURI
               this-object:RelativeURI = cRelativeURI
               this-object:QueryString = cQueryString
               mcUri                   = substitute('&1&2':u, cRootURI, cRelativeURI)
               .
    end method.
    
    /** Returns a string representation of this URI
        @return character The string URI */
    method override public character ToString ():
        if mcUri eq ? then
            BuildUri().
        return mcUri.
    end method.
    
    /** Encodes this URI
        
        @return character An encoded version of the URI */
    method public character Encode ():
        define variable encodedUri as character no-undo.
        
        //scheme first
        assign encodedUri = encoder:EncodeScheme(this-object:Scheme) + '://':u.
        
        // authority: user, pw
        if this-object:User ne ? then
            assign encodedUri = encodedUri + encoder:EncodeUserinfo(this-object) + '@':u.
        
        // host
        assign encodedUri = encodedUri + encoder:EncodeHost(this-object:Host).
        
        if this-object:Port ne ? then
            assign encodedUri = encodedUri + ':':u + string(this-object:Port).
        
        // path & query
        assign encodedUri = encodedUri
                          + this-object:Path      // assumed to be already-encoded
                          + encoder:EncodeQuery(this-object:QueryParams)
                          .
        // Fragment
        if not this-object:Fragment eq '':u then
            assign encodedUri = encodedUri + '#':u + encoder:EncodeFragment(this-object:Fragment).
        
        return encodedUri.
    end method.
    
    /** Encodes a URI.
        
        @param URI The URI to encode
        @param character A character representaion of the URI */
    method static public character Encode (input poURI as URI):
        Assert:NotNull(poURI, 'URI').
        
        return poURI:Encode().
    end method.
    
    /** Encodes a URI.
        
        @param URI The URI to encode
        @param character A character representaion of the URI */
    method static public character EncodeURI (input poURI as URI):
        Assert:NotNull(poURI, 'URI').
        return poURI:Encode().
    end method.
    
    /* Encodes this URI's scheme per URI Scheme encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @return character An encoded string */
    method public character EncodeScheme ():
        return encoder:EncodeScheme(this-object:Scheme).
    end method.
        
    /* Encodes a string per URI Scheme encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeScheme (input pcString as character):
        return encoder:EncodeScheme(pcString).
    end method.

    /* Encodes a string per URI Scheme encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeScheme (input pString as String):
        return encoder:EncodeScheme(pString).
    end method.
        
    /* Encodes a string per URI Host encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeHost (input pcString as character):
        return encoder:EncodeHost(pcString).
    end method.

    /* Encodes this uri's Host per URI Host encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @return character An encoded string */
    method public character EncodeHost ():
        return encoder:EncodeHost(this-object:Host).
    end method.
    
    /* Encodes a string per URI userinfo encoding rules
      
       See OpenEdge.Net.UriEncoder for details.
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeUserinfo (input pString as String):
        return encoder:EncodeUserinfo(pString).
    end method.
    
    /* Encodes a string per URI userinfo encoding rules.
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeUserinfo (input pcString as character):
        return encoder:EncodeUserinfo(pcString).
    end method.
    
    /* Encodes this uri's Host per URI Host encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @return character An encoded string */
    method public character EncodeUserinfo ():
        return encoder:EncodeUserinfo(this-object).
    end method.
        
    /* Encodes a string per URI Host encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeHost (input pString as String):
        return encoder:EncodeHost(pString).
    end method.
    
    /* Encodes a string per URI Path encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodePath (input pcString as character):
        return encoder:EncodePath(pcString).
    end method.
    
    /* Encodes a string per URI Path encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodePath (input pString as String):
        return encoder:EncodePath(pString).
    end method.
    
    /* Encodes this URI's Query string per URI Query encoding rules.
    
       See OpenEdge.Net.UriEncoder for details.
       
       @return character An encoded path string */
    method public character EncodeQuery ():
        return encoder:EncodeQuery(this-object:QueryParams).
    end method.

    /* Encodes a URI's Query string per URI Query encoding rules.
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param URI A URI whose query string to encode
       @return character An encoded query string */
    method static public character EncodeQuery (input poURI as URI):
        Assert:NotNull(poURI, 'URI').
        
        return encoder:EncodeQuery(poURI:QueryParams).
    end method.
    
    /* Encodes a string per URI Query encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
        
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeQuery (input pcString as character):
        return encoder:EncodeQuery(pcString).
    end method.
    
    /* Encodes a string per URI Query encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeQuery (input pString as String):
        return encoder:EncodeQuery(pString).
    end method.
    
    /* Encodes this URI's Fragment per URI Fragment encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @return character An encoded string */
    method public character EncodeFragment ():
        return encoder:EncodeFragment(this-object:Fragment).
    end method.
    
    /* Encodes a string per URI Fragment encoding rules
        
       See OpenEdge.Net.UriEncoder for details.
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeFragment (input pcString as character):
        return encoder:EncodeFragment(pcString).
    end method.
    
    /* Encodes a string per URI Fragment encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeFragment (input pString as String):
        return encoder:EncodeFragment(pString).
    end method.
        
    /* Encodes a string per Cookie encoding rules. This method is here for historical reasons.
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeCookie (input pcString as character):
        return encoder:EncodeCookie(pcString).
    end method.
    
    /* Encodes a string per Cookie encoding rules. This method is here for historical reasons.
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeCookie (input pString as String):
        return encoder:EncodeCookie(pString).
    end method.
    
    /* Encodes a string per URI Default encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param character A string to encode
       @return character An encoded string */
    method static public character EncodeString (input pcString as character):
        return encoder:EncodeDefault(pcString).
    end method.
    
    /* Encodes a string per URI Default encoding rules
       
       See OpenEdge.Net.UriEncoder for details.
       
       @param String A string to encode
       @return character An encoded string */
    method static public character EncodeString (input pString as String):
        return encoder:EncodeDefault(pString).
    end method.
    

    /** Encodes a string for a particular purpose. Usage of Encode<encoding-type> is recommended.
        The method does NOT re-encode % characters.
        
        See OpenEdge.Net.UriEncoder for details.
        
        @param character The string to encode
        @param EncondingTypeEnum The type of encoding to apply
        @return character the encoded string */
    method static public character Encode (input pcString as character,
                                           input poEncodingType as UriEncodingTypeEnum):
        return encoder:Encode(pcString, poEncodingType, false).
    end method.
    
    /** Encodes a string for a particular purpose. Usage of Encode<encoding-type> is recommended,
        unless the re-encoding of % characters is desired.
        
        See OpenEdge.Net.UriEncoder for details.
        
        @param character The string to encode
        @param EncondingTypeEnum The type of encoding to apply
        @param logical TRUE if any percent characters should  be encoded as %25
        @return character the encoded string */
    method static public character Encode (input pString as character,
                                           input pEncodingType as UriEncodingTypeEnum,
                                           input pReEncode as logical):
        return encoder:Encode(pString, pEncodingType, pReEncode).
    end method.
    
    /** Attempts to decode a previously-encoded URL.
        
        See OpenEdge.Net.UriEncoder for details.
        
        @return character A decoded URL */
    method public character Decode ():
        return encoder:Decode(this-object:ToString(), ?).
    end method.
    
    /** Attempts to decode a previously percent-encoded string.
        
        See OpenEdge.Net.UriEncoder for details.
        
        @param  character The string to decode
        @return character A decoded URL
        @throws AppError If the encoding is malformed */
    method static public character Decode (input pcEncodedString as character):
        return encoder:Decode(pcEncodedString, ?).
    end method.
    
    /** Attempts to decode a previously percent-encoded string.
        
        See OpenEdge.Net.UriEncoder for details.
        
        @param  String The string to decode
        @throws AppError If the encoding is malformed */
    method static public character Decode (input pString as String):
        return encoder:Decode(pString:ToString(), pString:Encoding).
    end method.
    
    /** Returns an array of query names
        
        @param character The query name,.
        @return logical TRUE if the URI has the given query string */
    method public logical HasQueryName (input pName as character):
        return QueryParams:ContainsKey(pName).
    end method.
    
    /** Returns an array of query names
        @param character[] A character extent of query names
        @return integer The count of query names */
    method public integer GetQueryNames (output pcNames as character extent):
        define variable iCount    as integer   no-undo.
        define variable oIterator as IIterator no-undo.
        
        assign iCount    = this-object:QueryParams:Size
               oIterator = cast(this-object:QueryParams:KeySet, IIterable):Iterator()
               .
        if iCount gt 0 then
            assign extent(pcNames) = iCount.
        
        assign iCount = 0.
        do while oIterator:HasNext():
            assign pcNames[iCount + 1] = oIterator:Next():ToString()
                   iCount              = iCount + 1.
        end. // do while
        
        return iCount.
    end method.
    
    /* Resolve a relative URI reference to a base URI, as per RFC3986, at https://tools.ietf.org/html/rfc3986#section-5.2.2 .
       
       The relative URI reference does not have to be a complete URI - it may only have certain parts of a URI (like path only,
       or query only).
       
       @param URI The base URI
       @param character A string representation of a URI to merge/resolve into the base
       @return URI A resolved URI */
    method static public URI ResolveRelativeReference (input pBaseUri as URI,
                                                       input pRelativeRef as character):
        define variable cBaseURI as character extent no-undo.
        define variable cRelativeURI as character extent no-undo.
        define variable targetURI as character extent 5 no-undo.
        
        Assert:NotNull(pBaseUri, 'Base URI').
        
        assign cBaseURI     = pBaseUri:Split()
               cRelativeURI = URI:SplitUri(pRelativeRef)
               .
        // not defined(R.scheme)
        if cRelativeURI[SCHEME_PART_IDX] eq '':u then
        do:
            assign targetURI[SCHEME_PART_IDX] = cBaseURI[SCHEME_PART_IDX].
            // not defined(R.authority)
            if cRelativeURI[AUTHORITY_PART_IDX] eq '':u then
            do:
                assign targetURI[AUTHORITY_PART_IDX] = cBaseURI[AUTHORITY_PART_IDX].
                //if (R.path == "") then
                if cRelativeURI[PATH_PART_IDX] eq '':u then
                do:
                    assign targetURI[PATH_PART_IDX] = cBaseURI[PATH_PART_IDX].
                    //not defined(R.query)
                    if cRelativeURI[QUERY_PART_IDX] eq '':u then
                        assign targetURI[QUERY_PART_IDX] = cBaseURI[QUERY_PART_IDX].
                    //if defined(R.query) then
                    else
                        assign targetURI[QUERY_PART_IDX] = cRelativeURI[QUERY_PART_IDX].
                end.
                else
                do:
                    if cRelativeURI[PATH_PART_IDX] begins '/':u then
                        assign targetURI[PATH_PART_IDX] = URI:RemoveDotSegments(cRelativeURI[PATH_PART_IDX]).
                    else
                        assign targetURI[PATH_PART_IDX] = URI:MergePath(cBaseURI, cRelativeURI)
                               targetURI[PATH_PART_IDX] = URI:RemoveDotSegments(targetURI[PATH_PART_IDX])
                               .
                    assign targetURI[QUERY_PART_IDX] = cRelativeURI[QUERY_PART_IDX].
                end.
            end. //not defined authority
            else
                //if defined(R.authority) then
                assign targetURI[AUTHORITY_PART_IDX] = cRelativeURI[AUTHORITY_PART_IDX]
                       targetURI[PATH_PART_IDX]      = URI:RemoveDotSegments(cRelativeURI[PATH_PART_IDX])
                       targetURI[QUERY_PART_IDX]     = cRelativeURI[QUERY_PART_IDX]
                       .
        end. // not defined scheme
        else
            //if defined(R.scheme) then
            assign targetURI[SCHEME_PART_IDX]    = cRelativeURI[SCHEME_PART_IDX]
                   targetURI[AUTHORITY_PART_IDX] = cRelativeURI[AUTHORITY_PART_IDX]
                   targetURI[PATH_PART_IDX]      = URI:RemoveDotSegments(cRelativeURI[PATH_PART_IDX])
                   targetURI[QUERY_PART_IDX]     = cRelativeURI[QUERY_PART_IDX]
                   .

        return new URI(targetURI[SCHEME_PART_IDX],
                       targetURI[AUTHORITY_PART_IDX],
                       targetURI[PATH_PART_IDX],
                       targetURI[QUERY_PART_IDX],
                       // always use the relative fragment
                       cRelativeURI[FRAGMENT_PART_IDX]  ).
    end method.
    
    /* Merges a relative path into a base path, as per https://tools.ietf.org/html/rfc3986#section-5.2.3 .
       
       @param character[5] The split base URI
       @param character[5] The split relative URI
       @return character The merged path */
    method static private character MergePath (input pBaseURI as character extent 5,
                                               input pRelURI as character extent 5):
        define variable targetPath as character no-undo.
        define variable chrPos as integer no-undo.
        
        //shouldn't be ? but make sure
        if    pBaseURI[AUTHORITY_PART_IDX] eq ?
           or pBaseURI[PATH_PART_IDX] eq ?
           or pBaseURI[PATH_PART_IDX] eq ?
        then
            return targetPath.
        
        if not pBaseURI[AUTHORITY_PART_IDX] eq '':u
           and pBaseURI[PATH_PART_IDX] eq '':u
        then
            assign targetPath = '/':u + left-trim(pRelURI[PATH_PART_IDX], '/':u).
        else
        do:
            /* return a string consisting of the reference's path component
              appended to all but the last segment of the base URI's path (i.e.,
              excluding any characters after the right-most "/" in the base URI
              path, or excluding the entire base URI path if it does not contain
              any "/" characters).*/
            assign chrPos = r-index (pBaseURI[PATH_PART_IDX], '/':u).
            if chrPos eq 0 then
                assign targetPath = '/':u + left-trim(pRelURI[PATH_PART_IDX], '/':u).
            else
                assign targetPath = substring(pBaseURI[PATH_PART_IDX], 1, chrPos) + pRelURI[PATH_PART_IDX].
        end.
        
        return targetPath.
    end method.
    
    /* Removes any dot segments in a path string, per the rules at https://tools.ietf.org/html/rfc3986#section-5.2.4
       
       @param character The path string potentially containing "." or ".." segments
       @return character The path with the "." and/or ".." segments removed and resolved */
    method static private character RemoveDotSegments (input pInputBuffer as character):
        define variable outputBuffer as character no-undo.
        define variable chrPos as integer no-undo.
        
        assign outputBuffer = '':u.
        
        if pInputBuffer eq ? then
            return outputBuffer.
        
        //2.  While the input buffer is not empty, loop as follows:
        do while length(pInputBuffer) gt 0:
            // the string may start with a slash; we want the next / , if any
            assign chrPos = index(pInputBuffer, '/':u, 2).
            
            //A. If the input buffer begins with a prefix of "../" or "./",
            //   then remove that prefix from the input buffer; otherwise,
            if    pInputBuffer begins '../':u
               or pInputBuffer begins './':u
            then
                assign pInputBuffer = substring(pInputBuffer, chrPos + 1).
            else
            // Process 2C _first_ since /.. also starts with /.
            //
            //C. if the input buffer begins with a prefix of "/../" or "/..",
            //   where ".." is a complete path segment, then replace that
            //   prefix with "/" in the input buffer and remove the last
            //   segment and its preceding "/" (if any) from the output
            //   buffer; otherwise,
            if    pInputBuffer begins '/../':u
               or pInputBuffer eq '/..':u
            then
            do:
                if chrPos eq 0 then
                    assign pInputBuffer = '/':u.
                else
                    assign pInputBuffer = substring(pInputBuffer, chrPos).
                
                assign chrPos       = r-index(outputBuffer, '/':u)
                       outputBuffer = substring(outputBuffer, 1, chrPos - 1)
                       .
            end.
            else
            //B. if the input buffer begins with a prefix of "/./" or "/.",
            //   where "." is a complete path segment, then replace that
            //   prefix with "/" in the input buffer; otherwise,
            if    pInputBuffer begins '/./':u
               or pInputBuffer eq '/.':u
            then
            do:
                if chrPos eq 0 then
                    assign pInputBuffer = '/':u.
                else
                    assign pInputBuffer = substring(pInputBuffer, chrPos).
            end.
            else
            //D. if the input buffer consists only of "." or "..", then remove
            //   that from the input buffer; otherwise,
            if    pInputBuffer eq '.':u
               or pInputBuffer eq '..':u
            then
                assign pInputBuffer = '':u.
            else
            //E. move the first path segment in the input buffer to the end of
            //   the output buffer, including the initial "/" character (if
            //   any) and any subsequent characters up to, but not including,
            //   the next "/" character or the end of the input buffer.
            do:
                assign outputBuffer = outputBuffer + substring(pInputBuffer, 1, chrPos - 1).
                // remove the segment from the input buffer
                if chrPos eq 0 then
                    assign pInputBuffer = '':u.
                else
                    assign pInputBuffer = substring(pInputBuffer, chrPos).
            end.
        end.    //input buffer loop
        
        return outputBuffer.
    end method.
    
    method override public logical Equals (input pCompare as Object):
        if super:Equals(pCompare) then
            return true.
        
        if not valid-object(pCompare)
        or not type-of(pCompare, URI)
        then
            return false.
        
        // mcUri and BuildUri() are private but they are class-private in ABL and so
        // this-object can reference another URI object's privates
        if this-object:mcUri eq ? then
            this-object:BuildUri().
        
        if cast(pCompare, URI):mcUri eq ? then
            cast(pCompare, URI):BuildUri().
        
        return this-object:mcUri eq cast(pCompare, URI):mcUri.
    end method.
    
end class.
