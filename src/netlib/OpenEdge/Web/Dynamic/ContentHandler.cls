/*
 * Copyright (c) 2016 by Progress Software Corporation.
 * 14 Oak Park Bedford, MA 01730.  All rights reserved.
 *
 * No part of this program or document may be reproduced
 * in  any form or by any means without permission in
 * writing from Progress Software Corporation.
 */

using OpenEdge.Net.FileTypeRegistry from propath.
using OpenEdge.Net.HTTP.StatusCodeEnum from propath.
using OpenEdge.Web.WebHandler from propath.
using OpenEdge.Web.WebResponse from propath.
using OpenEdge.Web.WebResponseWriter from propath.

/*
 * Content handler for Kendo UI Builder.
 * Serves content relative to registered handler path
 */
class OpenEdge.Web.Dynamic.ContentHandler 
    inherits WebHandler:
        
    define private temp-table AllowedPath no-undo
        field Prefix as character.
        
    constructor public ContentHandler():
        AddValidPath( "/pub":u ).
        AddValidPath( "/priv":u ).
    end.

    /* 
     * Handle GET request.  Returns files from directory.
     */
    method override protected integer HandleGet( 
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable response      as WebResponse       no-undo.
        define variable writer        as WebResponseWriter no-undo.
        define variable cExt          as character         no-undo.
        define variable cFullPathName as character         no-undo.
        define variable cContentType  as character         no-undo.
        
        cFullPathName = GetFilePathFromRequest( poRequest ).
         
        if cFullPathName <> ? and IsValidPath( poRequest ) then 
        do:
            response = new WebResponse().
            response:StatusCode = 200.
            response:StatusReason = "OK":u.

            cExt = GetFileExtension( cFullPathName ).
            cContentType = FileTypeRegistry:Registry:Get( cExt ).
            if cContentType <> ? then 
            do:
                response:ContentType = cContentType.
            end.

            writer = new WebResponseWriter( response ).
            WriteFile( response, writer, cFullPathName ).                
        end.
        else 
        do:
            return integer( StatusCodeEnum:NotFound ).
        end.
                                
        writer:close().
        
        return 0.
    end method.
    
    /*
     * Add a path prefix to the list of allowed paths.
     * Paths are relative to WEB-INF and must start with /
     */
    method public void AddValidPath(
        input cPath as character ):
            
        if cPath <> ? then
        do:
            create AllowedPath.
            AllowedPath.Prefix = cPath.
        end.
    end.
    
    /*
     * Check a list of path prefixes to see if this request is
     * for a file in a valid directory.
     */
    method protected logical IsValidPath(
        input poRequest as OpenEdge.Web.IWebRequest ):
            
        define variable cPath    as character no-undo.
        define variable lAllowed as logical   no-undo initial false.
        
        cPath = poRequest:PathInfo.

        for each AllowedPath:
            if cPath begins AllowedPath.Prefix then
            do:
                lAllowed = true.
                leave.
            end.
        end.
        
        return lAllowed.
        
    end method.

    /*
     * Extract from the request the full path to the requested file.
     */
    method protected character GetFilePathFromRequest( 
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable cDirectory as character no-undo.
        define variable cFilePath  as character no-undo.

        cDirectory = GetContentDirectory( poRequest ).
        cFilePath = GetContentPath( poRequest ).

        file-info:file-name = cDirectory + cFilePath.
        if index(file-info:file-type, "D":u) > 0 then 
        do:
            cFilePath = file-info:full-pathname + "/index.html":u.
            file-info:file-name = cFilePath.
        end.             

        return file-info:full-pathname.
    end method.
    
    /*
     * Get the directory for the files served by the handler
     */
    method protected character GetContentDirectory(
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable cDirectory as character no-undo.

        cDirectory = poRequest:GetContextValue( "BASE_PATH":u ).

        return cDirectory + "/WEB-INF":u.
    end method.
    
    /*
     * Get the path for the file to be served by the handler
     */
    method protected character GetContentPath(
        input poRequest as OpenEdge.Web.IWebRequest ):

        return poRequest:PathInfo.
    end method.
    
    /* 
     * Get the file name extension
     */         
    method private character GetFileExtension( cPathName as character ):
        define variable cExt as character no-undo.
        define variable idx  as integer   no-undo.

        // Check file extension
        idx = r-index( cPathName, "." ).
        if idx <> -1 then 
        do:
            cExt = substring( cPathName, idx + 1 ).
        end.

        return cExt.
    end.

    /* 
     * Write file to the response stream
     */         
    method private void WriteFile(
        response as WebResponse, 
        writer as WebResponseWriter, 
        cFullPathName as character):

        define variable mFile       as memptr  no-undo.
        define variable iFileLength as integer no-undo.        
        
        copy-lob file cFullPathName to mFile.
        iFileLength = get-size (mFile).
        response:ContentLength = iFileLength.                
        writer:write(mFile, 1, iFileLength).                
    end.

    /* 
     * Handle methods that are marked as not allowed
     */
    method override protected integer HandleNotAllowedMethod( 
        input poRequest as OpenEdge.Web.IWebRequest ):
        return integer( StatusCodeEnum:MethodNotAllowed ).
    end method.

    /* 
     * Handle methods that are not implemented
     */
    method override protected integer HandleNotImplemented( 
        input poRequest as OpenEdge.Web.IWebRequest ):
        return integer( StatusCodeEnum:NotImplemented ).
    end method.
                
end class.
