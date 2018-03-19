/************************************************
Copyright (c) 2015-2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HtmlBodyWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.IO.FileInputStream.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.HtmlBodyWriter inherits MessageWriter: 
    
    constructor public HtmlBodyWriter():
        super (get-class(ByteBucket)).
    end constructor.

    method override public void Open():
        /* If nothing's passed in, use a bucket of our own. 
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.
    
    method override public int64 Write(input pData as longchar):
        cast(this-object:Entity, ByteBucket):PutString(pData).
        
        return length(pData, 'raw':u).
    end method.
    
    method override public int64 Write(input pData as memptr):
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(pData), get-size(pData)).
        
        return get-size(pData).
    end method.
    
    method override public int64 Write( input poData as Object):
        define variable lcHtml as longchar no-undo.
        define variable mHtml as memptr no-undo.
        define variable fileStream as FileInputStream no-undo.
        
        case true:
            when not valid-object(poData) then
                return 0.
            
            when type-of(poData, OpenEdge.Core.String) or
            when type-of(poData, ICharacterHolder) or
            when type-of(poData, ILongcharHolder) then
            do:
                // coerce into using the LONGCHAR version
                assign lcHtml = dynamic-property(poData, 'Value':u).
                
                // longchars are passed by-value, so don't do that
                cast(this-object:Entity, ByteBucket):PutString(lcHtml).                
                return length(lcHtml, 'raw':u).
            end.    // characters
            
            when type-of(poData, FileInputStream) then
            do:
                assign fileStream = cast(poData, FileInputStream).
                
                case entry(num-entries(fileStream:FileName, '.':u), fileStream:FileName, '.':u):
                    when 'html':u or
                    when 'htm':u then
                        return WriteFileStream(fileStream). 
                    otherwise 
                        return error new AppError(substitute('Unsupported file extension .&1 for HTML',
                                                        entry(num-entries(fileStream:FileName, '.':u), fileStream:FileName, '.':u))
                                        , 0).
                end case.
            end.    // file stream 
            
            otherwise 
                return error new AppError(
                                substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                                , 0).
        
        end case.
        
        return 0.
    end method.

end class.