/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_datasecurity.p
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
  
{darest/restbase.i get datasecurity}
 
procedure Execute :
    define input  parameter restRequest as IRestRequest  no-undo.
    /* ***************************  Definitions  ************************** */
     
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable datasec      as IDataSecurity no-undo.
    /* ***************************  Main Block  *************************** */
     
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
    datasec = service:GetDataSecurity("PUB").
    if not valid-object(datasec) then 
       undo, throw new NotFoundError("DataSecurity not found").
    
    datasec:ExportTree(restRequest:OutFileName).
    
   
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