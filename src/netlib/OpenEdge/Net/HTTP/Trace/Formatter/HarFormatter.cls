/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : HarFormatter
    Purpose     : Formats trace data in the HAR format
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-09022
    Notes       : * Format per http://www.softwareishard.com/blog/har-12-spec/
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.Formatter.ITraceFormatter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Net.HTTP.Trace.Formatter.HarFormatter
implements ITraceFormatter:

    /* If TRUE the HAR data will be written out formatted aka pretty-printed. Default is FALSE */
    define public property Formatted as logical no-undo initial false
        get.
        set.

    /** Formats the input tracing data into a set of bytes to be written (typically).
        This method may produce JSON or some other structured representation.

        @param ExchangeData[] An array of trace data
        @return IMemptrHolder The formatted representation of the trace data */
    method public IMemptrHolder Format(input pTraceData as ExchangeData extent):
        var ByteBucket bb = ByteBucket:Instance().
        var JsonObject data, logData, creator, curEntry, curItem.
        var JsonArray entries.
        var IMapEntry mapEntry.
        var IIterator iterator.
        var integer cnt, loop.
        var character strData, delim.
        var memptr mData.

        assign data    = new JsonObject()
               logData = new JsonObject()
               creator = new JsonObject()
               entries = new JsonArray()
               .
        data:Add('log':u, logData).

        // HAR version
        logData:Add('version':u, '1.2':u).
        logData:Add('creator':u, creator).
        creator:Add('name':u,    this-object:GetClass():TypeName).
        creator:Add('version':u, string(SemanticVersion:Parse(proversion(1)))).

        logData:Add('entries':u,  entries).
        assign cnt = extent(pTraceData).
        DATA-LOOP:
        do loop = 1 to cnt:
            if not valid-object(pTraceData[loop]) then
                next DATA-LOOP.

            assign curEntry = new JsonObject().
            entries:Add(curEntry).
            curEntry:Add('startedDateTime':u, iso-date(pTraceData[loop]:StartedAt)).
            //TODO
            curEntry:Add('time':u,            GetTime(pTraceData[loop])).
            curEntry:Add('serverIPAddress':u, pTraceData[loop]:ServerHost).
            curEntry:Add('connection':u,      substitute('&1:&2', pTraceData[loop]:ClientHost, pTraceData[loop]:ClientPort)).

            assign curItem = new JsonObject().
            curEntry:Add('timings':u, curItem).
            curItem:Add('blocked':u, pTraceData[loop]:TimeBlocked).
            curItem:Add('dns':u,     pTraceData[loop]:TimeDNS).
            curItem:Add('ssl':u,     pTraceData[loop]:TimeSsl).
            curItem:Add('connect':u, pTraceData[loop]:TimeConnect).
            curItem:Add('send':u,    pTraceData[loop]:TimeSend).
            curItem:Add('wait':u,    pTraceData[loop]:TimeWait).
            curItem:Add('receive':u, pTraceData[loop]:TimeReceived).

            // request
            assign curItem = new JsonObject().
            curEntry:Add('request':u, curItem).
            curItem:Add('method':u, pTraceData[loop]:RequestMethod).

            strData = pTraceData[loop]:ServerAddress + pTraceData[loop]:ServerPath.
            if valid-object(pTraceData[loop]:QueryString) and not pTraceData[loop]:QueryString:IsEmpty() then do:
                assign
                    iterator = pTraceData[loop]:QueryString:EntrySet:Iterator()
                    delim    = '?':u
                    .
                do while iterator:HasNext():
                    assign mapEntry = cast(iterator:Next(), IMapEntry).
                    if valid-object(mapEntry:Value) then
                        strData = substitute('&1&2&3=&4', strData, delim, string(mapEntry:Key), string(mapEntry:Value)).
                    else
                        strData = substitute('&1&2&3', strData, delim, string(mapEntry:Key)).
                    assign delim = '&':u.
                end.
            end.
            curItem:Add('url':u, strData).

            curItem:Add('httpVersion':u, pTraceData[loop]:RequestHttpVersion).
            curItem:Add('cookies':u, GetCookies(pTraceData[loop]:RequestCookies)).
            curItem:Add('queryString':u, GetQueryString(pTraceData[loop]:QueryString)).
            AddHeaders(pTraceData[loop]:RequestHeaders, curItem, no).

            // Body
            AddBody(pTraceData[loop]:RequestBody,
                    pTraceData[loop]:RequestContentType,
                    curItem,
                    'postData':u).

            // response
            assign curItem = new JsonObject().
            curEntry:Add('response':u, curItem).

            curItem:Add('status':u, pTraceData[loop]:ResponseStatusCode).
            curItem:Add('statusText':u, StatusCodeHelper:GetMessage(pTraceData[loop]:ResponseStatusCode)).
            curItem:Add('httpVersion':u, pTraceData[loop]:ResponseHttpVersion).
            curItem:Add('cookies':u, GetCookies(pTraceData[loop]:ResponseCookies)).
            AddHeaders(pTraceData[loop]:ResponseHeaders, curItem, yes).

            AddBody(pTraceData[loop]:ResponseBody,
                    pTraceData[loop]:ResponseContentType,
                    curItem,
                    'contentData':u).
        end.    // DATA-LOOP

        // write output as bytes
        data:Write(mData, this-object:Formatted).
        bb:PutBytes(mData).

        return bb.
        finally:
            set-size(mData) = 0.
        end finally.
    end method.

    /** Splits the query string into a JSON array

        @param character a standard query string
        @param JsonArray An array of objects representing the query string. May be null. */
    method private JsonArray GetQueryString(input pData as IStringStringMap):
        var IIterator iterator.
        var IMapEntry mapEntry.
        var JsonArray arrData.
        var JsonObject itemData.

        assign arrData = new JsonArray().

        if pData eq ? then
            return arrData.
       
        assign iterator = pData:EntrySet:Iterator().
        do while iterator:HasNext():
            assign mapEntry = cast(iterator:Next(), IMapEntry).
            assign itemData = new JsonObject().
            itemData:Add('name':u,  string(mapEntry:Key)).
            if valid-object(mapEntry:Value) then
                itemData:Add('value':u, string(mapEntry:Value)).
            else
                itemData:AddNull('value':u).
            arrData:Add(itemData).
        end.

        return arrData.
    end method.

    /** Adds an array of header values to a JsonObject

        @param character[] An array of header values
        @param JsonObject The parent JSON object. */
    method private void AddHeaders(input pData as character extent,
                                   input pParent as JsonObject,
                                   input pAddRedirectUrl as logical):
        var JsonArray arrData.
        var integer loop, cnt, pos, size.
        var JsonObject itemData.
        var character hdrName, hdrVal.

        if not valid-object(pParent) then
            return.

        assign cnt = extent(pData).
        if cnt eq ? then
        do:
            pParent:AddNull('headers':u).
            pParent:Add('headersSize':u, 0).
            return.
        end.

        assign arrData = new JsonArray().
        HDR-LOOP:
        do loop = 1 to cnt:
            if pData[loop] eq ?
            or pData[loop] eq '':u
            then
                next HDR-LOOP.

            assign pos      = index(pData[loop], ':':u)
                   itemData = new JsonObject()
                   size   += length(pData[loop], 'raw':u) + 2   //CRLF
                   hdrName = trim(substring(pData[loop], 1, pos - 1))
                   hdrVal  = trim(substring(pData[loop], pos + 1))
                   .
            if hdrName eq 'location':u
            and pAddRedirectUrl
            then
            do:
                if pParent:Has('redirectURL':u) then
                    pParent:Set('redirectURL':u, hdrVal).
                else
                    pParent:Add('redirectURL':u, hdrVal).
            end.

            arrData:Add(itemData).

            itemData:Add('name':u,  hdrName).
            itemData:Add('value':u, hdrVal).
        end.

        // there's a trailing CRLF
        assign size += 2.

        pParent:Add('headers':u, arrData).
        pParent:Add('headersSize':u, size).
    end method.

    /** Parses an array of cookie values into a JsonArray

        @param character[] An array of cookie values
        @return JsonArray  An array of objects representing the cookie. May be null. */
    method private JsonArray GetCookies(input pData as character extent):
        var JsonArray arrData.
        var integer loop, cnt.
        var JsonObject itemData.
        var Cookie treat.
        var character delim, comment.

        assign cnt = extent(pData).
        if cnt eq ? then
            return arrData.

        assign arrData = new JsonArray().
        COOKIE-LOOP:
        do loop = 1 to cnt:
            assign treat    = Cookie:Parse(pData[loop])
                   itemData = new JsonObject()
                   comment  = '':u
                   delim    = '':u
                   .
            arrData:Add(itemData).

            itemData:Add('name':u,     treat:Name).
            itemData:Add('value':u,    treat:Value).
            itemData:Add('path':u,     treat:Path).
            itemData:Add('domain':u,   treat:Domain).
            itemData:Add('expires':u,  iso-date(treat:ExpiresAt)).
            itemData:Add('httpOnly':u, treat:HttpOnly).
            if valid-object(treat:SameSite) then
                itemData:Add('sameSite':u, string(treat:SameSite)).
            else
                itemData:AddNull('sameSite':u).
            itemData:Add('secure':u,   treat:Secure).

            if not treat:MaxAge eq ? then
                assign comment += substitute('&1Max-Age: &2', delim, treat:MaxAge)
                       delim    = '; ':u
                       .
            if not treat:Version eq ? then
                assign comment += substitute('&1Version: &2', delim, treat:Version)
                       delim    = '; ':u
                       .
            itemData:Add('comment':u,   comment).
        end.

        return arrData.
    end method.

    /** Adds data about the body to the current item

        @param IMemptrHolder Body data
        @param character The value of the content-type header
        @param JsonObject The parent JSON object
        @param character The property name for the body data. */
    method private void AddBody(input pBody as IMemptrHolder,
                                input pContentType as character,
                                input pParent as JsonObject,
                                input pPropertyName as character):
        var int64 size.
        var JsonObject bodyData.

        if not valid-object(pParent)
        or pPropertyName eq ?
        or pPropertyName eq '':u
        then
            return.

        if not valid-object(pBody) then
            return.

        assign size = get-size(pBody:Value).
        if size eq ? then
            assign size = 0.

        pParent:Add('bodySize':u, size).
        if size gt 0 then
        do:
            bodyData = new JsonObject().
            pParent:Add(pPropertyName, bodyData).

            bodyData:Add('mimeType':u, pContentType).
            // cheapest to always BASE64-ENCODE the body
            bodyData:Add('text':u, base64-encode(pBody:Value)).
            bodyData:Add('encoding':u, 'base64':u).
        end.
    end method.

    /** calculates a request's elapsed etime per trace data

        @param ExchangeData
        @return integer The elapsed time. Zero or greater. */
    method private int64 GetTime(input pData as ExchangeData):
        var int64 elapsed = 0.

        if not valid-object(pData) then
            return elapsed.

        if pData:TimeBlocked gt 0 then
            assign elapsed += pData:TimeBlocked.

        if pData:TimeDNS gt 0 then
            assign elapsed += pData:TimeDNS.

        if pData:TimeSsl gt 0 then
            assign elapsed += pData:TimeSsl.

        if pData:TimeConnect gt 0 then
            assign elapsed += pData:TimeConnect.

        if pData:TimeSend gt 0 then
            assign elapsed += pData:TimeSend.

        if pData:TimeWait gt 0 then
            assign elapsed += pData:TimeWait.

        if pData:TimeReceived gt 0 then
            assign elapsed += pData:TimeReceived.

        return elapsed.
    end method.

end class.