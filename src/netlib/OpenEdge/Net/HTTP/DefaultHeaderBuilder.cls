/************************************************
Copyright (c) 2015, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : DefaultHeaderBuilder
    Purpose     : Simple, general header builder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 13 13:35:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Core.Assert.

class OpenEdge.Net.HTTP.DefaultHeaderBuilder inherits HttpHeaderBuilder: 

    /** Each concrete builder will implement this differently */
    define override public property Header as HttpHeader no-undo
        get():
            if not valid-object(this-object:Header) then
                assign this-object:Header = NewHeader().
            
            return this-object:Header.
        end get.
        private set.
    
    /*  Constructor
        @param character The header name */
    constructor public DefaultHeaderBuilder(input pcHeaderName as character):
        super(pcHeaderName).
    end constructor.
    
    /* Creates a new instance of a HttpHeader based on the builder's options.
       
       @return HttpHeader A new HttpHeader instance */
    method protected HttpHeader NewHeader():
        define variable oHeader as HttpHeader no-undo.
        define variable oHeaderType as class Progress.Lang.Class no-undo.
        
        define buffer opt for ConfigOption.
        
        if HasOption(get-class(HttpHeader):TypeName) then
            assign oHeaderType = cast(GetOptionObjectValue(get-class(HttpHeader):TypeName), Progress.Lang.Class).
        else
            assign oHeaderType = get-class(HttpHeader). 
        
        Assert:IsType(oHeaderType, get-class(HttpHeader)).
        
        oHeader = dynamic-new string(oHeaderType:TypeName) (input this-object:HeaderName).
        
        if type-of(oHeader, ISupportInitialize) then
            cast(oHeader, ISupportInitialize):Initialize().
        
        if HasOption('paramDelimiter':u) then
            assign oHeader:ParamDelimiter = GetOptionStringValue('paramDelimiter':u).
        
        if HasOption('hdrValue':u) then
            assign oHeader:Value = GetOptionStringValue('hdrValue':u).
        
        // Length since spaces are allowed as delimiters. Nulls aren't
        if length(oHeader:ParamDelimiter, 'raw':u) gt 0 then
        for each opt where
                 opt.ParentBuilder eq int64(this-object) and
                 opt.ConfigName begins 'param+':u:
            oHeader:SetParameterValue(substring(opt.ConfigName, 7), opt.StringValue).
        end.
        
        return oHeader.        
    end method.
    
end class.