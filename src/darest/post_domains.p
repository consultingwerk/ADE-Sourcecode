/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_domains.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : July 2010
    Notes       : Post handles create only simply by ensuring that no
                  data is read before the import. This way all records 
                  will be set as new and cause errors if they already exists   
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.

define variable mMode       as char init "post" no-undo.
define variable mCollection as char init "domains" no-undo.
define variable cLong       as longchar no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("post_domains.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally. 

procedure executeRequest:
    define input  parameter pcParam as character no-undo.   
 
    /* ***************************  Definitions  ************************** */
    define variable domain       as IDomain no-undo.
    define variable domains      as IDomainSet no-undo.
    define variable users        as IUserSet no-undo.
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
   
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
 
    if restRequest:NumLevels > 1 and restRequest:CollectionName[2] > "" then
    do:
        domain = service:GetDomain(restRequest:KeyValue[1]).
        if not valid-object(domain) then
            undo, throw new NotFoundError("Domain '"  + restRequest:KeyValue[1]  + "' not found").
      
        if restRequest:CollectionName[2] = "users" then
        do:
            users = service:NewUsers().
            users:Import(cFile).
            domain:Users:AddAll(users).
            service:CreateUsers(users). 
            users:ExportLastsaved(cFileOut).
            copy-lob file cFileOut to clong.   
            substring(cLong,2,0) = '"success" : true, '.
            copy-lob clong to file cFileOut.
        end.
        else 
           undo, throw new NotFoundError("URL: " + restRequest:ConnectionUrl).      
    end.     
    else if restRequest:KeyValue[1] <> ? then 
    do:
        undo, throw new NotFoundError("URL: " + restRequest:ConnectionUrl).      
    end.
    else do:
        domains = service:NewDomains().
        domains:Import(cFile).
        service:CreateDomains(domains).
        domains:ExportLastSaved(cFileOut).
        copy-lob file cFileOut to clong.   
        substring(cLong,2,0) = '"success" : true, '.
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
    
end procedure. 
