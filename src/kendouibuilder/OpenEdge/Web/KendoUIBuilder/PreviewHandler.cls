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
using OpenEdge.Web.WebHandler from propath.
using OpenEdge.Web.WebResponse from propath.
using OpenEdge.Web.WebResponseWriter from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using OpenEdge.Web.Dynamic.ContentHandler from propath.
using OpenEdge.Core.DateTimeAddIntervalEnum from propath.

/*
 * Preview handler for Kendo UI Builder.
 * Allows serving project files from a temporary directory.
 */
class OpenEdge.Web.KendoUIBuilder.PreviewHandler 
    inherits ContentHandler: 

    /*
     * Handle POST request.  Sets cookie in browser for preview directory.
     * The cookie is used in subsequent get requests to find the files.
     */
    method override protected integer HandlePost( 
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable oMessageBody as JsonObject        no-undo.
        define variable response     as WebResponse.
        define variable writer       as WebResponseWriter.
        define variable previewdir   as character         no-undo.
        define variable uibcookie    as Cookie            no-undo.

        // Create the response
        response = new WebResponse().
        response:StatusCode = 200.
        response:StatusReason = "OK".

        // Get the preview directory value from the post body
        oMessageBody = cast( poRequest:Entity, JsonObject ).
        if oMessageBody:Has('dir') then
        do:
            previewdir = oMessageBody:GetCharacter( 'dir' ).

            // Set the preview directory as a cookie
            uibcookie = new Cookie( "KUIB", "", "/", previewdir,
                1800, ?, false, true, ? ).
            response:SetCookie( uibcookie ).
        end.
    
        writer = new WebResponseWriter( response ).
        writer:close().
              
        return 0.
    end method.
    
    /*
     * Check for valid directory paths
     */
    method override protected logical IsValidPath(
        input poRequest as OpenEdge.Web.IWebRequest ):
        
        // For the preview handler, all paths are allowed
        return true.
        
    end method.

    /*
     * Get the preview directory from the request.  This code assumes
     * that the first element of the path in the cookie corresponds to
     * a Windows drive letter.  The code will need to be reworked if we
     * decide to support preview on Unix.
     */
    method override protected character GetContentDirectory(
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable poCookie     as Cookie    no-undo.
        define variable cPath        as character no-undo.
        define variable cDriveString as character no-undo.
        define variable cDirectory   as character no-undo.

        //poCookie = poRequest:GetCookie( "KUIB" ).
        poCookie = GetCookie( poRequest, "KUIB" ).
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
    
    /*
     * Get the path for the file to be served by the handler
     */
    method override protected character GetContentPath(
        input poRequest as OpenEdge.Web.IWebRequest ):

        define variable cFileName as character no-undo.

        cFileName = poRequest:PathInfo.

        if cFileName begins "/preview" then 
        do:
            cFileName = substring( cFileName, 9 ).
        end.

        return cFileName.
    end method.

    /* 
     * Get a cookie from a request by name.
     */
    method private Cookie GetCookie(
        input poRequest as OpenEdge.Web.IWebRequest,
        input cookiename as char):

        define variable oCookies    as Cookie  extent no-undo.
        define variable iNumCookies as integer no-undo.
        define variable i           as integer no-undo.
    
        iNumCookies = poRequest:GetCookies(output oCookies).
        do i = 1 to iNumCookies:
            if oCookies[i]:Name eq cookiename then
                return oCookies[i]. 
        end.    

        return ?.

    end method.
                
end class.
