/************************************************
Copyright (c) 2018-2019, 2021-2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AnonymizedTokenFormat
    Purpose     : Anonymises (hashes) specific token values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2018-11-16
    Notes       : - Default property values are
                        HashAlgorithm       : SHA-256
                        AnonymizeTokens     : CP.QUID,CP.UID
                        Salt                : Base64-encoded UUID
                  
                  - The anonymised output follows the C crypt format as per https://en.wikipedia.org/wiki/Crypt_(C)
                    This takes the form of
                        $<id>$<salt>$<b64-hash>
                    
                    The <id> value represents the hashing algorithm, and is one of
                        md5     : 1
                        sha-1   : sha1
                        sha-256 : 5
                        sha-512 : 6
  ----------------------------------------------------------------------*/
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
    
    /* Default constructor */
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
        //mMask = $id$salt$hashed
        case this-object:HashAlgorithm:
            when HashAlgorithmEnum:MD5      then assign mMask = '$':u + string(1).
            when HashAlgorithmEnum:SHA-1    then assign mMask = '$':u + 'sha1':u.
            when HashAlgorithmEnum:SHA-256  then assign mMask = '$':u + string(5).
            when HashAlgorithmEnum:SHA-512  then assign mMask = '$':u + string(6).
            // in case we add others
            otherwise                            assign mMask = '$':u + lc(string(this-object:HashAlgorithm)).
        end case.
        assign mMask = mMask + '$&1$&2':u.
    end constructor.
    
    /** Performs implementation-specific filtering for a logger type
        
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
            
            //$id$salt$hashed-value
            if iter:Current:AllowUnknownValue
            or not iter:Current:Value eq ?
            then
                assign iter:Current:Value = substitute(mMask,
                                                       this-object:Salt,
                                                       base64-encode(message-digest(string(this-object:HashAlgorithm),
                                                                     iter:Current:Value,
                                                                     this-object:Salt ))
                                            )
                       .
        end.
    end method.
end class.