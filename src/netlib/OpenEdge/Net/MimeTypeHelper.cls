/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MimeTypeHelper
    Purpose     : Helper class for working with (some) MIME types, especially JSON and XML, and where there
                  are charset and other parameters that muddy the waters when doing comparisons
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-25 
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.MimeTypeHelper.

class OpenEdge.Net.MimeTypeHelper: 
	constructor private MimeTypeHelper (  ):
		super ().
	end constructor.
	
    /* Strips the vendor prefix and any parmeters from the input type, and 
       returns the type and subtype in an array
       
       @param character a MIME type
       @return character[2] An array of the type [1] and subtype [2]    */
    method static public character extent 2 SplitType (input pcMimeType as character):
        define variable cType as character extent 2 no-undo.
        define variable iPos as integer no-undo.
        
        Assert:NotNullOrEmpty(pcMimeType, 'MIME type').
        
        // remove all parameters
        assign pcMimeType = trim(entry(1, pcMimeType, ';':u))
               
               cType[1] = entry(1, pcMimeType, '/':u)
               cType[2] = entry(2, pcMimeType, '/':u)
               .
        // strip out any prefixes
        assign iPos = r-index(cType[2], '+':U).
        if iPos gt 0 then
            assign cType[2] = substring(cType[2], iPos + 1).
        
        return cType.
    end method.
    
    /* Indicates whether a given MIME type is a form encoded type
    
       @param character The mime type
       @return logical TRUE iff the input type is valid and form-encoded */
    method static public logical IsFormEncoded(input pcMimeType as character):
        define variable cType as character extent 2 no-undo.
        define variable lIsFormEncoded as logical no-undo.

        if pcMimeType eq  '':u or
           pcMimeType eq ? then
            return false.
        
        if num-entries(pcMimeType, '/':u) ne 2 then
            return false. 
        
        assign cType   = MimeTypeHelper:SplitType(pcMimeType)
               lIsFormEncoded = (cType[1] eq 'application':u and cType[2] eq 'x-www-form-urlencoded':u)
                             or (cType[1] eq 'multipart':u and cType[2] eq 'form-data':u).
        
        return lIsFormEncoded.
    end method.
    

    /* Indicates whether a given MIME type is a multipart type  
    
       @param character The mime type
       @return logical TRUE iff the input type is valid and multipart */
    method static public logical IsMultipart(input pcMimeType as character):
        define variable cType as character extent 2 no-undo.
        define variable lIsMultipart as logical no-undo.

        if pcMimeType eq  '':u or
           pcMimeType eq ? then
            return false.
        
        if num-entries(pcMimeType, '/':u) ne 2 then
            return false. 
        
        assign cType   = MimeTypeHelper:SplitType(pcMimeType)
               lIsMultipart = (cType[1] eq 'multipart':u).
        
        return lIsMultipart.
    end method.
    
    /* Indicates whether a given MIME type is JSON 
    
       @param character The mime type
       @return logical TRUE iff the input type is valid and JSON */
    method static public logical IsJson(input pcMimeType as character):
        define variable cType as character extent 2 no-undo.
        define variable lIsJson as logical no-undo.

        if pcMimeType eq  '':u or
           pcMimeType eq ? then
            return false.
        
        if num-entries(pcMimeType, '/':u) ne 2 then
            return false. 
        
        assign cType   = MimeTypeHelper:SplitType(pcMimeType)
               lIsJson = (cType[1] eq 'application':u and cType[2] eq 'json':u).
        
        return lIsJson.
    end method.
    
    /* Indicates whether a given MIME type is XML 
    
       @param character The mime type
       @return logical TRUE iff the input type is valid and XML */
    method static public logical IsXML(input pcMimeType as character):
        define variable cType as character extent 2 no-undo.
        define variable lIsXml as logical no-undo.
        
        if pcMimeType eq  '':u or
           pcMimeType eq ? then
            return false.
        
        if num-entries(pcMimeType, '/':u) ne 2 then
            return false. 
        
        assign cType = MimeTypeHelper:SplitType(pcMimeType)
               lIsXml = false.
               
        case ctype[1]:
            when 'text':u then
                assign lIsXml = (cType[2] eq 'xml-external-parsed-entity':u).
            when 'application':u then
                assign lIsXml = (cType[2] eq 'xml':u 
                              or cType[2] eq 'xml-external-parsed-entity':u
                              or cType[2] eq 'xml-dtd':u ).
        end case.   // type               
        
        return lIsXml.
    end method.

end class.