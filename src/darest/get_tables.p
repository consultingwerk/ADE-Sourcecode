/*************************************************************/
/* Copyright (c) 2011-2016 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.Rest.RestService from propath.
using OpenEdge.DataAdmin.ITableSet from propath.
using OpenEdge.DataAdmin.ITable    from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
 
 /* old behavior - to be deprecated */
{darest/restbase.i get tables}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.     
    /* ***************************  Definitions  ************************** */
   
    define variable tables       as ITableSet no-undo.
    define variable tableimpl    as ITable    no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable service      as RestService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cAllTables as character no-undo.
    define variable lAllTables as logical no-undo.
    define variable SchemaName as character no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest:Validate().
    
    cAllTables = restRequest:GetQueryValue("AllTables").
    SchemaName = restRequest:GetQueryValue("SchemaName").
    if cAllTables > "" then
        lAllTables = logical(cAllTables).
    service = new RestService(restRequest:ConnectionName).
   
    service:URL = restRequest:ConnectionUrl.
    
    if restRequest:KeyValue[1] > "" then 
    do:
        if lAllTables then do:
            if SchemaName > "" then            
                tableimpl = service:GetTable(restRequest:KeyValue[1],SchemaName).            
            else undo, throw new UnsupportedOperationError("URL with key for tables with all option.").
        end.
        if not valid-object(tableimpl) then 
            tableimpl = service:GetTable(restRequest:KeyValue[1]).
        if not valid-object(tableimpl) then
            undo, throw new NotFoundError("Table '"  + restRequest:KeyValue[1]  + "' not found").
         
        tableimpl:ExportTree(restRequest:OutFileName).
    end.    
    else do:
        pageRequest = restRequest:GetPageRequest().
        if lAllTables =  false then  
        do:
            if valid-object(pageRequest) then 
                tables = service:GetTables(pageRequest).
            else
            if restRequest:Query > "" then 
                tables = service:GetTables(restRequest:Query).
            else 
                tables = service:GetTables().
        end.
        else
        do:
            if valid-object(pageRequest) then 
                tables = service:GetAllTables(pageRequest).
            else
            if restRequest:Query > "" then 
                tables = service:GetAllTables(restRequest:Query).
            else 
                tables = service:GetAllTables().
        end.
        tables:Export(restRequest:OutFileName).    
            
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