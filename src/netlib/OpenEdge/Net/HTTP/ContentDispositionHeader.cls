/************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ContentDispositionHeader
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-01
    Notes       : * Header per spec http://tools.ietf.org/html/rfc6266 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.HttpHeader.

class OpenEdge.Net.HTTP.ContentDispositionHeader inherits HttpHeader:
    /* Constructor
    
       @param character A non-empty header name */
    constructor public ContentDispositionHeader(input pcName as character):
        super (pcName).
        assign this-object:ParamDelimiter = ';':u.
    end constructor.
    
    /* Constructor
    
       @param character A non-empty header name
       @param character A valid header value    */
    constructor public ContentDispositionHeader (input pcName as character, input pcValue as character):
        super(pcName, pcValue).
        assign this-object:ParamDelimiter = ';':u.
    end constructor.
    
    method override public logical SetParameterValue( input pcParamName as character, input pcParamValue as character ):
        case pcParamName:
            when 'filename':u or
            when 'name':u then
               if not OpenEdge.Core.String:IsQuoted(pcParamValue) then
                   assign pcParamValue = StringConstant:DOUBLE_QUOTE + pcParamValue + StringConstant:DOUBLE_QUOTE.
        end case.
        
        return super:SetParameterValue(input pcParamName, input pcParamValue).
    end method.
    
end class.