/*
 * Copyright (c) 2016 by Progress Software Corporation.
 * 14 Oak Park Bedford, MA 01730.  All rights reserved.
 *
 * No part of this program or document may be reproduced
 * in  any form or by any means without permission in
 * writing from Progress Software Corporation.
 */

using OpenEdge.Net.HTTP.Cookie from propath.
using OpenEdge.Net.HTTP.StatusCodeEnum from propath.
using OpenEdge.Web.IWebRequest from propath.
using OpenEdge.Web.WebHandler from propath.
using OpenEdge.Web.WebResponse from propath.
using OpenEdge.Web.WebResponseWriter from propath.
using Progress.Json.ObjectModel.JsonObject.

/*
 * Preview handler for Kendo UI Builder.
 * Allows serving project files from a temporary directory.
 */
class OpenEdge.Web.KendoUIBuilder.PreviewHandler 
    inherits WebHandler: 

    /* 
     * Handle GET request.  Returns files from preview directory.
     * The location of the preview directory is stored by a preceding
     * POST request in a cookie.
     */
    method override protected integer HandleGet( 
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable response            as WebResponse          no-undo.
        define variable writer              as WebResponseWriter    no-undo.
        define variable cFullPathName       as character            no-undo.
        define variable cContentType        as character            no-undo.


        cFullPathName = GetFilePathFromRequest( poRequest ).
         
        if cFullPathName <> ? then do:
            response = new WebResponse().
            response:StatusCode = 200.
            response:StatusReason = "OK".

            cContentType = GetContentType( cFullPathName ).
            if cContentType <> ? then do:
                response:ContentType = cContentType.
            end.

            writer = new WebResponseWriter( response ).
            WriteFile( response, writer, cFullPathName ).                
        end.
        else do:
            return integer( StatusCodeEnum:NotFound ).
        end.
                                
        writer:flush().
        writer:close().
        
        return 0.
    end method.

    /*
     * Handle POST request.  Sets cookie in browser for preview directory.
     * The cookie is used in subsequent get requests to find the files.
     */
    method override protected integer HandlePost( 
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable oMessageBody as JsonObject    no-undo.
        define variable response     as WebResponse.
        define variable writer       as WebResponseWriter.
        define variable previewdir   as character no-undo.
        define variable uibcookie    as Cookie no-undo.

        // Get the preview directory value from the post body
        oMessageBody = cast( poRequest:Entity, JsonObject ).
        previewdir = oMessageBody:GetCharacter( "dir" ).

        // Create the response
        response = new WebResponse().
        response:StatusCode = 200.
        response:StatusReason = "OK".

        // Set the preview directory as a cookie
        uibcookie = new Cookie( "KendoUIBuilder", "", "/", previewdir ).
        response:SetCookie( uibcookie ).

        writer = new WebResponseWriter( response ).
        writer:close().
              
        return 0.
    end method.

    /*
     * Extract from the request the full path to the requested file.
     */
    method private character GetFilePathFromRequest( 
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable cFileName           as character            no-undo.
        define variable cWorkingDirectory   as character            no-undo.


        cWorkingDirectory = GetWorkingDirectoryFromRequest( poRequest ).
        cFileName = poRequest:PathInfo.

        if cFileName begins "/preview" then do:
            cFileName = substring( cFileName, 9 ).
        end.

        file-info:file-name = cWorkingDirectory + "/" + cFileName.
        if index(file-info:file-type, "D") > 0 then do:
            cFileName = file-info:full-pathname + "/index.html".
            file-info:file-name = cFileName.
        end.             

        return file-info:full-pathname.

    end method.
 
    /*
     * Get the preview directory from the request.  This code assumes
     * that the first element of the path corresponds to a Windows
     * drive letter.  The code will need to be reworked if we decide
     * to support preview on Unix.
     */
    method private character GetWorkingDirectoryFromRequest(
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable poCookie            as Cookie               no-undo.
        define variable cPath               as character            no-undo.
        define variable cDriveString        as character            no-undo.
        define variable cDirectory          as character            no-undo.

        //poCookie = poRequest:GetCookie( "KendoUIBuilder" ).
        poCookie = GetCookie( poRequest, "KendoUIBuilder" ).
        if valid-object( poCookie ) then
        do:
            // Reconstruct Windows drive letter
            cPath = poCookie:Value.
            cDriveString = substring( cPath, 2, 1 ) + ":".
            cDirectory = substring( cPath, 3 ).

            // Add the drive letter back to the path
            file-info:file-name = cDriveString + cDirectory.
        end.
        else
            file-info:file-name = ".".

        return file-info:full-pathname.

    end method.


    method private Cookie GetCookie(
        input poRequest as OpenEdge.Web.IWebRequest,
        input cookiename as char):

        define variable oCookies     as Cookie extent no-undo.
        define variable iNumCookies as integer no-undo.
        define variable i           as integer no-undo.
    
        iNumCookies = poRequest:GetCookies(output oCookies).
        do i = 1 to iNumCookies:
            if oCookies[i]:Name eq cookiename then
                return oCookies[i]. 
        end.    

        return ?.

    end method.

    /* 
     * Get the content type from the file extension
     */         
    method private character GetContentType( cPathName as character ):
        define variable cContentType        as character            no-undo.
        define variable cExt                as character            no-undo.
        define variable idx                 as integer              no-undo.

        // Check file extension
        idx = r-index( cPathName, "." ).
        if idx <> -1 then do:
            cExt = substring( cPathName, idx ).
        end.

        case cExt:
            when ".html" then cContentType = "text/html".            
            when ".css" then cContentType = "text/css". 
            when ".jpg" then cContentType = "image/jpeg". 
            when ".jpeg" then cContentType = "image/jpeg".
            when ".js" then cContentType = "application/javascript".
            when ".woff" then cContentType = "application/x-font-woff".
            when ".eot" then cContentType = "application/vnd.ms-fontobject".
            when ".svg" then cContentType = "image/svg+xml".
            when ".ttf" then cContentType = "application/x-font-ttf".
            when ".png" then cContentType = "image/png".
            when ".json" then cContentType = "application/json".
            otherwise cContentType = ?.
        end.
        
        return cContentType.
    end.

    /* 
     * Write file to the response stream
     */         
    method private void WriteFile(
        response as WebResponse, 
        writer as WebResponseWriter, 
        cFullPathName as character):

        define variable mFile               as memptr               no-undo.
        define variable iFileLength         as integer              no-undo.        
        
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
