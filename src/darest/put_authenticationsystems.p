/*************************************************************/
/* Copyright (c) 2011-2012 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_authenticationsystems.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : Tue Apr 05 11:50:05 IST 2011
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.IAuthenticationSystem.
using OpenEdge.DataAdmin.IAuthenticationSystemSet.
using OpenEdge.DataAdmin.Rest.IRestRequest.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.Error.NotFoundError.

/* to be deprecated */
{darest/restbase.i put authenticationsystems} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.      
    /* ***************************  Definitions  ************************** */
    define variable authenticationsystem       as IAuthenticationSystem no-undo.
    define variable authenticationSystemSet    as IAuthenticationSystemSet no-undo.
  
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable cLong        as longchar no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
     
    cFile = restRequest:FileName.
    cFileOut = restRequest:OutFileName.
    if restRequest:KeyValue[1] <> ? then 
    do:
        authenticationsystem = service:GetAuthenticationSystem(restRequest:KeyValue[1]).
        if not valid-object(authenticationsystem) then
            undo, throw new NotFoundError("AuthenticationSystem '"  + restRequest:KeyValue[1]  + "' not found").
      
        if restRequest:numLevels > 1 and restRequest:CollectionName[2] > "" then
        do:
            undo, throw new NotFoundError("URL: " + restRequest:RequestUrl).    
        end.    
        else 
        do:
            authenticationsystem:Import(cFile).
            service:UpdateAuthenticationSystem(authenticationsystem).   
            authenticationsystem:Export(cFileOut).
            copy-lob file cFileOut to clong.
            substring(cLong,2,0) = '"success" : true,'.
            copy-lob clong to file cFileOut.
        end. 
    end. /* key level 1 */
    else do:
        authenticationSystemSet = service:GetAuthenticationSystems().
        authenticationSystemSet:Import(cFile).
        service:UpdateAuthenticationSystems(authenticationSystemSet).   
        authenticationSystemSet:ExportLastSaved(cFileOut).
        copy-lob file cFileOut to clong.
        substring(cLong,2,0) = '"success" : true,'.
        copy-lob clong to file cFileOut.
    end.
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else do:
          
            errorHandler = new DataAdminErrorHandler().
        end.
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
end.