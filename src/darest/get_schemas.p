/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
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
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.

/* keeping old - to be deprecated */
{darest/restbase.i get schemas}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo. 
    /* ***************************  Definitions  ************************** */
     
    define variable service      as DataAdminService no-undo.
    define variable oschema      as ISchema no-undo.
    define variable sequence     as ISequence no-undo.
    define variable seqValues    as ISequenceValueMap no-undo.
    define variable otable       as ITable no-undo.
    define variable keyreq       as IRequestInfo no-undo.
    define variable valuereq     as IRequestInfo no-undo.
    define variable sequenceSet  as ISequenceSet no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable lexport      as logical no-undo.
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
                            valuereq = restRequest:GetPageRequest().
                            if not valid-object(valueReq) then
                               valuereq = new RequestInfo(restRequest:CollectionName[3]).
                            valueReq:QueryString = restRequest:Query.
                            keyReq:Add(valueReq).
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
                    if restRequest:KeyValue[2] <> ?
                    and restRequest:NumLevels > 2 
                    and restRequest:CollectionName[3] = "partitions" then
                    do:
                        keyreq = new RequestInfo("Name",restRequest:KeyValue[2]).
                        if restRequest:NumLevels = 3 then
                        do:
                            valuereq = restRequest:GetPageRequest().
                            if not valid-object(valueReq) then
                                valuereq = new RequestInfo(restRequest:CollectionName[3]).
                            valueReq:QueryString = restRequest:Query.
                            keyReq:Add(valueReq).
                        end.     
                        otable = service:GetTable(keyReq).
                        if otable = ? then
                            undo, throw new NotFoundError("Table "  + restRequest:KeyValue[2]  + " not found").
                        oTable:Partitions:Export(restRequest:OutFileName).
                        
                    end.    
                    else if restRequest:NumLevels = 2 then
                    do:
                        otable = service:GetTable(restRequest:KeyValue[2]).
                        otable:ExportTree(restRequest:OutFileName).
                    end.
                    else
                        undo, throw new NotFoundError ("Invalid collection reference " + quoter(restRequest:CollectionName[2]) + " in URL " + quoter(restRequest:RequestUrl)).
                    
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