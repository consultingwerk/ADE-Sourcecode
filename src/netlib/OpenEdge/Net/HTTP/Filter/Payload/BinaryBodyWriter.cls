/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BinaryBodyWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.ISupportTransferEncoding.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.BinaryBodyWriter inherits MessageWriter
            implements ISupportTransferEncoding: 

    /* Transfer encoding (eg base63 or binary or 7bit or 8bit etc ) used by the implementer */		
	define public property TransferEncoding as character no-undo get. set.

	constructor public BinaryBodyWriter():
	    super(get-class(ByteBucket)).
	end constructor.
	
    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method override public void Open():
        /* If nothing's passed in, use a bucket of our own. 
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
            
        super:Open().
    end method.
    
	method override public int64 Write( input poData as Object):
        Assert:NotNull(poData).
        
        case poData:GetClass():
            when get-class(Memptr) then
                cast(this-object:Entity, ByteBucket):PutBytes(
                                cast(poData, Memptr):GetPointerValue(), 
                                cast(poData, Memptr):Size ).
            when get-class(ByteBucket) then
                cast(this-object:Entity, ByteBucket):PutBytes(cast(poData, ByteBucket)).            
            when get-class(String) then
                cast(this-object:Entity, ByteBucket):PutString(cast(poData, String)).            
            otherwise 
                return error new AppError(
                                substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                                , 0).
        end case.
        
        assign this-object:TransferEncoding = 'binary':u.
        
        return dynamic-property(poData, 'Size':u).
	end method.

end class.