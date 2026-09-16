/*************************************************************/
/* Copyright (c) 2026 by progress Software Corporation       */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : delete_roles.p
    Purpose     : 

    Syntax      :

    Description : API to delete roles

    Author(s)   : tmasood
    Created     : Thu Jan 22 11:38:45 IST 2026
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IRole from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest  from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.

define stream acceptstream. 

/* to be deprecated */
{darest/restbase.i delete roles}
 
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo. 
 
    /* ***************************  Definitions  ************************** */
    define variable service      as DataAdminService      no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable oRole        as IRole                 no-undo.
    define variable cFile        as character             no-undo.
    define variable cFileOut     as character             no-undo.
    define variable cRoleName    as character             no-undo.   
    define variable cLong        as longchar              no-undo.
     
    /* ***************************  Main Block  *************************** */
   
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile     = restRequest:FileName
        cFileOut  = restRequest:OutFileName
        cRoleName = restRequest:KeyValue[1].
    
    If cRoleName > "" then
    do: 
        if restRequest:NumLevels = 1 then 
        do:
            // Validate the role
            oRole = service:GetRole(cRoleName).
            if not valid-object(oRole) then
                undo, throw new NotFoundError("Role '" + cRoleName + "' not found").
                            
            service:DeleteRole(cRoleName) no-error.
            if error-status:error or error-status:num-messages > 0 then
                undo, throw new UnsupportedOperationError(error-status:get-message(1)).
        end.        
        else
            undo, throw new NotFoundError("URL has wrong key values: " + restRequest:RequestUrl).
        
        output stream  acceptstream to value(cFileOut).
        put stream  acceptstream unformatted 
            "HTTP/1.1 200 OK" skip(1) 
            '~{"success" : true~}'.
        output stream  acceptstream  close.
        
    end.
    else 
        undo, throw new UnsupportedOperationError("DELETE with no key in URL:" + restRequest:RequestUrl).    
     
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler = new DataAdminErrorHandler(restRequest:ErrorFileName).
        else 
            errorHandler = new DataAdminErrorHandler().
      
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
end.