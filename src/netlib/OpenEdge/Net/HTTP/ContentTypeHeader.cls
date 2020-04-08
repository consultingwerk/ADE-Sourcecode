/* *************************************************************************************************************************
Copyright (c) 2016-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ContentTypeHeader
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Dec 10 13:40:24 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using Progress.Lang.AppError.

class OpenEdge.Net.HTTP.ContentTypeHeader inherits HttpHeader
            implements ISupportLogging:
    /* The Content-Type header should start with one of these types OR X-<something> */
    define private variable mcValidType as character no-undo
          initial 'application,audio,image,message,multipart,text,video':u.
    
    define public property Logger as ILogWriter no-undo 
        get():
            if not valid-object(Logger) then
                assign Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
            
            return this-object:Logger.
        end get.
        set.
        
    /* Constructor
    
       @param character A non-empty header name */
    constructor public ContentTypeHeader(input pcName as character):
        super (input pcName).
        
        assign this-object:ParamDelimiter = ';':u.
    end constructor.
    
    /* Constructor
    
       @param character A non-empty header name
       @param character A valid header value    */
    constructor public ContentTypeHeader (input pcName as character, input pcValue as character):
        super (input pcName, input pcValue).
    end constructor.
    
    /* Validates a header value. Should throw an error if the value
       is not valid.
       
       @param character The (prospective) header value */
    method override protected void Validate( input pcValue as character ):
        define variable iNumParts as integer no-undo.
        define variable cType as character no-undo.
        
        super:Validate(input pcValue).
        
        if pcValue eq '':u then
            return.
        
        // Spilt off the content without the params    
        assign pcValue   = entry(1, pcValue, ParamDelimiter)
               iNumParts = num-entries(pcValue, '/':u)
               .
        if iNumParts lt 2 then
            undo, throw new AppError(substitute('Header value must have at least 2 "/"-delimited parts: &1', pcValue), 0).
        
        assign cType = entry(1, pcValue, '/':u). 
        if lookup(cType, mcValidType) eq 0 then
            logger:Info(substitute('Content-Type header has a non-standard type of &1', cType)).
    end method.
    
    /** Saves a parameter value for a header.
        
        @param character (mandatory) The name of the parameter value to retrieve
        @param character (mandatory) The parameter value; blank/empty otherwise 
        @return logical  TRUE when the parameter was replaced/previously existed. */
    method override public logical SetParameterValue(input pcParamName as character,
                                                     input pcParamValue as character ):
        case pcParamName:
            when 'boundary':u then
                // we consume the boundary in an unquoted manner
                if not OpenEdge.Core.String:IsNullOrEmpty(pcParamValue) 
                   and OpenEdge.Core.String:IsQuoted(pcParamValue, StringConstant:DOUBLE_QUOTE)
                then
                    assign pcParamValue = substring(pcParamValue, 2, length(pcParamValue) - 2).
        end case.
        
        return super:SetParameterValue(pcParamName, pcParamValue).
    end method.
    
end class.