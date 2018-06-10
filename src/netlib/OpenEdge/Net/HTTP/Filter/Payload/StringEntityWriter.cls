/************************************************
Copyright (c) 2015, 2018 by Progress Software Corporation. All rights reserved.
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
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.ISupportEncoding.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.StringEntityWriter inherits MessageWriter
            implements ISupportEncoding:
    
    /* Content encoding (eg utf-8) used used by this writer */ 
    define public property Encoding as character no-undo get. set.
     
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
        
        this-object:Entity = new String(pcData).
        
        return iBytesWritten.
    end method.
    
    method override public int64 Write(input pmData as memptr):        
        define variable lcData as longchar no-undo.
        define variable cCharset as character no-undo.
        define variable cOECodepage as character no-undo.
        define variable iBytesWritten as int64 no-undo.
        
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
        
        if iBytesWritten gt 0 then
            copy-lob from pmData 
                     to lcData
                     convert source codepage cOECodepage.
        
        assign this-object:Entity = new String(lcData).
        
        return iBytesWritten. 
    end method.
    
    /** Write data to/from the message
        
        @param character Data to write */
    method override public int64 Write(input pcData as character):    
        define variable lcData as longchar no-undo.
        
        assign lcData = pcData.
        
        return this-object:Write(input lcData).
    end method.    
    
end class.