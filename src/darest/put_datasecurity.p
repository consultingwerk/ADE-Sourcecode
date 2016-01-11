/*************************************************************/
/* Copyright (c) 2011-2012 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_datasecurity.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2011
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.Error.
using Progress.Lang.AppError.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Rest.IRestRequest.
using OpenEdge.DataAdmin.Error.NotFoundError.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.IDataSecurity from propath.
 
/* to be deprecated */
{darest/restbase.i put datasecurity} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo. 
    /* ***************************  Definitions  ************************** */
     
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable datasec      as IDataSecurity no-undo.
    define variable cFileIn      as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable cLong        as longchar  no-undo.
    define variable ans as logical no-undo.
    /* ***************************  Main Block  *************************** */
     
    restRequest:Validate().
    cFileIn = restRequest:FileName.
    cFileOut = restRequest:OutFileName.
    service = new DataAdminService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
    
    
    datasec = service:GetDataSecurity("PUB").
    if not valid-object(datasec) then 
       undo, throw new NotFoundError("DataSecurity not found").

    
    datasec:ImportTree(cFileIn).
    service:UpdateDataSecurity(datasec).   
    datasec:ExportLastSavedTree(cFileOut).
    copy-lob file cFileOut to clong.     
    substring(cLong,2,0) = '"success" : true, '.
    copy-lob clong to file cFileOut.
    
    
    catch e as Progress.Lang.Error :
       
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else do:
/*              message      */
/*                           */
/*         e:GetMessage(1) skip  */
/*          e:CallStack      */
/*         view-as alert-box.*/
/*         return.           */
            errorHandler = new DataAdminErrorHandler().
        end.
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
end.