/************************************************
Copyright (c) 2015, 2018, 2021-2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StringEntityWriter
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : - Write() operations are destructive (they replace the existing
                    Entity).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.String.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriterErrorEventArgs.
using OpenEdge.Net.ISupportEncoding.
using Progress.IO.FileInputStream.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Payload.StringEntityWriter.

class OpenEdge.Net.HTTP.Filter.Payload.StringEntityWriter inherits MessageWriter
            implements ISupportEncoding:

    /* Content encoding (eg utf-8) used used by this writer */
    define public property Encoding as character no-undo
        get.
        set(input pValue as character):
            Assert:NotNull(pValue, 'Encoding').
            assign this-object:Encoding = pValue.
        end set.

    /* Default constructor */
    constructor public StringEntityWriter():
        super(get-class(String)).
    end constructor.

    method override public int64 Write(input poData as Object):
        define variable mTemp as memptr no-undo.
        define variable oData as class Memptr no-undo.

        case true:
            when not valid-object(poData) then
                return 0.

            when type-of(poData, JsonObject) then
            do:
                // JSON is defined as UTF-8
                assign this-object:Encoding = 'UTF-8':u.
                return this-object:Write(cast(poData, JsonObject):GetJsonText()).
            end.

            when type-of(poData, JsonArray) then
            do:
                // JSON is defined as UTF-8
                assign this-object:Encoding = 'UTF-8':u.
                return this-object:Write(cast(poData, JsonArray):GetJsonText()).
            end.

            when type-of(poData, ILongcharHolder) then
                return this-object:Write(cast(poData, ILongcharHolder):Value).

            when type-of(poData, ICharacterHolder) then
                return this-object:Write(cast(poData, ICharacterHolder):Value).

            when type-of(poData, Memptr) then
                assign oData = cast(poData, Memptr).

            when type-of(poData, ByteBucket) then
                assign oData = cast(poData, ByteBucket):GetBytes().

            when type-of(poData, FileInputStream) then
                return WriteFileStream(cast(poData, FileInputStream)).
            
            when type-of(poData, IHandleHolder) then
                return this-object:Write(cast(poData, IHandleHolder):Value).
            
            otherwise
                return this-object:Write(poData:ToString()).
        end case.

        if valid-object(oData) then
        do on error undo, throw:
            set-size(mTemp) = 1. /* allocate a new 1-byte memptr */
            set-size(mTemp) = 0. /* free this 1-byte memptr, which also clears the size */
            set-pointer-value(mTemp) = oData:GetPointerValue().
            set-size(mTemp) = oData:Size.

            return this-object:Write(mTemp).

            finally:
                set-pointer-value(mTemp) = 0.
                set-size(mTemp) = 0.
            end finally.
        end.
    end method.

    method override public int64 Write(input pcData as longchar):
        define variable cCharset as character no-undo.
        define variable cOECodepage as character no-undo.
        define variable iBytesWritten as int64 no-undo.

        assign iBytesWritten = length(pcData, 'raw':u).

        Assert:IsZeroOrPositive(iBytesWritten, 'Data').

        assign cCharset = this-object:Encoding.
        if cCharset eq '':u then
            /* http://tools.ietf.org/html/rfc2616#page-27
               Section 3.7.1 Canonicalization and Text Defaults says to use ISO8859-1 */
            assign cCharset = 'ISO-8859-1':u.

        /* convert to ABL format from ISO */
        run adecomm/convcp.p (input  cCharset,
                              input  'toProg':u,
                              output cOECodepage).

        if is-codepage-fixed(pcData) then
            Assert:Equals(cOECodepage, get-codepage(pcData)).
        else
        if length(pcData, 'raw':u) eq 0 then
            fix-codepage(pcData) = cOECodepage.

        assign this-object:Entity = new String(pcData).

        return iBytesWritten.
    end method.

    method override public int64 Write(input pmData as memptr):
        define variable lcData as longchar no-undo.
        define variable cCharset as character no-undo.
        define variable cOECodepage as character no-undo.
        define variable iBytesWritten as int64 no-undo.
        define variable mweea as MessageWriterErrorEventArgs no-undo.

        assign iBytesWritten = get-size(pmData).
        Assert:IsZeroOrPositive(iBytesWritten, 'Data size').

        assign cCharset = this-object:Encoding.
        if cCharset eq '':u then
            /* http://tools.ietf.org/html/rfc2616#page-27
               Section 3.7.1 Canonicalization and Text Defaults says to use ISO-8859-1 */
            assign cCharset = 'ISO-8859-1':u.

        /* convert to ABL format from ISO */
        run adecomm/convcp.p (input  cCharset,
                              input  'toProg':u,
                              output cOECodepage).

        fix-codepage(lcData) = cOECodepage.

        if iBytesWritten eq 0 then
            assign lcData = ?.
        else
            // This attempts to copy the entire memptr to longchar, but will barf if the string has nulls or
            // other invalid characters. Always use COPY-LOB, even if we could use GET-STRING
            // because the errors from COPY-LOB are better
            copy-lob from pmData
                     to lcData
                     convert source codepage cOECodepage.
        
        assign this-object:Entity = new String(lcData).
        
        return iBytesWritten.
        catch copyErr as Progress.Lang.SysError:
            case copyErr:GetMessageNum(1):
                // Invalid character data found in MEMPTR for codepage ISO8859-1 (12012)
                when 12012 or
                // Large object assign or copy failed. (11395)
                when 11395 then
                do:
                    // we need to explicitly fire this event (so that we can let someone override the default)
                    assign mweea = new MessageWriterErrorEventArgs(get-class(StringEntityWriter),
                                                                  // NOTE that we're passing a reference to the MEMPTR to not leak
                                                                  new Memptr(get-pointer-value(pmData), get-size(pmData)),
                                                                  copyErr).
                    OnWriteError(mweea).
                    return mweea:BytesWritten.
                end.
                otherwise
                    undo, throw copyErr.
            end case.
        end catch.
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method override public int64 Write(input pcData as character):
        define variable lcData as longchar no-undo.

        assign lcData = pcData.

        return this-object:Write(input lcData).
    end method.
    
    /** Write data to/from the message

        @param handle Data to write */
    method override public int64 Write(input pData as handle):
        var longchar xmlData.
        
        if not valid-handle(pData) then
            return 0.
        
        if pData:type eq string(DataTypeEnum:X-Document) then
        do:
            fix-codepage(xmlData) = 'utf-8':u.
            
            pData:save('longchar':u, xmlData).
            
            this-object:Entity = new String(xmlData).
            
            return length(xmlData, 'raw':u).
        end.
        else
            return 0.
    end method.
    
    /* Event handler for the WriteError event
    
       @param Progress.Lang.Object The type/class raising the event
       @param MessageWriterErrorEventArgs A set of arguments relating to the error */
    method override protected void WriteErrorHandler(input pSender as Progress.Lang.Object,
                                                     input pArgs as MessageWriterErrorEventArgs):
        define variable outData as longchar no-undo.
        
        // someone's already given us new data
        if valid-object(pArgs:OutputData)
        or pArgs:AllowNullOutput
        or not type-of(pArgs:SourceData, IMemptrHolder)
        then
            return.
        
        // we can convert MEMPTR to strings here. If this is something else, leave alone
        fix-codepage(outData) = 'utf-8':u.
        assign outData = base64-encode(cast(pArgs:SourceData, IMemptrHolder):Value).
        
        // default behavior is a DATA URI https://en.wikipedia.org/wiki/Data_URI_scheme
        Logger:Error('Unable to convert MEMPTR to LONGCHAR; using base64-encoded data URI instead', pArgs:Error).
        
        // we don't know what the MIME type should be, so leave out
        assign outData          = 'data:;base64,':u + outData
               pArgs:OutputData = new String(outData)
               .
    end method.
    
end class.