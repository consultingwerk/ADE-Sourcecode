/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Core.Assert.
using Progress.Lang.AppError.

class OpenEdge.Net.HTTP.ContentTypeHeader inherits HttpHeader:
    /* The Content-Type header must start with one of these types OR X-<something> */
    define private variable mcValidType as character no-undo
          initial 'application,audio,image,message,multipart,text,video':u.
    
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
        
        if lookup(cType, mcValidType) eq 0 and
           not cType begins 'X-':u then
            undo, throw new AppError(substitute('Invalid type: &1', cType), 0).           
    end method.
    
end class.