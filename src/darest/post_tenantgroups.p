/*************************************************************/
/* Copyright (c) 2010,2011 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_tenantgroups.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2010
    Notes       :     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.

define variable mMode       as char init "post" no-undo.
define variable mCollection as char init "tenantgroups" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("post_tenantgroups.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  
 
procedure executeRequest:
    define input  parameter pcParam as character no-undo.   
 
    /* ***************************  Definitions  ************************** */
    define variable groups       as ITenantGroupSet no-undo.    
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
   
    define variable cLong as longchar no-undo.
     
    /* ***************************  Main Block  *************************** */
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
       
    If restRequest:KeyValue[1] > "" then
    do: 
        undo, throw new NotFoundError("URL: " + restRequest:ConnectionUrl).    
    end.
    else do:
        groups = service:NewTenantGroups().
        groups:ImportTree(cFile).   
        service:CreateTenantGroups(groups).
        groups:ExportTree(cFileOut).
        copy-lob file cFileOut to clong.   
        substring(cLong,2,0) = '"success" : true, '.
        copy-lob clong to file cFileOut.
    end.
 
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