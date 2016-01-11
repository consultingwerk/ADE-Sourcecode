/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
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
using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
 
define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "administrators" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_administrators.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  
 
procedure executeRequest:
  
    define input  parameter pcParam as character no-undo.      
    /* ***************************  Definitions  ************************** */
   
    define variable admin     as IAdministrator no-undo. 
 
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable cLong        as longchar   no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    
    restRequest:Validate().
    cFile  = restRequest:fileName.
    cFileOut  = restRequest:OutFileName.
    service = new DataAdminService().
    service:URL = restRequest:ConnectionUrl.
    
    admin = service:GetAdministrator().
    
    admin:Import(cFile).
    service:UpdateAdministrator(admin).
    admin:Export(cFile).
    copy-lob file cFile to clong.     
    substring(cLong,2,0) = '"success" : true, '.
    copy-lob clong to file cFile.
    
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

 