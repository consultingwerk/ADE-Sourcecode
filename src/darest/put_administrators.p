/*************************************************************/
/* Copyright (c) 2011-2012 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_administrators.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

 
using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.JSONObject from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IAdministrator from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
 
/* to be deprecated */
{darest/restbase.i put administrators} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.     
    /* ***************************  Definitions  ************************** */
   
    define variable admin     as IAdministrator no-undo. 
 
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable cLong        as longchar   no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest:Validate().
    cFile  = restRequest:fileName.
    cFileOut  = restRequest:OutFileName.
    service = new DataAdminService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
    
    admin = service:GetAdministrator().
    
    admin:Import(cFile).
    service:UpdateAdministrator(admin).
    admin:Export(cFileOut).
    copy-lob file cFileOut to clong.     
    substring(cLong,2,0) = '"success" : true, '.
    copy-lob clong to file cFileOut.
    
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

 