/************************************************
Copyright (c) 2015-2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HttpHeader
    Purpose     : A basic HTTP header. Can be extended for headers that have multi-part values
                  (like Content-Type which has an optional charset= part.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Feb 11 11:49:10 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.NullHeader.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.String.

class OpenEdge.Net.HTTP.HttpHeader:
    // holds the parameters for all headers (keyed off the header 'instance id')
    define static private temp-table HeaderParameter no-undo
        field ParentHeader as int64 
        field ParamName as character
        field ParamValue as character
        index idx1 as primary ParentHeader.
    
    /* A null header allows chaining of GetHeader() calls even if
       there is no header defined. */
    define static public property NullHeader as HttpHeader no-undo
        get():
            if not valid-object(HttpHeader:NullHeader) then
                assign HttpHeader:NullHeader = new NullHeader().
            return HttpHeader:NullHeader.
        end get.
        set.
    
    /** (mandatory) The name of the header */
    define public property Name as character no-undo get. protected set.
    
    /* Private Value holder so that we can customise the accessor and mutator */
    define private variable mValue as character no-undo.
    
    /** A header value */
    define public property Value as character no-undo
        get():
            return this-object:GetValue().
        end get.
        set(input pcValue as character):
            this-object:SetValue(pcValue).
        end set.
    
    /** (optional) delimiter for header parameters */
    define public property ParamDelimiter as character no-undo
        get.
        set(input pcParamDelimiter as character):
            Assert:NotNull(pcParamDelimiter, 'Parameter delimiter').
            assign this-object:ParamDelimiter = pcParamDelimiter. 
        end set. 
    
    /* Constructor
        
       @param character The header name
       @param character The header value */
    constructor public HttpHeader(input pcName as character,
                                  input pcValue as character):
        this-object(pcName).
        
        assign this-object:Value = pcValue.
    end constructor.
    
    /* Default constructor */
    constructor private HttpHeader():        
    end constructor.
    
    /** Constructor
        
        @param character The header name */
    constructor public HttpHeader(input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        assign this-object:Name = pcName.
    end constructor.
    
    destructor HttpHeader():
        ClearParams().
    end destructor.
    
    /** Removes any parameter records for this header. */
    method protected void ClearParams():
        define buffer hdrParam for HeaderParameter.
        
        for each hdrParam where hdrParam.ParentHeader eq int64(this-object):
            delete hdrParam.
        end.
    end method.
    
    /* Returns a stringified version of this header object 
       
       @return character A stringified representation of this object */
    method override public character ToString():
        return substitute('&1: &2&3',
                           trim(this-object:Name),
                           this-object:GetBaseValue(),
                           this-object:GetParameterValues()).
    end method.
    
    /** Extracts/separates any parameters from the header's value, and stores the 'clean' value. */
    method public void ExtractParameters():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cParam as character no-undo.
        define variable cValue as character no-undo.
        define variable cName as character no-undo.
        define variable iLength as integer no-undo.
        define variable iPos as integer no-undo.
        
        Assert:NotNullOrEmpty(this-object:ParamDelimiter, 'Param delimiter').
        
        assign iMax = num-entries(this-object:Value, this-object:ParamDelimiter).
        /* first entry is the content type (eg text/plain) */
        do iLoop = 2 to iMax:
            assign cParam  = trim(entry(iLoop, this-object:Value, this-object:ParamDelimiter))
                   /* the parameter value may contain quoted = characters, so use everthing from the 
                      first = onwards as a value. */
                   iPos    = index(cParam, '=':u)
                   cName   = entry(1, cParam, '=':u)
                   cValue  = substring(cParam, iPos + 1) 
                   iLength = length(cValue, 'raw':u)
                   .
            
            //Ignore empty/blank entries 
            if cName eq '':u then
                next.
            
            SetParameterValue(cName, cValue).
        end.
    end method.
    
    /** Indicates whether a parameter exists in the header
    
        @param character The name of the parameter to check.
        @return logical True if the parameter exists. */    
    method public logical HasParameter(input pcParamName as character):
        define buffer hdrParam for HeaderParameter.
        
        Assert:NotNullOrEmpty(pcParamName, 'Param name').
        
        return can-find(first hdrParam where
                              hdrParam.ParentHeader eq int64(this-object) and
                              hdrParam.ParamName    eq pcParamName).
    end method.
    
    /** Saves a parameter value for a header.
        
        @param character (mandatory) The name of the parameter value to retrieve
        @param character (mandatory) The parameter value; blank/empty otherwise 
        @return logical  TRUE when the parameter was replaced/previously existed. */
    method public logical SetParameterValue(input pcParamName as character,
                                            input pcParamValue as character):
        define variable lExists as logical no-undo.
        define buffer hdrParam for HeaderParameter.
        
        Assert:NotNullOrEmpty(this-object:ParamDelimiter, 'Param delimiter').
        Assert:NotNullOrEmpty(pcParamName, 'Param name').
        Assert:NotNull(pcParamValue, 'Param value').
        
        assign lExists = can-find(first hdrParam where
                                        hdrParam.ParentHeader eq int64(this-object) and
                                        hdrParam.ParamName    eq pcParamName).
        if lExists then
            find first hdrParam where
                       hdrParam.ParentHeader eq int64(this-object) and
                       hdrParam.ParamName    eq pcParamName
                       .
        else
        do:
            create hdrParam.
            assign hdrParam.ParentHeader = int64(this-object)
                   hdrParam.ParamName    = pcParamName.
        end.
        assign hdrParam.ParamValue  = pcParamValue.
        
        return lExists.                                                
    end method.
        
    /** Returns a parameter from a (for example, 'charset' from Content-Type) header value 
        
        @param character  The name of the parameter value to retrieve
        @return character The charset paremeter value; blank/empty otherwise */
    method public character GetParameterValue(input pcParamName as character):
        define buffer hdrParam for HeaderParameter.
        
        Assert:NotNullOrEmpty(pcParamName, 'Param name').
        
        /* blank delimiter means no parameters */        
        if this-object:ParamDelimiter eq '':u then
            return '':u.
        
        if can-find(first hdrParam where
                          hdrParam.ParentHeader eq int64(this-object) and
                          hdrParam.ParamName    eq pcParamName)
        then
            find first hdrParam where
                       hdrParam.ParentHeader eq int64(this-object) and
                       hdrParam.ParamName    eq pcParamName
                       .
        if available hdrParam then
            return hdrParam.ParamValue.
        
        return '':u.
    end method.
    
    /* Overridable mutator method 
       
       @param character The header value */
    method protected void SetValue(input pcValue as character):
        define variable iLength as integer no-undo.
        
        this-object:Validate(pcValue). 
        
        if this-object:ParamDelimiter ne '':u then
        do:
            assign mValue = pcValue.
            ExtractParameters().
        end.
        else
        do:
            assign iLength = length(pcValue, 'raw':u).
            
            /* strip off any quotation marks */
            if     substring(pcValue, 1,       1) eq StringConstant:DOUBLE_QUOTE 
               and substring(pcValue, iLength, 1) eq StringConstant:DOUBLE_QUOTE 
            then
                assign pcValue = substring(pcValue, 2, iLength - 2, 'raw':u).
            
            assign mValue = pcValue.
        end.
    end method.
    
    /* Overridable accessor method
    
       @return character The Value */
    method protected character GetValue():
        return mValue.
    end method.
    
    /** Returns the unparameterised value for this header.
        
        @return character The value. */
    method public character GetBaseValue():
        if this-object:ParamDelimiter eq '':u then
            return this-object:Value.
        else
            return entry(1, this-object:Value, this-object:ParamDelimiter).
    end method.

    /** Returns the unparameterised value for this header.
        
        @return character The value. */
    method public character GetParameterValues():
        define variable cValue as character no-undo.
        define variable cParameters as character no-undo.
        define variable cDelim as character no-undo.
        
        define buffer hdrParam for HeaderParameter.
        
        /* blank delimiter means no parameters */        
        if this-object:ParamDelimiter eq '':u then
            return '':u.
        
        if this-object:Value ne '':u then
            assign cDelim = this-object:ParamDelimiter.
        
        for each hdrParam where hdrParam.ParentHeader eq int64(this-object):
            case true:
                // if the parameter value is already quoted, leave it alone
                when String:IsQuoted(hdrParam.ParamValue, StringConstant:DOUBLE_QUOTE) then
                    assign cValue  = hdrParam.ParamValue.
                
                // if the parameter value has a quotable character, quote it
                when index(hdrParam.ParamValue, StringConstant:SPACE) gt 0 or
                when index(hdrParam.ParamValue, StringConstant:DOUBLE_QUOTE) gt 0 or
                when index(hdrParam.ParamValue, StringConstant:BACKSLASH) gt 0 or
                when index(hdrParam.ParamValue, StringConstant:SEMICOLON) gt 0 or
                when index(hdrParam.ParamValue, '(':u) gt 0 or
                when index(hdrParam.ParamValue, ')':u) gt 0 or
                when index(hdrParam.ParamValue, '<':u) gt 0 or
                when index(hdrParam.ParamValue, '>':u) gt 0 or
                when index(hdrParam.ParamValue, '@':u) gt 0 or
                when index(hdrParam.ParamValue, ',':u) gt 0 or
                when index(hdrParam.ParamValue, '=':u) gt 0 or
                when index(hdrParam.ParamValue, ':':u) gt 0 or
                when index(hdrParam.ParamValue, '/':u) gt 0 or
                when index(hdrParam.ParamValue, '[':u) gt 0 or
                when index(hdrParam.ParamValue, ']':u) gt 0 or
                when index(hdrParam.ParamValue, '?':u) gt 0 then
                    assign cValue = StringConstant:DOUBLE_QUOTE + hdrParam.ParamValue + StringConstant:DOUBLE_QUOTE.
                
                // all other cases, leave it be
                otherwise 
                    assign cValue  = hdrParam.ParamValue.
            end case.
            
            assign cParameters = substitute('&1&2 &3=&4':u, 
                                   cParameters,
                                   cDelim,
                                   hdrParam.ParamName,
                                   cValue )
                   cDelim = this-object:ParamDelimiter
                   .
        end.
        
        return cParameters.
    end method.
    
    /* Removes all parameters in this header with a name
       
       @param character the parameter name
       @return logical TRUE if at least one parameter was removed. */
    method public logical RemoveParameters(input pcParamName as character):
        define variable lExisting as logical no-undo.
        define buffer hdrParam for HeaderParameter.
         
        Assert:NotNullOrEmpty(pcParamName, 'Param name').
        
        assign lExisting = false.
        
        for each hdrParam where
                 hdrParam.ParentHeader eq int64(this-object) and
                 hdrParam.ParamName eq pcParamName:
            delete hdrParam. 
            assign lExisting = true.
        end.
        
        return lExisting.
    end method.
    
    /* Validates a header value. Should throw an error if the value
       is not valid.
       
       @param character The (prospective) header value */
    method protected void Validate(input pcValue as character):
        Assert:NotNull(pcValue, 'Header value').
    end method.
    
end class.