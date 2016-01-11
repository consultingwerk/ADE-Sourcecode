/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : delete_tenantgroups.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2010
    Notes       :     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ITenantGroup from propath.
using OpenEdge.DataAdmin.ITenantGroupMember from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest  from propath.

define stream acceptstream. 

function CapitalizeFirst returns char(cword as char):
    return caps(substr(cWord,1,1)) + substr(cWord,2).
end function. 
 
/* to be deprecated */
{darest/restbase.i delete tenantgroups}
 
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.  
 
    /* ***************************  Definitions  ************************** */
/*    define variable groupinst    as IPartitionGroup no-undo.*/
    define variable service              as DataAdminService no-undo.
    define variable errorHandler         as DataAdminErrorHandler no-undo.
    define variable TenantGroup          as ITenantGroup no-undo.
    define variable TenantGroupMember    as ITenantGroupMember no-undo.
    define variable cFile                as character no-undo.
    define variable cFileOut             as character no-undo.
    define variable lSuccess             as logical no-undo.
    define variable cLong as longchar no-undo.
     
    /* ***************************  Main Block  *************************** */
    
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
    
    If restRequest:KeyValue[1] > "" then
    do: 
        if restRequest:NumLevels = 1 then
            service:DeleteTenantGroup(restRequest:KeyValue[1]).
        else if restRequest:NumLevels = 2 then
        do:
            if restRequest:CollectionName[2] = "tenantGroupMembers" then
            do: 
                tenantGroup =  service:GetTenantGroup(restRequest:KeyValue[1]).
                if not valid-object(tenantGroup) then
                    undo, throw new NotFoundError("Tenant Group '"  + restRequest:KeyValue[1]  + "' not found").
                tenantGroupMember = tenantGroup:TenantGroupMembers:Find(restRequest:KeyValue[2]).
                if not valid-object(tenantGroupMember) then
                    undo, throw new NotFoundError("Tenant Group Member for Group " + quoter(restRequest:KeyValue[1]) + " and Tenant '"  + quoter(restRequest:KeyValue[2])  + "' not found").
           
                lsuccess = tenantGroup:TenantGroupMembers:Remove(tenantGroupMember).
                
                if lsuccess then 
                    service:UpdateTenantGroup(tenantGroup).
                 else /* remove should not normally fail when we know the record is there and the reason is not known if it does */
            
                     undo, throw new NotFoundError("Delete of "  + quoter(restRequest:KeyValue[2]) + " from TenantGroup " + quoter(restRequest:KeyValue[1]) +  " " + CapitalizeFirst(restRequest:CollectionName[2]) + " failed" + ".").
                
                    
            end.
            else 
                undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).              
        end.    
        
        output stream  acceptstream to value(cFileOut).
        put stream  acceptstream unformatted 
                "HTTP/1.1 200 OK" skip(1) 
                '~{"success" : true~}'.
        output stream  acceptstream  close.    
    end.
    else 
        undo, throw new UnsupportedOperationError("DELETE with no key in URL:" + restRequest:RequestUrl).    
 
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler = new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
end.