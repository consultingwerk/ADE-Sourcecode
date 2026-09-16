/*************************************************************/
/* Copyright (c) 2026 by progress Software Corporation       */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_roles.p
    Purpose     : 

    Syntax      :

    Description : API to create roles.

    Author(s)   : tmasood
    Created     : Thu Jan 22 14:02:00 IST 2026
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.
using OpenEdge.DataAdmin.IUser.
using OpenEdge.DataAdmin.IUserSet.

/* to be deprecated */
{darest/restbase.i post roles} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.
    /* ***************************  Definitions  ************************** */
    define variable oRole          as IRole no-undo.
    define variable oRoleset       as IRoleSet no-undo.
    define variable service        as DataAdminService no-undo.
    define variable errorHandler   as DataAdminErrorHandler no-undo.
    define variable cFile          as character no-undo.
    define variable cFileOut       as character no-undo.
    define variable cRoleName      as character no-undo.
    define variable cRequestParam  as character no-undo.
    define variable clong as longchar no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
     
    service:URL = restRequest:ConnectionUrl.
    assign
       cFile = restRequest:FileName
       cFileOut = restRequest:OutFileName
       cRoleName = restRequest:KeyValue[1]
       cRequestParam = restRequest:CollectionName[1].
    

    if cRoleName > "" then 
        undo, throw new UnsupportedOperationError("Post with key in URL:" + restRequest:RequestUrl).     
    else if cRequestParam = "roles" then 
    do:
        oRoleset = service:NewRoles().
        oRoleset:Import(cFile).
        service:CreateRoles(oRoleset) no-error.
        if error-status:error or error-status:num-messages > 0 then
            undo, throw new UnsupportedOperationError(error-status:get-message(1)).
        oRoleset:ExportLastSaved(cFileOut).
       
       
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
