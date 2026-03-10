/*************************************************************************
Copyright (c) 2021,2023,2025 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : EncodedString
    Purpose     : Encodes a clear-text string using any supported encryption
                  algorithm via EncodingTypeEnum, or nopr0 for clear-text
    Description :
    Author(s)   : pjudge
    Created     : 2020-12-06
    Notes       : This class is intended as a helper for encoding strings in such
  a way that it minimizes exposure of the original value to 4GLTrace or logging:

  - The class is final to prevent unintentional exposure of the value
  - The Value property must never use a setter implementation
  - The Value property must never be overridden
    (Property overrides are not available in 12.4 but may be in a future release)
  - The Value must never be passed in via constructor argument nor into any method
  - This class is NOT serializable because we cannot guarantee that
    the Value has been encoded, nor that the Value getter is called

This class DOES NOT implement any new encoding mechanisms itself, it merely uses
the encoding capabilities already available within the OpenEdge ABL.

Please be aware that the Value will remain un-encoded so long as an encoding
type is not set, and no default will be provided. As a developer, you MUST
choose AND set an EncodingTypeEnum by either passing with the Constructor or
set via the Encoding property if you expect the supplied Value to be encoded!
------------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.EncodingTypeEnum.
using OpenEdge.Core.EncodedString.
using Progress.Collections.IHashable.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.EncodedString
implements ILongcharHolder
         , IHashable
final:

    var private character cSeparator = '::':u.

    // A private list of the encoding names. Cached once per session, on demand. Used by the Value getter
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

    /* (mandatory) The encoding to use when reading the value - DO NOT set a default! */
    define public property Encoding as EncodingTypeEnum no-undo
        get():
            return mEncoding.
        end get.
        set(input pEncoding as EncodingTypeEnum):
            Assert:NotNull(pEncoding, 'Encoding Type').

            assign mEncoding = pEncoding.

            // Force the encoding to be set correctly, and the value too.
            {&_proparse_ prolint-nowarn(exprnofx)}
            this-object:Value. // Performs a GET on the property.
        end set.

    /**
        The value that should never be seen (ie always encoded). For all non-null values, the encoding is the first 7 characters,
        even for nopr0 encoding (plain text). Null values return as null.

         If the Value has already been encoded, return that value. This may set the Encoding property to match the value.
         If the Value is null, return that value.
         If the value is unencoded and the Encoding is not NOPR0 or a non-retired algorithm, then throw an error.
         Strings that are encoded using other prefixes may have been encrypted using the genpassword tool and passed
         in with the appropriate encoding type prefix--those are allowed to pass-through and be used, unchanged.
         Otherwise, encode the value per the Encoding property, and save.
     */
    define public property Value as longchar no-undo
        get():
            // INLINE code otherwise we're going to recurse getting the Value
            var character cExistingEncoding.

            // If the encoding is not yet set, or if the value is already encoded, or if there's no encoding passed in,
            // then do nothing but return. We must do this as there are many internal references to "this-object:Value"
            // which will need the un-encoded or newly-encoded value.
            if this-object:Value eq ? or not valid-object(mEncoding) or this-object:Value begins (string(mEncoding) + cSeparator)
            then
                return this-object:Value.

            // The string is encoded, but not with the input encoding. We must decide how to proceed.
            if length(this-object:Value) gt 7 and substring(this-object:Value, 6, 2) eq cSeparator then
            do:
                // There's a chance that the separator ("::") is part of the passphrase
                assign cExistingEncoding = substring(this-object:Value, 1, 5).

                if cExistingEncoding eq string(EncodingTypeEnum:nopr0) then
                do:
                    // If the Value is encoded as nopr0 (eg. clear-text) and a new encoding type is provided,
                    // strip the encoding prefix from the string and prepare to use the new encoding chosen.
                    assign this-object:Value = substring(this-object:Value, 8).
                end.
                else if not cExistingEncoding eq string(mEncoding) and
                            lookup(cExistingEncoding, EncodedString:EncodingNames) gt 0 then
                do:
                    // If the Value is encoded as any other type, and the prefix is a non-retired,
                    // then allow the existing encoded Value to pass-through unchanged.
                    assign
                        mEncoding  = EncodingTypeEnum:GetEnum(cExistingEncoding)
                        mValLength = length(this-object:Value, 'raw':u)
                        .
                    return this-object:Value.
                end.
                else do:
                    // The Value must be encoded as a retired type which can no longer be used,
                    // simply set the length but pass-through the value (it cannot be changed).
                    assign mValLength = length(this-object:Value, 'raw':u).
                    return this-object:Value.
                end.
            end. // may be encoded

            if mEncoding eq EncodingTypeEnum:nopr0 then do:
                // The no-encoding option means we store the Value as cleartext (with the prefix).
                assign
                    this-object:Value = string(EncodingTypeEnum:nopr0) + cSeparator + this-object:Value
                    mEncoding         = EncodingTypeEnum:nopr0
                    .
            end.
            else if lookup(string(mEncoding), EncodedString:EncodingNames) gt 0 then do:
                // Allow any valid encoding prefix (encryption algorithm) in the list of non-retired options.
                {&_proparse_ prolint-nowarn(overflow)}
                assign this-object:Value = audit-policy:encrypt-audit-mac-key(string(this-object:Value), string(mEncoding)).
            end.
            else
                // If we are unable to encode the value in ABL, throw an error. [Should never get here, but regardless...]
                undo, throw new AppError(substitute('Unsupported encoding "&1" for plain-text values. Supported encodings: &2',
                                                    string(mEncoding), EncodedString:EncodingNames), 0).

            assign mValLength = length(this-object:Value, 'raw':u).
            return this-object:Value.
        end.
        // NEVER use a setter function, since that could expose the un-encoded Value to 4GLTrace logging.
        set.

    /* Default constructor. */
    constructor public EncodedString ( ):
        assign this-object:Value = ?.
        fix-codepage(this-object:Value) = 'utf-8':u.
    end constructor.

    /* Constructor.

       @param EncodingTypeEnum The encoding to use */
    constructor public EncodedString (input pEncoding as EncodingTypeEnum):
        this-object().

        assign this-object:Encoding = pEncoding.
    end constructor.

    /* Destructor */
    destructor EncodedString ( ):
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

    method override public logical Equals (input pRef as Progress.Lang.Object ):
        return (type-of(pRef, ILongcharHolder)
                and this-object:Value eq cast(pRef, ILongcharHolder):Value).
    end method.

    method override public character ToString ():
        {&_proparse_ prolint-nowarn(overflow)}
        return string(this-object:Value).

        // if the value is > 32k in length, return the default ToString value
        {&_proparse_ prolint-nowarn(varusage)}
        catch uncaught as Progress.Lang.Error:
            return super:ToString().
        end catch.
    end method.

    /* Hashing method for creating a proper index for use with Progress.Collections.HashMap

        @return integer Result of the hash-code method using this object's comparable value(s) */
    method public integer HashCode ( ):
        // In order to create a meaningful hash for an object instance,
        // we should follow suite with how the Equals() logic works.
        // By using the full class name plus the object's comparable value(s)
        // this should be consistent for any instance of this object type.
        return hash-code(this-object:GetClass():TypeName, this-object:Value).
    end method.

end class.
