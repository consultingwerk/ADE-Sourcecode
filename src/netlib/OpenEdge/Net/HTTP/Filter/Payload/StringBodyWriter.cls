/************************************************
Copyright (c) 2015-2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StringBodyWriter
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
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.IO.FileInputStream.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.StringBodyWriter inherits MessageWriter: 
        
    constructor public StringBodyWriter():
        super(get-class(ByteBucket)).
    end constructor.
    
    method override public void Open():    
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.
    
    method override public int64 Write(input pData as memptr):
        define variable lcText as longchar no-undo.
        
        copy-lob from pData to lcText.
        
        return this-object:Write(lcText).        
    end method.
    
    method override public int64 Write(input pData as longchar):
        cast(this-object:Entity, ByteBucket):PutString(pData).
        
        return length(pData, 'raw':u).
    end method.
    
    method override public int64 Write(input poData as Object):
        define variable lcText as longchar no-undo.
        define variable fileStream as FileInputStream no-undo.
        
        case true:
            when not valid-object(poData) then
                return 0.
            
            when type-of(poData, OpenEdge.Core.String) or
            when type-of(poData, ICharacterHolder) or
            when type-of(poData, ILongcharHolder) then
            do:
                assign lcText = dynamic-property(poData, 'Value':u).
                
                // longchars are passed by-value, so don't do that
                cast(this-object:Entity, ByteBucket):PutString(lcText).                
                return length(lcText, 'raw':u).
            end.    // characters
            
            when type-of(poData, FileInputStream) then
            do:
                assign fileStream = cast(poData, FileInputStream).
                case entry(num-entries(fileStream:FileName, '.':u), fileStream:FileName, '.':u):
                    when 'txt':u then
                        return WriteFileStream(fileStream). 
                    otherwise 
                        return error new AppError(substitute('Unsupported file extension .&1 for TXT', 
                                                        entry(num-entries(fileStream:FileName, '.':u), fileStream:FileName, '.':u))
                                        , 0).
                end case.
            end.    // file stream
                        
            otherwise 
            do:
                assign lcText = poData:ToString().
                
                // longchars are passed by-value, so don't do that
                cast(this-object:Entity, ByteBucket):PutString(lcText).                
                return length(lcText, 'raw':u).
            end.
        end case.
        
        return 0.
    end method.

end class.