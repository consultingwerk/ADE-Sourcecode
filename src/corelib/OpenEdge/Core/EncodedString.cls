/*************************************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : EncodedString
    Purpose     : Encodes a clear-text string as either OECH1, ODEB1 or NOPR0 (cleartext)
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2020-12-06
    Notes       : - The class is final to prevent unintentional exposure of the value
                  - The Value property must never use a setter implementation
                  - The Value property must never be overridden (not available in 12.4 but may be a future feature)
                  - The Value must never be passed in via constructor argument, or in to any method
                  - This class is NOT serializable because we cannot guarantee that the Value has been encoded,
                    nor that the Value getter is called
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.EncodingTypeEnum.
using OpenEdge.Core.EncodedString.
using Progress.Lang.AppError.

class OpenEdge.Core.EncodedString
implements ILongcharHolder  
final:
    /* A private list of the encoding names. Cached once per session, on demand. Used by the Value getter */
    // needs the preprocessor due to https://github.com/Riverside-Software/sonar-openedge/issues/865
    {&_proparse_ prolint-nowarn(varusage)}
    define static private property EncodingNames as character no-undo
        get():
            if EncodedString:EncodingNames eq '':u then
                assign EncodedString:EncodingNames = get-class(EncodingTypeEnum):GetEnumNames().
            
            return EncodedString:EncodingNames.
        end get.
        set.
    
    // Backing store variable for the Encoding property. A separate variable is used because setting the Encoding or Value
    // can change this value, and raises the potential of getting stuck in an endless loop.
    var private EncodingTypeEnum mEncoding.
    
    // Holds the length in bytes of the value, so that we don't have to recalc it in the destructor, and (yet again)
    // get all recursive
    var private integer mValLength = ?.
    
    /* (mandatory) The encoding to use when reading the value */
    define public property Encoding as EncodingTypeEnum no-undo
        get():
            return mEncoding.
        end get.
        set(input pEncoding as EncodingTypeEnum):
            Assert:NotNull(pEncoding, 'Encoding Type').
            
            assign mEncoding = pEncoding.
            
            // force the encoding to be set correctly, and the value too
            this-object:Value.
        end set.
    
    /* The value that should never be seen (ie always encoded). For all non-null values, the encoding is the
       first 7 characters, even for nopr0 encoding (plain text). Null values return as null
       
       If the Value has already been encoded, return that value. This may set the Encoding property to match the value.
       If the Value is null, return that value.
       If the value is unencoded and the Encoding is not OECH1 or NOPR0, then throw an error. Strings that are encoded using
       other encodings may be encoded using the genpassword tool and passed in with the appropriate encoding prefix.
       Otherwise encode the value per the Encoding, and save.       */
    define public property Value as longchar no-undo
        get():
            // INLINE code otherwise we're going to recurse getting the Value
            var character enc.
            
            // if the encoding isn't yet set, or if the value is already encoded,
            // or if there's no encoding passed in, do nothing.
            if this-object:Value eq ?
            or not valid-object(mEncoding)
            or this-object:Value begins (string(mEncoding) + '::':u)
            then
                return this-object:Value.
            
            // the string is encoded, but not with the input encoding
            if  length(this-object:Value) gt 7
            and substring(this-object:Value, 6, 2) eq '::':u
            then
            do:
                // there's a chance that :: is part of the passphrase
                assign enc = substring(this-object:Value, 1, 5).
                // if the Value is encoded as nopr0 (ie clear-text) and a new encoding is provided,
                // encode into the new encoding
                if enc eq string(EncodingTypeEnum:nopr0) then
                    assign this-object:Value = substring(this-object:Value, 8).
                else
                if not enc eq string(mEncoding)
                and lookup(enc, EncodedString:EncodingNames) gt 0
                then
                do:
                    assign mEncoding  = EncodingTypeEnum:GetEnum(enc)
                           mValLength = length(this-object:Value, 'raw':u)
                           .
                    return this-object:Value.
                end.
            end.    // may be encoded
            
            // the string needs encoding: we have limited options in ABL
            case mEncoding:
                when EncodingTypeEnum:oech1 then
                    assign this-object:Value = 'oech1::':u + audit-policy:encrypt-audit-mac-key(string(this-object:Value)).
                when EncodingTypeEnum:nopr0 then
                    assign this-object:Value = 'nopr0::':u + this-object:Value
                           mEncoding         = EncodingTypeEnum:nopr0
                           .
                // if we are unable to encode the value in ABL, throw an error
                otherwise
                    undo, throw new AppError(substitute('Unsupported encoding "&1" for plain-text values. Supported encodings: "oech1" or "nopr0"',
                                                        string(mEncoding)), 0).
            end case.
            
            assign mValLength = length(this-object:Value, 'raw':u).
            return this-object:Value.
        end.
        // NEVER use a setter function, since that will expose the value to 4GLTrace logging
        set.
    
    /* Default constructor. */
    constructor public EncodedString():
        assign this-object:Value = ?.
        fix-codepage(this-object:Value) = 'utf-8'.
    end constructor.
    
    /* Constructor.
       
       @param EncodingTypeEnum The encoding to use */
    constructor public EncodedString(input pEncoding as EncodingTypeEnum):
        this-object().
        
        assign this-object:Encoding = pEncoding.
    end constructor.
    
    /* Destructor */
    destructor EncodedString():
        var memptr data.
        var int64 loop.
        
        // Overwrite the the Value with rubbish.
        if mValLength gt 0 then
        do:
            set-size(data) = mValLength.
            do loop = 1 to mValLength:
                // something non-null and rando, "BS"
                put-byte(data, loop) = 8.
            end.
            copy-lob from data to this-object:Value.
        end.
        
        finally:
            set-size(data) = 0.
        end finally.
    end destructor.
    
    method override public logical Equals(input pRef as Progress.Lang.Object ):
        return (type-of(pRef, ILongcharHolder)
                and this-object:Value eq cast(pRef, ILongcharHolder):Value).
    end method.
    
    method override public character ToString():
        return string(this-object:Value).
        
        // if the value is > 32k in length, return the default ToString value
        {&_proparse_ prolint-nowarn(varusage)}
        catch uncaught as Progress.Lang.Error:
            return super:ToString().
        end catch.
    end method.
end class.
 