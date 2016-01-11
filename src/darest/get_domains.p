/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_domains.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Util.*.
using OpenEdge.DataAdmin.Error.*.

{darest/restbase.i get domains}
 
procedure Execute :
    define input  parameter restRequest as IRestRequest  no-undo.     
    /* ***************************  Definitions  ************************** */
    define variable domain       as IDomain no-undo.
    define variable domains      as IDomainSet no-undo.
    define variable userSet      as IUserSet no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable domainreq    as IRequestInfo no-undo.
    define variable childreq     as IRequestInfo no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    
    /* ***************************  Main Block  *************************** */
    
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
   
    service:URL = restRequest:ConnectionUrl.
    /* domains can have blank key */
    if restRequest:KeyValue[1] <> ? then 
    do:
        domainreq = new RequestInfo("Name",restRequest:KeyValue[1]).
        if restRequest:NumLevels > 1 and restRequest:CollectionName[2] > "" and restRequest:Query > "" then
        do:
            childReq = new RequestInfo(restRequest:CollectionName[2]).
            childReq:QueryString = restRequest:Query.
            domainreq:Add(childreq). 
        end.
        
        domain = service:GetDomain(domainreq).
        
        if not valid-object(domain) then
            undo, throw new NotFoundError("Domain '"  + restRequest:KeyValue[1]  + "' not found").
        
        if restRequest:NumLevels > 1 then
        do:
            if restRequest:KeyValue[2] > "" then
                undo, throw new NotFoundError("URL "  + restRequest:RequestUrl + "' not found").
            
            if restRequest:CollectionName[2] > "" then
            do:
                case restRequest:CollectionName[2]:
                    when "users" then
                    do:
                        userSet = domain:Users.
                        userSet:Export(restRequest:OutFileName).
                  
                    end.
                    otherwise
                        undo, throw new NotFoundError("URL "  + restRequest:RequestUrl + "' not found").
                end case. 
            end.
       
        end.
        else 
           domain:Export(restRequest:OutFileName).
    
    
    end.    
    else do:        
        pageRequest = restRequest:GetPageRequest().
        if valid-object(pageRequest) then 
            domains = service:GetDomains(pageRequest).
        else
        if restRequest:Query > "" then 
            domains = service:GetDomains(restRequest:Query).
        else 
            domains = service:GetDomains().
        domains:Export(restRequest:OutFileName).    
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