/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : FormDataEntityWriter
    Purpose     : Converts bytes/characters into a IStringStringMap
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-01-07
    Notes       : - This EntityWriter converts raw data from an HTTP message into
                    an instance of a IStringStringMap.
                  - An EntityWriter is used by the ABL HTTP client to convert body data
                    recieved from the remote server into an a 'strongly typed object',
                    that will become the HttpResponse's Entity.
                  - An EntityWriter can be used by a WebHandler to convert the request body
                    data into a 'strongly typed object', used by the WebRequest.
                    THe WebRequest's GetTypedEntity() method will do this conversion.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.Memptr.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.FormEncoder.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.FormDataEntityWriter
inherits MessageWriter:
    
    // used to decode the form-field names and values
    var private FormEncoder mEncoder.
    
    /* Default constructor */
    constructor FormDataEntityWriter():
        super(get-class(IStringStringMap)).
        
        assign mEncoder = new FormEncoder().
    end constructor.
    
    method override public void Open():
        /* If nothing's passed in, use a StringStringMap of our own.
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = new StringStringMap().
        
        super:Open().
    end method.
    
    /* Writes data that's assumed to be form-encoding.
       
       This method only accepts
       - IStringIStringMap: All entries are added to the current form data entity
       - ILongcharHolder, ICharacterHolder: calls the Write(longchar) method
       - OpenEdge.Core.Memptr, ByteBucket: calls the Write(memptr) method
       
       Field names and values are decoded.
       
       @param Object An object containing form data
       @return int64 The number of bytes written. */
    method override public int64 Write(input pData as Object):
        var longchar val.
        var int64 bytesWritten, size.
        
        if not valid-object(pData) then
            return 0.
        
        if type-of(pData, IStringStringMap) then
        do:
            cast(this-object:Entity, IStringStringMap):PutAll(cast(pData, IStringStringMap)).
            return 0.
        end.
        
        if type-of(pData, ILongcharHolder)
        or type-of(pData, ICharacterHolder)
        then
        do:
            // coerce into using the LONGCHAR version
            assign val = dynamic-property(pData, 'Value':u).
            return this-object:Write(val).
        end.
        
        if type-of(pData, Memptr) then
        do:
            assign size         = cast(pData, Memptr):Size
                   bytesWritten = this-object:Write(cast(pData, Memptr):GetString(1)).
            if not bytesWritten eq size then
                Logger:Warn(substitute('Input data size is &1; only &2 bytes written', size, bytesWritten)).
            
            return bytesWritten.
        end.
        
        if type-of(pData, ByteBucket) then
        do:
            assign size         = cast(pData, ByteBucket):Size
                   bytesWritten = this-object:Write(cast(pData, ByteBucket):GetString()).
            if not bytesWritten eq size then
                Logger:Warn(substitute('Input data size is &1; only &2 bytes written', size, bytesWritten)).
            
            return bytesWritten.
        end.
        
        // if we get here we can't convert
        return error new AppError(substitute('Unsupported object type: &1', pData:GetClass():TypeName), 0).
    end method.
    
    /* Writes form-data from a memptr. The first string in the memptr is passed to the Write(longchar) method;
       this may not be the entire memptr data.
       
       @param memptr A memptr containing form data. It is the caller's responsibility to clean up the memptr
       @return int64 The number of bytes written */
    method override public int64 Write(input pData as memptr):
        var int64 bytesWritten, size = get-size(pData).
        
        assign bytesWritten = this-object:Write(get-string(pData, 1)).
        
        if not bytesWritten eq size then
            Logger:Warn(substitute('Input data size is &1; only &2 bytes written', size, bytesWritten)).
        
        return bytesWritten.
    end method.
    
    /* Writes character form data.
       
       Field names and values are decoded.
       
       @param memptr A memptr containing form data. It is the caller's responsibility to clean up the memptr
       @return int64 The number of bytes written */
    method override public int64 Write(input pData as character):
        var longchar lcData = pData.
        
        return this-object:Write(lcData).
    end method.
    
    /* Writes longchar form data.
       
       Field names and values are decoded.
       
       @param longchar Form data
       @return int64 The number of bytes written */
    method override public int64 Write(input pData as longchar):
        var int64 startAt, pos, bytesWritten = length(pData, 'raw':u).
        var character fld.
        
        if bytesWritten eq 0
        or bytesWritten eq ?
        then
            return 0.
        
        assign pos     = index(pData, '&':u)
               startAt = 1
               .
        do while pos gt 0:
            assign fld     = substring(pData, startAt, pos - startAt)
                   startAt = pos + 1
                   pos     = index(pData, '&':u, startAt)
                   .
            AddField(fld).
        end.
        
        // the last pair. pos = 0 here
        if startAt le bytesWritten then
        do:
            assign fld = substring(pData, startAt).
            AddField(fld).
        end.
        
        return bytesWritten.
    end method.
    
    /* Adds a form field to the intenal map. Field names and values are decoded before storing.
       If the field value passed in does not have an "=" character, then the whole value is used
       as the field name, and an empty/blank value.
       
       @param character A name=value 'field' */
    method private void AddField(input pFld as character):
        var int64 pos.
        var character fldName, fldValue.
        var IStringStringMap ssm = cast(this-object:Entity, IStringStringMap).
        
        assign pos = index(pFld, '=':u).
        if pos eq 0 then
            assign fldName  = pFld
                   fldValue = '':u
                   .
        else
            assign fldName  = substring(pFld, 1, pos - 1)
                   fldValue = substring(pFld, pos + 1)
                   .
        
        
        assign
            {&_proparse_ prolint-nowarn(overflow)}
            fldName  = mEncoder:Decode(fldName)
            {&_proparse_ prolint-nowarn(overflow)}
            fldValue = mEncoder:Decode(fldValue)
            .
        ssm:Put(fldName, fldValue).
    end method.
    
end class.