/*************************************************************/
/* Copyright (c) 2016 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_cdctablepolicies.p
    Purpose     : 
    Syntax      :
    Description :
    Author(s)   : mkondra
    Created     : Fri Feb 05 15:20:28 IST 2016
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.*  from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ICdcTablePolicy from propath.
using OpenEdge.DataAdmin.ICdcFieldPolicy from propath.
using OpenEdge.DataAdmin.ICdcTablePolicySet from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.RequestInfo from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Rest.PageRequest from propath.


procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.   
    /* ***************************  Definitions  ************************** */
    define variable TablePolicy      as ICdcTablePolicy no-undo.
    define variable FieldPolicy      as ICdcFieldPolicy no-undo.
  
    define variable TablePolicies as ICdcTablePolicySet no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable policyreq    as IRequestInfo no-undo.
    define variable valuereq     as IRequestInfo no-undo.
 
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    
    /* ***************************  Main Block  *************************** */
    service = new DataAdminService(restRequest:ConnectionName). 
    service:URL = restRequest:ConnectionUrl.
    if restRequest:KeyValue[1] > "" then
    do:
        
        policyreq = new RequestInfo("Name",restRequest:KeyValue[1]).
        if restRequest:NumLevels = 2 and restRequest:CollectionName[2] > "" and restRequest:KeyValue[2] = ? then
        do:
            pageRequest = restRequest:GetPageRequest().
            if valid-object(pageRequest) then
               policyreq:Add(pageRequest).
            else if restRequest:Query > "" then
            do:
                valuereq = new RequestInfo(restRequest:CollectionName[2]).
                valueReq:QueryString = restRequest:Query.
                policyreq:Add(valueReq).
            end.
        end.    
        TablePolicy = service:GetCdcTablePolicy(policyreq). 
        //message TablePolicy:CdcPolicyId skip int(TablePolicy:State) skip TablePolicy:IdentifyingField view-as alert-box.
        if TablePolicy = ? then
             undo, throw new NotFoundError("Cdc Table Policy "  + quoter(restRequest:KeyValue[1])  + " not found").
        if restRequest:NumLevels > 1 then
        do:
            if restRequest:NumLevels = 2 then
            do: 
                if restRequest:CollectionName[2] = "CdcFieldPolicies" then
                do:
                    if restRequest:KeyValue[2] > "" then
                    do:
                        FieldPolicy = TablePolicy:FieldPolicies:Find(restRequest:KeyValue[2]).
                        if not valid-object(FieldPolicy) then
                            undo, throw new NotFoundError("Cdc Field Policy "  + quoter(restRequest:KeyValue[2])  + " not found for Cdc Table Policy" + quoter(restRequest:KeyValue[1])).
                      
                        FieldPolicy:ExportTree(restRequest:OutFileName).
                    end.
                    else
                        TablePolicy:FieldPolicies:ExportTree(restRequest:OutFileName).
                end. 
                else    
                    undo, throw new NotFoundError ("Unknown URL: " + restRequest:RequestURL).
            end.
            else
                undo, throw new NotFoundError ("Unknown URL: " + restRequest:RequestURL).
        end.
        else /* policy details needs batching and are retrieved separately */
            TablePolicy:ExportTree(restRequest:OutFileName).
    end.
    else do:
        pageRequest = restRequest:GetPageRequest().
        define variable i1 as integer no-undo.
        define variable i2 as integer no-undo.
        define variable strt as integer no-undo.
        define variable pSize as integer no-undo.
        define variable lTableList as logical no-undo.
        define variable cTableList as char no-undo.
        i1 = etime(true).
        assign 
            strt                 = pageRequest:Start
            pSize                = PageRequest:PageSize       
            pageRequest:Start    = 0
            PageRequest:PageSize = 0
            .
         ctableList = restRequest:GetQueryValue("TableList").
         
         if cTableList > "" then
            PageRequest:TableList = logical(cTableList).
        
        if valid-object(pageRequest) then 
            TablePolicies = service:GetCdcTablePolicies(pageRequest).
        else if restRequest:Query > "" then
            TablePolicies = service:GetCdcTablePolicies(restRequest:Query).
        else
            TablePolicies = service:GetCdcTablePolicies().
        
        assign    
             pageRequest:Start =strt
             PageRequest:PageSize = pSize
             .
             
        TablePolicies:ExportTree(restRequest:OutFileName,pageRequest). 
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
    
 end procedure.