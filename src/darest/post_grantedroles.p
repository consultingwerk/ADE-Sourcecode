/*************************************************************/
/* Copyright (c) 2026 by progress Software Corporation       */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_grantedroles.p
    Purpose     : 

    Syntax      :

    Description : API to create granted roles.

    Author(s)   : tmasood
    Created     : Mon Feb 09 14:02:00 IST 2026
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.Error.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Rest.IRestRequest.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.Error.*.

/* to be deprecated */
{darest/restbase.i post grantedroles} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.
    /* ***************************  Definitions  ************************** */
    define variable oGrantRole     as IGrantedRoleSet no-undo.
    define variable oGrant         as IGrantedRole no-undo.
    define variable service        as DataAdminService no-undo.
    define variable errorHandler   as DataAdminErrorHandler no-undo.
    define variable cFile          as character no-undo.
    define variable cFileOut       as character no-undo.
    define variable cRequestParam  as character no-undo.
    define variable clong as longchar no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).     
    service:URL = restRequest:ConnectionUrl.
    
    assign
       cFile = restRequest:FileName
       cFileOut = restRequest:OutFileName
       cRequestParam = restRequest:CollectionName[1].
    
    if restRequest:KeyValue[1] > "" then 
        undo, throw new UnsupportedOperationError("Post with key in URL:" + restRequest:RequestUrl).     
    else if cRequestParam = "grantedroles" then do:
        
       oGrantRole = service:NewGrantedRoles().
       oGrantRole:Import(cFile).
       service:CreateGrantedRoles(oGrantRole) no-error.
       if error-status:error or error-status:num-messages > 0 then
            undo, throw new UnsupportedOperationError(error-status:get-message(1)).
       oGrantRole:ExportLastSaved(cFileOut).
       
       copy-lob file cFileOut to clong.
       substring(cLong,2,0) = '"success" : true,'.
       copy-lob clong to file cFileOut.
    end.
    else
        undo, throw new UnsupportedOperationError("Could not understand URL:" + restRequest:ConnectionUrl).

    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).
    end catch.
    finally:
        delete object service no-error.
    end finally.

   
end.
