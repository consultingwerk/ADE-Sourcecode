/*************************************************************/
/* Copyright (c) 2010-2013 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_schemas.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Jun 19 15:53:21 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.Error from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ISchema from propath.
using OpenEdge.DataAdmin.ISequence from propath.
using OpenEdge.DataAdmin.ISequenceSet from propath.
using OpenEdge.DataAdmin.ISequenceValueMap from propath.
using OpenEdge.DataAdmin.ISchema from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.RequestInfo from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IField from propath.
using OpenEdge.DataAdmin.IFieldSet from propath.
using OpenEdge.DataAdmin.ITableSet from propath.

/* keeping old - to be deprecated */
{darest/restbase.i get schemas}  

/*function AddNextCollectionToRequest returns logical (prestRequest as IRestRequest,pkeyreq as IRequestInfo):*/
/*     define variable valuereq     as IRequestInfo no-undo.                                                 */
/*     valuereq = prestRequest:GetPageRequest().                                                             */
/*     if not valid-object(valueReq) then                                                                    */
/*         valuereq = new RequestInfo(prestRequest:CollectionName[prestRequest:NumLevels]).                  */
/*     valueReq:QueryString = prestRequest:Query.                                                            */
/*     pkeyReq:Add(valueReq).                                                                                */
/*     return true.                                                                                          */
/*end function.                                                                                              */

function AddLastCollectionBatchingToRequest returns logical (prestRequest as IRestRequest,pkeyreq as IRequestInfo,pkeylevel as int):
     define variable valuereq  as IRequestInfo no-undo.        
     define variable childreq  as IRequestInfo no-undo.        
     define variable parentReq as IRequestInfo no-undo.
     define variable i as integer no-undo.
     parentReq = pKeyReq.
     if prestRequest:NumLevels - pkeyLevel < 1 then
         undo, throw new IllegalArgumentError("The number of levels in the request is not high enough to add collection to key level" + string(pkeylevel)). 
     do i = pkeylevel + 1 to prestRequest:NumLevels - 1:
         childReq = new RequestInfo(prestRequest:CollectionName[i]).
         parentReq:Add(childReq).
         parentReq = childReq. 
     end.    
     valuereq = prestRequest:GetPageRequest().
     if not valid-object(valueReq) then
         valuereq = new RequestInfo(prestRequest:CollectionName[prestRequest:NumLevels]).
     valueReq:QueryString = prestRequest:Query.
     parentReq:Add(valueReq).
     return true.
end function.



procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo. 
    /* ***************************  Definitions  ************************** */
     
    define variable service      as DataAdminService no-undo.
    define variable oschema      as ISchema no-undo.
    define variable sequence     as ISequence no-undo.
    define variable seqValues    as ISequenceValueMap no-undo.
    define variable otable       as ITable no-undo.
    define variable otables      as ITableSet no-undo.
    define variable oIndex       as IIndex no-undo.
    define variable keyreq       as IRequestInfo no-undo.
    define variable valuereq     as IRequestInfo no-undo.
    define variable sequenceSet  as ISequenceSet no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable lexport      as logical no-undo.
    define variable pageRequest  as IRequestInfo no-undo.
    define variable oFldSet      as IFieldSet no-undo.
    define variable oField       as IField no-undo.
    /* ***************************  Main Block  *************************** */
    
     
    restRequest:Validate().
    
    service = new DataAdminService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
    if restRequest:KeyValue[1] <> ? then 
    do:
        if restRequest:KeyValue[1] <> "PUB" then
            undo, throw new NotFoundError("Schema '"  + restRequest:KeyValue[1]  + "' not found").    
        if restRequest:NumLevels > 1 and restRequest:CollectionName[2] > "" then
        do:      
            case restRequest:CollectionName[2]:
                when "sequences" then
                do: 
                    if restRequest:KeyValue[2] <> ? then
                    do:
                        keyreq = new RequestInfo("Name",restRequest:KeyValue[2]).
                        if restRequest:NumLevels = 3 and restRequest:CollectionName[3] > "" then
                        do:
                            AddLastCollectionBatchingToRequest(restRequest,keyreq,2).
                        end.     
                        sequence = service:GetSequence(keyreq).           
                       
                        if sequence = ? then
                            undo, throw new NotFoundError("Sequence "  + restRequest:KeyValue[2]  + " not found").
                        
                        if restRequest:NumLevels > 2 and restRequest:CollectionName[3] > "" then
                        do:      
                            case restRequest:CollectionName[3]:
                                when "sequenceValues" then
                                do:
                                                                         
                                     sequence:SequenceValues:Export(restRequest:OutFileName).
                                end.
                                otherwise
                                    undo, throw new NotFoundError ("Invalid collection reference" + quoter(restRequest:CollectionName[2]) + " in URL " + quoter(restRequest:RequestUrl)).
                                
                            end case.
                        end.
                        else
                            sequence:Export(restRequest:OutFileName).                        
                    end. 
                    else do:   
                         
                        if restRequest:Query > "" then
                            sequenceSet = service:GetSequences(restRequest:Query).
                        else 
                            sequenceSet = service:GetSequences().
                   
                        sequenceSet:Export(restRequest:OutFileName).
                    end.
                end.
                when "tables" then
                do:
                    if restRequest:KeyValue[2] <> ? and restRequest:NumLevels > 2 then
                    do: 
                        keyreq = new RequestInfo("Name",restRequest:KeyValue[2]).
                        AddLastCollectionBatchingToRequest(restRequest,keyreq,2).
                        otable = service:GetTable(keyReq).
                        if otable = ? then
                            undo, throw new NotFoundError("Table "  + restRequest:KeyValue[2]  + " not found"). 
                        if restRequest:CollectionName[3] = "partitions" then
                        do:
                             oTable:Partitions:Export(restRequest:OutFileName).                            
                        end.
                        else if restRequest:CollectionName[3] = "indexes" then
                        do:
                            if restRequest:NumLevels >= 4 then 
                            do:
                                oIndex = oTable:Indexes:Find(restRequest:KeyValue[3]).
                                if oIndex = ? then
                                    undo, throw new NotFoundError("Index "  + restRequest:KeyValue[3]  + " not found").
                                case restRequest:CollectionName[4]:
                                    when "fields" then
                                        oIndex:Fields:export (restRequest:OutFileName).   
                                    when "indexfields" then
                                        oIndex:IndexFields:export (restRequest:OutFileName).   
                                    when "partitions" then
                                        oIndex:Partitions:export (restRequest:OutFileName).   
                                    otherwise 
                                        undo, throw new NotFoundError ("Invalid collection reference " + quoter(restRequest:CollectionName[4]) + " in URL " + quoter(restRequest:RequestUrl)).
                                end case.
                            end.
                            else do:
                                oTable:Indexes:ExportTree(restRequest:OutFileName).
                            end.
                        end.
                        else if lookup(restRequest:CollectionName[3],"fields,lobFields") > 0 then
                        do:
                            if restRequest:CollectionName[3] = "lobFields" then 
                                oFldSet =  oTable:LobFields.
                            else 
                                oFldSet =  oTable:Fields.
                                
                            if restRequest:NumLevels = 3 then
                            do:
                                oFldSet:Export(restRequest:OutFileName).
                            end.
                            else do:
                                oField = oFldSet:Find(restRequest:KeyValue[3]).
                                if oField = ? then
                                    undo, throw new NotFoundError("Field "  + restRequest:KeyValue[3]  + " not found in Table " + restRequest:KeyValue[2]).
                                
                                if restRequest:CollectionName[4] = "partitions" then 
                                do:
                                    oField:Partitions:Export(restRequest:OutFileName).
                                end.
                                else    
                                    undo, throw new NotFoundError ("Invalid collection reference " + quoter(restRequest:CollectionName[3]) + " in URL " + quoter(restRequest:RequestUrl)).
               
                            end.      
                        end.
                        else 
                            undo, throw new NotFoundError ("Invalid collection reference " + quoter(restRequest:CollectionName[3]) + " in URL " + quoter(restRequest:RequestUrl)).
                  
                    end.    
                    else if restRequest:NumLevels = 2 then
                    do:
                        if restRequest:KeyValue[2] <> ? then 
                        do:    
                            otable = service:GetTable(restRequest:KeyValue[2]).                        
                            otable:ExportTree(restRequest:OutFileName).
                        end.
                        else do:
                            pageRequest = restRequest:GetPageRequest().
                            if valid-object(pageRequest) then 
                                otables = service:GetTables(pageRequest).
                            else if restRequest:Query > "" then 
                                otables = service:GetTables(restRequest:Query).
                            else 
                                otables = service:GetTables().
                            otables:Export(restRequest:OutFileName).        
                        end. 
                    end.
                end.
                otherwise
                   undo, throw new NotFoundError ("Invalid collection reference " + quoter(restRequest:CollectionName[2]) + " in URL " + quoter(restRequest:RequestUrl)).
            end.
        end.
        else do: 
            oschema = service:GetSchema().
            oschema:ExportTree(restRequest:OutFileName).
        end. 
    end.    
    else do:
        /* schemas no key  - still only one schema*/ 
        oschema = service:GetSchema().
        oschema:ExportTree(restRequest:OutFileName).
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