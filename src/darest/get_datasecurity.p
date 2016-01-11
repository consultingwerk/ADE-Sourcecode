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
using OpenEdge.DataAdmin.Rest.RestRequest.
using OpenEdge.DataAdmin.Error.NotFoundError.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.IDataSecurity from propath.
 
define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "datasecurity" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_datasecurity.log").  
   run executeRequest(session:parameter).
end.
finally:
    if session:batch-mode then output close.            
end finally.  

procedure executeRequest:
    define input  parameter pcParam as character no-undo.    
    /* ***************************  Definitions  ************************** */
     
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable datasec      as IDataSecurity no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
     
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