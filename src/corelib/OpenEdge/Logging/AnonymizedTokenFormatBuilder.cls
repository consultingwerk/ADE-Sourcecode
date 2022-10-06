/************************************************
Copyright (c) 2018, 2021-2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AnonymizedTokenFormatBuilder
    Purpose     : Builds a AnonymizedTokenFormat logging filter
    Author(s)   : pjudge
    Created     : 2018-11-08
    Notes       : To configure this filter in a logging.config file, use one or more of the
                  following properties
                    hashAlgo    : The name of the hashing algorithm to use. See OpenEdge.Logging.Format.AnonymizedTokenFormat for
                                  valid values
                    hashSalt    : The value of a salt to use for hashing. This property is mainly for testing purposes. The value
                                  may contain tokens (so that, for example, a timestamp may be used as the salt).
                    tokensToAnon: a csv list of tokens to anonymise. Tokens should NOT include the ${} characters
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.Format.AnonymizedTokenFormat.
using OpenEdge.Core.Util.TokenResolver.

class OpenEdge.Logging.AnonymizedTokenFormatBuilder inherits LogFilterBuilder:
    /* Constructor
       
       @param character The filter name */
    constructor public AnonymizedTokenFormatBuilder(input pFilterName as character):
        super(pFilterName).
    end constructor.
    
    /* Creates the instance.
       
       @return ILoggerFilter A filter instance  */
    method override protected ILoggerFilter NewFilter(  ):
        define variable atf as AnonymizedTokenFormat no-undo.
        define variable filterType as class Progress.Lang.Class no-undo.
        define variable hashAlgo as HashAlgorithmEnum no-undo.
        
        assign filterType = GetFilterType(this-object:FilterType).
        if not valid-object(filterType) then
            return atf.
        
        if HasOption('hashAlgo':u) then
            assign hashAlgo = HashAlgorithmEnum:GetEnum(GetOptionStringValue('hashAlgo':u)).
        
        if valid-object(hashAlgo) then
            atf = dynamic-new string(filterType:TypeName) (hashAlgo).
        else
            atf = dynamic-new string(filterType:TypeName) ().
        
        if HasOption('hashSalt') then
            assign atf:Salt = TokenResolver:Resolve(GetOptionStringValue('hashSalt')).
        
        if HasOption('tokensToAnon':u) then
            assign atf:AnonymizeTokens = GetOptionStringValue('tokensToAnon':u).
        
        if type-of(atf, ISupportInitialize) then
            cast(atf, ISupportInitialize):Initialize().
        
        return atf.
    end method.
    
end class.