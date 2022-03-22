/************************************************
Copyright (c) 2018, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AnonymizedTokenFormatBuilder
    Purpose     : Builds a AnonymizedTokenFormat logging filter 
    Author(s)   : pjudge
    Created     : 2018-11-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.Format.AnonymizedTokenFormat.

class OpenEdge.Logging.AnonymizedTokenFormatBuilder inherits LogFilterBuilder: 
    /* Constructor */
    constructor public AnonymizedTokenFormatBuilder(input filterName as character):
        super(filterName).
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
        
        if HasOption('tokensToAnon':u) then
            assign atf:AnonymizeTokens = GetOptionStringValue('tokensToAnon':u).
        
        if type-of(atf, ISupportInitialize) then
            cast(atf, ISupportInitialize):Initialize().
        
        return atf.
    end method.
    
end class.