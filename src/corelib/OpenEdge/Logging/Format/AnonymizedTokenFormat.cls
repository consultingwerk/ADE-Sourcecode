/************************************************
Copyright (c) 2018-2019,2021-2022,2024-2025 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AnonymizedTokenFormat
    Purpose     : Anonymises (hashes) specific token values
    Description :
    Author(s)   : pjudge
    Created     : 2018-11-16
    Notes       : 
    - Default property values are
        HashAlgorithm       : SHA-256
        AnonymizeTokens     : CP.QUID,CP.UID
        Salt                : Base64-encoded UUID

    - The anonymised output follows the C crypt format as per https://en.wikipedia.org/wiki/Crypt_(C)
      Specifically, Modular Crypt Format (MCF): $<id>[$<param>=<value>(,<param>=<value>)*][$<salt>[$<hash>]]
      For our purposes this takes the following form:
        $<id>$<salt>$<b64-hash>
        
      The <id> value represents the hashing algorithm, and is one of
          md5     : 1 - DEPRECATED, should be replaced with sha-256
          sha-1   : sha1 - FUTURE DEPRECATION, replace with sha-256
          sha-256 : 5
          sha-512 : 6
        
      The <salt> value follows the radix-64 alphabet (DES uses the decoded value)
        
      The <b64-hash> value is a radix-64 encoded result of hashing the password and salt
------------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.String.
using OpenEdge.Core.Util.Token.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using Progress.Collections.IIterator.
using OpenEdge.Logging.Format.LogMessageTokenResolver.

class OpenEdge.Logging.Format.AnonymizedTokenFormat
inherits LogMessageTokenResolver
implements ILoggerFilter:

    // The mask to use for anonymising the token values
    define private variable mMask as character no-undo.

    /* The salt used for the digest. All messages will have the same salt,
       for this logger filter instance (so in practice, for each logger) */
    define public property Salt as character no-undo
        get.
        set(input pSalt as character):
            Assert:NotNullOrEmpty(pSalt, 'Salt value').

            assign this-object:Salt = pSalt.
        end set.

    /* A comma-separated list of tokens to anonymize. These names should NOT include the ${} characters */
    define public property AnonymizeTokens as character no-undo
        get.
        set.

    /* (optional) The algorithm used to hash the data */
    define public property HashAlgorithm as HashAlgorithmEnum no-undo
        get.
        private set.

    /* Default constructor configured to use SHA-256 */
    constructor public AnonymizedTokenFormat():
        this-object(HashAlgorithmEnum:SHA-256).
    end constructor.

    /* Constructor

       @param HashAlgorithmEnum The algorithm to use to has token data */
    constructor public AnonymizedTokenFormat(input pAlgorithm as HashAlgorithmEnum):
        this-object(pAlgorithm, 'CP.QUID,CP.UID':u).
    end constructor.

    /* Constructor

       @param HashAlgorithmEnum The algorithm to use to has token data
       @param character A CSV list of token to anonymise    */
    constructor public AnonymizedTokenFormat(input pAlgorithm as HashAlgorithmEnum,
                                             input pTokens as character):
        Assert:NotNull(pAlgorithm, 'Hash algorithm').
        Assert:NotNull(pTokens, 'Token list').

        assign this-object:HashAlgorithm   = pAlgorithm
               this-object:AnonymizeTokens = pTokens
               this-object:Salt            = substring(base64-encode(generate-uuid), 1, 22)
               .

        // mMask = $<id>$<salt>$<b64-hash> where "$" is a delimiter.
        case this-object:HashAlgorithm:
            when HashAlgorithmEnum:MD5     then assign mMask = '$':u + string(1). // "1" = md5crypt - Not available when in FIPS mode
            when HashAlgorithmEnum:SHA-1   then assign mMask = '$':u + 'sha1':u.  // "sha1" = SHA-1 - Not recommended when in FIPS mode
            when HashAlgorithmEnum:SHA-256 then assign mMask = '$':u + string(5). // "5" = sha256crypt
            when HashAlgorithmEnum:SHA-512 then assign mMask = '$':u + string(6). // "6" = sha512crypt
            // in case we add others
            otherwise                           assign mMask = '$':u + lc(string(this-object:HashAlgorithm)).
        end case.

        assign mMask = mMask + '$&1$&2':u. // Include placeholders after the algorithm "id" for the salt and hash values.
    end constructor.

    /** Performs implementation-specific filtering for a logger type using a set token pattern.
        Note that if FIPS is enabled, some algorithms (such as MD5) may raise a runtime error.

        @param LogEvent The current log event to filter */
    method public void ExecuteFilter(input pEvent as LogEvent):
        var IIterator<Token> iter.

        // no tokens congfigured to anonymise
        if String:IsNullOrEmpty(this-object:AnonymizeTokens)
        // no tokens in the message
        or not valid-object(pEvent:Message:Tokens)
        then
            return.

        // resolves any unresolved tokens
        ResolveMessageTokens(pEvent:Message:Tokens, pEvent).

        assign iter = pEvent:Message:Tokens:GetIterator().
        TOKEN-LOOP:
        do while iter:MoveNext():
            // In case of unknown values. The LogMessage's Tokens property is a Set, but this code (ie compiler) does not guarantee that.
            if not valid-object(iter:Current)
            or index(this-object:AnonymizeTokens, string(iter:Current)) eq 0
            then
                next TOKEN-LOOP.

            // Apply mask to produce token output of $id$salt$hashed-value
            if iter:Current:AllowUnknownValue
            or not iter:Current:Value eq ?
            then
                assign iter:Current:Value = substitute(mMask, // Mask should be in the format of "$id$&1$&2" where id indicates the hash algorithm in use.
                                                       this-object:Salt, // Insert the salt value configured for this formatter.
                                                       {&_proparse_ prolint-nowarn(overflow)}
                                                       string(base64-encode(message-digest(string(this-object:HashAlgorithm),
                                                                                           iter:Current:Value,
                                                                                           this-object:Salt))) // The hash of the value, using the salt.
                                                       ).
        end.
    end method.
end class.