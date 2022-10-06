/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ExchangeData
    Purpose     : Records data and timings of a request through the HttpClient
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-08-15
    Notes       : * Named 'ExchangeData' since it records both request and response elements
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.String.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.NullHeader.
using OpenEdge.Net.UriEncoder.
using Progress.Collections.List.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.MapEntry.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.ExchangeData
    serializable
    implements IJsonSerializer:

    /* Timestamp when the request started being processed by the HttpClient */
    define public property StartedAt    as datetime-tz no-undo get. set.
    
    /* optional: Time spent in a queue waiting for a network connection. Use -1 if the timing does not apply to the current request. */
    define public property TimeBlocked  as int64       no-undo get. set.
    
    /* optional: DNS resolution time. The time required to resolve a host name. Use -1 if the timing does not apply to the current request. */
    define public property TimeDNS      as int64       no-undo get. set.
    
    /* optional: Time required for SSL/TLS negotiation. Use -1 if the timing does not apply to the current request.*/
    define public property TimeSsl      as int64       no-undo get. set.
    
    /* optional: Time required to create TCP connection. Use -1 if the timing does not apply to the current request. */
    define public property TimeConnect  as int64       no-undo get. set.
    
    /* required: Time required to send HTTP request to the server. */
    define public property TimeSend     as int64       no-undo get. set.
    
    /* required: Time waiting for a response from the server. */
    define public property TimeWait     as int64       no-undo get. set.
    
    /* required: Time required to read entire response from the server (or cache). */
    define public property TimeReceived as int64       no-undo get. set.

    // Request information, keeping items separated (verb, scheme/host).
    /* The HTTP method used for the request */
    define public property RequestMethod as character no-undo
        get.
        private set.
    
    /* The scheme/host/post of the request URI*/
    define public property ServerAddress as character no-undo
        get.
        private set.
    
    /* The path of the request URI. This should not include query strings
       (will be stored elsewhere). */
    define public property ServerPath as character no-undo
        get.
        private set.
    
    /* The local (client) IP address */
    define public property ClientHost as character no-undo
        get.
        set.
    
    /* The local (client) port number used to make the connection */
    define public property ClientPort as integer no-undo
        get.
        set.
    
    /* The remote (server/proxy) IP address */
    define public property ServerHost as character no-undo
        get.
        set.
    
    /* The remote (server/proxy) port */
    define public property ServerPort as integer no-undo
        get.
        set.
    
    /* The response type of the request */
    define public property RequestContentType as character no-undo
        get.
        private set.
    
    /* The HTTP version of the request */
    define public property RequestHttpVersion as character no-undo
        get.
        private set.
    
    // The Request query string
    define public property QueryString as IStringKeyedMap no-undo get. set.
    
    /* The byte representation of the request body, if any */
    define public property RequestBody  as class IMemptrHolder no-undo get. set.
    
    /* The byte representation of the response body, if any */
    define public property ResponseBody as class IMemptrHolder no-undo get. set.
    
    // Cookies will be added to trace data as rules apply.
    /* An array of request cookie values */
    define public property RequestCookies  as character extent no-undo get.
        private set.
    /* An array of response cookie values */
    define public property ResponseCookies as character extent no-undo get.
        private set.

    // Headers will be added to trace data as rules apply.
    /* An array of request header values */
    define public property RequestHeaders  as character extent no-undo get.
        private set.
    /* An array of response header values */
    define public property ResponseHeaders as character extent no-undo get.
        private set.
    
    /* The status code of the response */
    define public property ResponseStatusCode as integer no-undo
        get.
        private set.
    /* The content-type of the response body, if any */
    define public property ResponseContentType as character no-undo
        get.
        private set.
    /* The HTTP version of the response */
    define public property ResponseHttpVersion as character no-undo
        get.
        private set.

    /* Default constructor */
    constructor public ExchangeData():
        ClearData().
    end constructor.
    
    // Allows resetting of all properties in the object.
    method public void ClearData( ):
        assign
            this-object:StartedAt               = ?
            this-object:TimeBlocked             = -1
            this-object:TimeDNS                 = -1
            this-object:TimeSsl                 = -1
            this-object:TimeConnect             = 0
            this-object:TimeSend                = 0
            this-object:TimeWait                = 0
            this-object:TimeReceived            = 0
            
            this-object:ClientHost              = '':u
            this-object:ClientPort              = 0
            this-object:ServerHost              = '':u
            this-object:ServerPort              = 0
            
            this-object:RequestMethod           = "":u
            this-object:RequestBody             = ?
            this-object:RequestHttpVersion      = '':u
            extent(this-object:RequestCookies)  = ?
            extent(this-object:RequestHeaders)  = ?
            this-object:QueryString             = new StringKeyedMap() // Default to an empty object to avoid need for checking if valid-object
            this-object:ServerAddress           = "":u
            this-object:ServerPath              = "":u
             
            this-object:ResponseStatusCode      = 0
            this-object:ResponseBody            = ?
            this-object:ResponseHttpVersion     = '':u
            extent(this-object:ResponseCookies) = ?
            extent(this-object:ResponseHeaders) = ?
            .
    end method.
    
    /* Sets the request info for this trace.
       
       @param IHttpRequest A valid HTTP request     */
    method public void SetRequestInfo(input poRequest as IHttpRequest):
        Assert:NotNull(poRequest, 'Request':u).
        assign
            this-object:RequestMethod      = poRequest:Method
            this-object:ServerAddress      = poRequest:URI:BaseURI
            this-object:ServerPath         = poRequest:URI:Path
            
            this-object:RequestHttpVersion = poRequest:Version
            this-object:RequestContentType = poRequest:ContentType
            .
    end method.
    
    /* Sets the response info for this trace.
       
       @param IHttpResponse A valid HTTP response  */
    method public void SetResponseInfo(input pResponse as IHttpResponse):
        Assert:NotNull(pResponse, 'HTTP Response').
        
        assign this-object:ResponseContentType = pResponse:ContentType
               this-object:ResponseHttpVersion = pResponse:Version
               this-object:ResponseStatusCode  = pResponse:StatusCode
               .
    end method.
    
    /* Adds a request cookie to the trace data
       
       @param Cookie The cookie to add. Unknown values are not added to the data */
    method public void AddRequestCookie ( input poCookie as Cookie ):
        var integer iCnt.
        
        if not valid-object(poCookie) then
            return.
        
        if extent(this-object:RequestCookies) eq ? then
            iCnt = 1.
        else
            iCnt = extent(this-object:RequestCookies) + 1.
        
        assign
            extent(this-object:RequestCookies) = iCnt
            this-object:RequestCookies[iCnt]   = poCookie:ToString()
            .
    end method.

    /* Adds a response cookie to the trace data
       
       @param Cookie The cookie to add. Unknown values are not added to the data */
    method public void AddResponseCookie ( input poCookie as Cookie ):
        var integer iCnt.
        
        if not valid-object(poCookie) then
            return.
        
        if extent(this-object:ResponseCookies) eq ? then
            iCnt = 1.
        else
            icnt = extent(this-object:ResponseCookies) + 1.

        assign
            extent(this-object:ResponseCookies) = iCnt
            this-object:ResponseCookies[iCnt]   = poCookie:ToString()
            .
    end method.
    
    /* Adds an array of request cookies to the trace data
       
       @param Cookie[] The cookies to add. Unknown values are not added to the data  */
    method public void AddRequestCookies ( input poCookies as Cookie extent ):
        var integer iCnt, iLoop.
        
        assign
            iCnt = extent(poCookies).
        if iCnt ne ? and iCnt gt 0 then
        COOKIE-LOOP:
        do iLoop = 1 to iCnt:
            this-object:AddRequestCookie(poCookies[iLoop]).
        end.
    end method.

    /* Adds an array of response cookies to the trace data
       
       @param Cookie[] The cookies to add. Unknown values are not added to the data  */
    method public void AddResponseCookies ( input poCookies as Cookie extent ):
        var integer iCnt, iLoop.

        assign
            iCnt = extent(poCookies).
        if iCnt ne ? and iCnt gt 0 then
        COOKIE-LOOP:
        do iLoop = 1 to iCnt:
            this-object:AddResponseCookie(poCookies[iLoop]).
        end.
    end method.

    /* Adds a request header to the trace data
       
       @param HttpHeader The header to add. Unknown values are not added to the data  */
    method public void AddRequestHeader ( input poHeader as HttpHeader ):
        var integer iCnt.
        
        if not valid-object(poHeader)
        or type-of(poHeader, NullHeader)
        then
            return.
        
        if extent(this-object:RequestHeaders) eq ? then
            iCnt = 1.
        else
            iCnt = extent(this-object:RequestHeaders) + 1.
        
        assign extent(this-object:RequestHeaders) = iCnt.
        case poHeader:Name:
            // these headers contain sensitive data; their existence should be recorded but not their contents
            when 'Authorization':u or
            when 'Proxy-Authorization':u then
                assign this-object:RequestHeaders[iCnt] = substitute('&1: &2':u, poHeader:Name, '><((((>  ><((((>  ><((((>':u).
            otherwise
                assign this-object:RequestHeaders[iCnt] = poHeader:ToString().
        end case.
    end method.
    
    /* Adds a response header to the trace data
       
       @param HttpHeader The header to add. Unknown values are not added to the data  */
    method public void AddResponseHeader ( input poHeader as HttpHeader ):
        var integer iCnt.
        
        if not valid-object(poHeader)
        or type-of(poHeader, NullHeader)
        then
            return.
        
        if extent(this-object:ResponseHeaders) eq ? then
            iCnt = 1.
        else
            iCnt = extent(this-object:ResponseHeaders) + 1.
        
        assign
            extent(this-object:ResponseHeaders) = iCnt
            this-object:ResponseHeaders[iCnt]   = poHeader:ToString()
            .
    end method.

    /* Adds an array of request headers to the data.
       
       @param Httpheader[] The headers to add. Unknown values are not added to the data  */
    method public void AddRequestHeaders ( input poHeaders as HttpHeader extent ):
        var integer iCnt, iLoop.

        assign
            iCnt = extent(poHeaders).
        if iCnt ne ? and iCnt gt 0 then
        HEADER-LOOP:
        do iLoop = 1 to iCnt:
            this-object:AddRequestHeader(poHeaders[iLoop]).
        end.
    end method.

    /* Adds an array of response headers to the data.
       
       @param Httpheader[] The headers to add. Unknown values are not added to the data  */
    method public void AddResponseHeaders ( input poHeaders as HttpHeader extent ):
        var integer iCnt, iLoop.

        assign
            iCnt = extent(poHeaders).
        if iCnt ne ? and iCnt gt 0 then
        HEADER-LOOP:
        do iLoop = 1 to iCnt:
            this-object:AddResponseHeader(poHeaders[iLoop]).
        end.
    end method.
    
    /* DESERIALIZATION METHOD: populates this object with data from the JSON representation.
       
       @param JsonConstruct A JSON representation of this object. May be unknown (JsonDataType:NULL). */
    method public void FromJson (input pJson as JsonConstruct):
        var JsonObject data, jo, qs.
        var JsonArray ja.
        var character[] names.
        var integer cnt, cnt2, loop, loop2.
        
        if not type-of(pJson, JsonObject) then
            return.
        
        assign data = cast(pJson, JsonObject).
        
        if JsonPropertyHelper:HasTypedProperty(data, 'connection':u, JsonDataType:OBJECT) then
        do:
            assign jo = data:GetJsonObject('connection':u).
            
            if JsonPropertyHelper:HasTypedProperty(jo, 'clientHost':u, JsonDataType:STRING) then
                assign this-object:ClientHost = jo:GetCharacter('clientHost':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'clientPort':u, JsonDataType:NUMBER) then
                assign this-object:ClientPort = jo:GetInteger('clientPort':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'serverHost':u, JsonDataType:STRING) then
                assign this-object:ServerHost = jo:GetCharacter('serverHost':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'clientPort':u, JsonDataType:NUMBER) then
                assign this-object:ClientPort = jo:GetInteger('clientPort':u).
        end.    // connection
        
        if JsonPropertyHelper:HasTypedProperty(data, 'request':u, JsonDataType:OBJECT) then
        do:
            assign jo = data:GetJsonObject('request':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'serverAddress':u, JsonDataType:STRING) then
                assign this-object:ServerAddress = jo:GetCharacter('serverAddress':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'serverPath':u, JsonDataType:STRING) then
                assign this-object:ServerPath = jo:GetCharacter('serverPath':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'method':u, JsonDataType:STRING) then
                assign this-object:RequestMethod = jo:GetCharacter('method':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'httpVersion':u, JsonDataType:STRING) then
                assign this-object:RequestHttpVersion = jo:GetCharacter('httpVersion':u).

            if JsonPropertyHelper:HasTypedProperty(jo, 'queryString':u, JsonDataType:OBJECT) then do:
                this-object:QueryString:Clear().

                assign
                    qs    = jo:GetJsonObject('queryString')
                    names = qs:GetNames()
                    cnt   = extent(names)
                    .

                do loop = 1 to cnt:
                    // The value for each query string token should be considered a string, but we should make absolutely sure.
                    // We must handle the previous format (name:string or name:null) along with the new name:array of values.
                    if JsonPropertyHelper:HasTypedProperty(qs, names[loop], JsonDataType:STRING) then do:
                        // Create a new List<String> for values of key (name).
                        if not this-object:QueryString:ContainsKey(names[loop]) then
                            this-object:QueryString:Put(names[loop], new List<String>()).
    
                        cast(this-object:QueryString:Get(names[loop]), List<String>):Add(new String(qs:GetCharacter(names[loop]))).
                    end.
                    else if JsonPropertyHelper:HasTypedProperty(qs, names[loop], JsonDataType:NULL) then do:
                        // Create a new List<String> for values of key (name).
                        if not this-object:QueryString:ContainsKey(names[loop]) then
                            this-object:QueryString:Put(names[loop], new List<String>()).
    
                        cast(this-object:QueryString:Get(names[loop]), List<String>):Add(?). // Use the unknown value.
                    end.
                    else if JsonPropertyHelper:HasTypedProperty(qs, names[loop], JsonDataType:ARRAY) then do:
                        // The structure for query values should be an array of strings.

                        // Create a new List<String> for values of key (name).
                        if not this-object:QueryString:ContainsKey(names[loop]) then
                            this-object:QueryString:Put(names[loop], new List<String>()).
    
                        // Add each element of the array to the List<String> of this QueryString object (map).
                        assign ja = qs:GetJsonArray(names[loop]).
                        assign cnt2 = ja:Length.
                        do loop2 = 1 to cnt2:
                            // The value for each query string token should be considered a string, but we should make absolutely sure.
                            if ja:GetType(loop2) eq JsonDataType:STRING then
                                cast(this-object:QueryString:Get(names[loop]), List<String>):Add(new String(ja:GetCharacter(loop2))).
                            else
                                cast(this-object:QueryString:Get(names[loop]), List<String>):Add(?).
                        end.
                    end.
                end.
            end.
            
            if JsonPropertyHelper:HasTypedProperty(jo, 'cookies':u, JsonDataType:ARRAY) then
                assign ja                         = jo:GetJsonArray('cookies':u)
                       this-object:RequestCookies = ja:GetCharacter(1, ja:Length)
                       .
            if JsonPropertyHelper:HasTypedProperty(jo, 'headers':u, JsonDataType:ARRAY) then
                assign ja                         = jo:GetJsonArray('headers':u)
                       this-object:RequestHeaders = ja:GetCharacter(1, ja:Length)
                       .
            if JsonPropertyHelper:HasTypedProperty(jo, 'body':u, JsonDataType:STRING) then
                assign this-object:RequestBody = new Memptr(base64-decode(jo:GetCharacter('body':u))).
            
            if JsonPropertyHelper:HasTypedProperty(jo, 'contentType':u, JsonDataType:STRING) then
                assign this-object:RequestContentType = jo:GetCharacter('contentType':u).
        end.    // request
        
        if JsonPropertyHelper:HasTypedProperty(data, 'timings':u, JsonDataType:OBJECT) then
        do:
            assign jo = data:GetJsonObject('timings':u).
            
            if JsonPropertyHelper:HasTypedProperty(jo, 'startedAt':u, JsonDataType:STRING) then
                assign this-object:StartedAt = jo:GetDatetimeTZ('startedAt':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'timeBlocked':u, JsonDataType:NUMBER) then
                assign this-object:TimeBlocked = jo:GetInteger('timeBlocked':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'timeDNS':u, JsonDataType:NUMBER) then
                assign this-object:TimeDNS = jo:GetInteger('timeDNS':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'timeSsl':u, JsonDataType:NUMBER) then
                assign this-object:TimeSsl = jo:GetInteger('timeSsl':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'timeConnect':u, JsonDataType:NUMBER) then
                assign this-object:TimeConnect = jo:GetInteger('timeConnect':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'timeSend':u, JsonDataType:NUMBER) then
                assign this-object:TimeSend = jo:GetInteger('timeSend':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'timeWait':u, JsonDataType:NUMBER) then
                assign this-object:TimeWait = jo:GetInteger('timeWait':u).
            if JsonPropertyHelper:HasTypedProperty(jo, 'timeReceived':u, JsonDataType:NUMBER) then
                assign this-object:TimeReceived = jo:GetInteger('timeReceived':u).
        end.    // timings
        
        if JsonPropertyHelper:HasTypedProperty(data, 'response':u, JsonDataType:OBJECT) then
        do:
            assign jo = data:GetJsonObject('response':u).
            
            if JsonPropertyHelper:HasTypedProperty(jo, 'httpVersion':u, JsonDataType:STRING) then
                assign this-object:ResponseHeaders = jo:GetCharacter('httpVersion':u).
            
            if JsonPropertyHelper:HasTypedProperty(jo, 'contentType':u, JsonDataType:STRING) then
                assign this-object:ResponseContentType = jo:GetCharacter('contentType':u).
            
            if JsonPropertyHelper:HasTypedProperty(jo, 'statusCode':u, JsonDataType:NUMBER) then
                assign this-object:ResponseStatusCode = jo:GetInteger('statusCode':u).
                
            if JsonPropertyHelper:HasTypedProperty(jo, 'cookies':u, JsonDataType:ARRAY) then
                assign ja                          = jo:GetJsonArray('cookies':u)
                       this-object:ResponseCookies = ja:GetCharacter(1, ja:Length)
                       .
            if JsonPropertyHelper:HasTypedProperty(jo, 'headers':u, JsonDataType:ARRAY) then
                assign ja                          = jo:GetJsonArray('headers':u)
                       this-object:ResponseHeaders = ja:GetCharacter(1, ja:Length)
                       .
            if JsonPropertyHelper:HasTypedProperty(jo, 'body':u, JsonDataType:STRING) then
                assign this-object:ResponseBody = new Memptr(base64-decode(jo:GetCharacter('body':u))).
        end.    // response
    end method.
    
    /* SERIALIZATION METHOD:returns a JsonConstruct (JsonDataType:OBJECT or JsonDataType:ARRAY) representation
       of this object.
       
       @return JsonConstruct A JSON representation of this object. May be unknown (JsonDataType:NULL). */
    method public JsonConstruct ToJsonConstruct():
        var JsonObject data, jo, qs.
        var JsonArray ja.
        var IIterator iter.
        var MapEntry me.
        var List<String> sl.
        var integer cnt, loop.
        var UriEncoder encoder = new UriEncoder().
        
        data = new JsonObject().
        jo = new JsonObject().
        data:Add('connection':u, jo).
            jo:Add('clientHost':u, ClientHost).
            jo:Add('clientPort':u, ClientPort).
            jo:Add('serverHost':u, ServerHost).
            jo:Add('serverPort':u, ServerPort).

        jo = new JsonObject().
        data:Add('timings':u, jo).
            jo:Add('startedAt':u, StartedAt).
            jo:Add('timeBlocked':u, TimeBlocked).
            jo:Add('timeDNS':u, TimeDNS).
            jo:Add('timeSsl':u, TimeSsl).
            jo:Add('timeConnect':u, TimeConnect).
            jo:Add('timeSend':u, TimeSend).
            jo:Add('timeWait':u, TimeWait).
            jo:Add('timeReceived':u, TimeReceived).

        assign qs = new JsonObject().
        if QueryString:Size gt 0 then do:
            assign iter = QueryString:EntrySet:Iterator().

            do while iter:HasNext():
                assign me = cast(iter:Next(), MapEntry).

                // Add query parameters as name-value pairs.
                if valid-object(me:Value) then do:
                    assign sl = cast(me:Value, List<String>).
                    assign cnt = sl:Count.
                    case cnt:
                        when 0 then
                            qs:AddNull(string(me:Key)). // No count, no value.
                        when 1 then
                            // Add the value as just a decoded string.
                            {&_proparse_ prolint-nowarn(overflow)}
                            qs:Add(string(me:Key), encoder:Decode(string(sl:Get(1):Value))).
                        otherwise do:
                            assign ja = new JsonArray(). // Create an empty array for multiple values.
                            do loop = 1 to cnt:
                                {&_proparse_ prolint-nowarn(overflow)}
                                ja:Add(encoder:Decode(string(sl:Get(loop):Value))). // Add the decoded value of the String object.
                            end.
                            qs:Add(string(me:Key), ja). // Add array of values to a property named for this parameter.
                        end.
                    end case.
                end. // valid-object
                else
                    qs:AddNull(string(me:Key)). // Otherwise just add a null property.
            end. // do while
        end.

        jo = new JsonObject().
        data:Add('request':u, jo).
            jo:Add('serverAddress':u, ServerAddress).
            jo:Add('serverPath':u, ServerPath).
            jo:Add('method':u, RequestMethod).
            jo:Add('httpVersion':u, RequestHttpVersion).
            jo:Add('queryString':u, qs).
            jo:Add('contentType':u, RequestContentType).

        if extent(RequestHeaders) eq ? then
            jo:AddNull('headers':u).
        else
            jo:Add('headers':u, new JsonArray(RequestHeaders)).
            
        if extent(RequestCookies) eq ? then
            jo:AddNull('cookies':u).
        else
            jo:Add('cookies':u, new JsonArray(RequestCookies)).
            
        if valid-object(RequestBody) then
            jo:Add('body':u, base64-encode(RequestBody:Value)).
        else
            jo:AddNull('body':u).
        
        jo = new JsonObject().
        data:Add('response':u, jo).
            jo:Add('httpVersion':u, ResponseHttpVersion).
            jo:Add('contentType':u, ResponseContentType).
            jo:Add('statusCode':u, ResponseStatusCode).
        
        if extent(ResponseCookies) eq ? then
            jo:AddNull('cookies':u).
        else
            jo:Add('cookies':u, new JsonArray(ResponseCookies)).
            
        if extent(ResponseHeaders) eq ? then
            jo:AddNull('headers':u).
        else
            jo:Add('headers':u, new JsonArray(ResponseHeaders)).
            
        if valid-object(ResponseBody) then
            jo:Add('body':u, base64-encode(ResponseBody:Value)).
        else
            jo:AddNull('body':u).
        
        return data.
    end method.

end class.
