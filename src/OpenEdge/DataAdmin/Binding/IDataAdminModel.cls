/*************************************************************/
/* Copyright (c) 2011,2013 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : Defines the Model 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Sep 27 06:04:52 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IDataTree from propath.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.IRowChange.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Lang.IQueryMap.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.
interface OpenEdge.DataAdmin.Binding.IDataAdminModel inherits IDataAdminContext:  
     
     define public event SearchQuery signature void (id as char,input-output queryContext as IDataAdminContext). 
     define public event SearchRequest signature void (Req as IRequestInfo,pcParent as char,pcKeys as char extent,input-output queryContext as IDataAdminContext). 
     define public event BeforeDelete  signature void (rid as rowid). 
     define public event KeyChanged signature void (keyChange as IRowChange). 
     define public event AddedToContext signature void (newContext as IDataAdminModel). 
   
     define public property CanEditKey   as logical      no-undo  get. 
     define public property ContextScope as IContextScope no-undo get.
     
     /** add foreign key for parent (called from filteredContext:copy with ParentRow) 
       NOTE: the copy wil copy all records from the passed context assuming all records 
             belongs to the passed parent value (only local context should be passed) */
     method public void CopyForParent(pRow as IRow,cntxt as IDataAdminContext):
         
     /** add foreign key for parent (called from filteredContext:createRow with ParentRow) */ 
     method public void CreateRowForParent(pRow as IRow,entity as IDataAdminElement):
             
     method public void MoveQueries(cntxt as IDataAdminModel).
   
      /*  table import of the entity from query/filtered context 
        (flat - no tree ?? will probably work with tree if no root ) 
         replace mode  */
     method public void ImportForParent(pParentRow as IRow,pcfile as char).
         
     /* json import table (not deep/tree) for parent row */
     method public void ImportNewForParent(pParentRow as IRow,pcfile as char).
   
     /*  table import of the entity from query/filtered context 
        (flat - no tree ?? will probably work with tree if no root ) 
         replace mode  */
     method public void ImportForParent(pParentRow as IRow,pJson as JsonObject).
         
     /* json import table (not deep/tree) for parent row */
     method public void ImportNewForParent(pParentRow as IRow,pJson as JsonObject).
     
/*     /** returns the query with the values inserted according to GetJoinFields          */
/*         - must match order of GetQueryHandles                                          */
/*        @param serializename of parent                                                  */
/*        @param keyvalue can hold values for any datatype */                             */
/*     method public character GetChildQuery(parentid as char,pcKeyValue as char).        */
/*     /** returns the query with the values inserted according to GetJoinFields          */
/*        @param serializename of parent                                                  */
/*        @param keyvalues can hold values for any datatype */                            */
/*     method public character GetChildQuery(parentid as char,pcKeyValues as char extent).*/
   
     /** returns the query with the values inserted according to GetJoinFields 
           @param row of parent   */
     method public character GetChildQuery(pRow as IRow).
     
/*     /** returns the server query with the values inserted according to GetJoinFields         */
/*         defaults to return the GetChildQuery                                                 */
/*        override if different query is needed on                                              */
/*         @param serializename of parent                                                       */
/*         @param keyvalue can hold values for any datatype */                                  */
/*     method public character GetServerChildQuery(parentid as char,pcKeyValue as char).        */
/*                                                                                              */
/*     /** returns the server query with the values inserted according to GetJoinFields         */
/*         defaults to return the GetChildQuery                                                 */
/*        override if different query is needed on server                                       */
/*         @param serializename of parent                                                       */
/*         @param keyvalues can hold values for any datatype */                                 */
/*     method public character GetServerChildQuery(parentid as char,pcKeyValues as char extent).*/
     
      /** returns the server query with the values inserted according to GetJoinFields 
         defaults to return the GetChildQuery 
        override if different query is needed on server 
         @param row of parent   */
     method public character GetServerChildQuery(pRow as IRow).
 
    /** returns a query expression with the joins inserted according to GetJoinFields 
            @param parentname context name of parent being joined to (each/first parent of this)  */  
     method public character GetJoinQuery(parentname as char).
    
    /** returns a query expression with the joins inserted according to GetJoinFields 
            @param parentname context name of parent being joined to (each/first parent of this)  */  
     method public character GetServerJoinQuery(parentname as char).
    
     
     /** return true if the context supports a named query for a subset of the context 
         The parent/caller can check this and passes a RequestInfo with corresponding name  
         (see example  in FieldContext support for "lobFields") */  
     method public character GetNamedQuery(pqname as character).
         
       /** Override to return correct cased name for a named query   */
     method public character GetNamedQueryName(pqname as character).
 
     /*
     /** returns the server query with the join inserted according to GetJoinFields 
         defaults to return the GetJoinQuery 
        override if different query is needed on server 
         @param serializename of parent    */    
     method public character GetServerJoinQuery(parentid as char).
     */
     /**  Get default buffer handles 
          to use in child query for parent  
        - must match order of GetChildQuery
        @param serializename of parent   
       */
     method public handle extent GetQueryHandles(parentid as char).  
     
     method public char TransformQuery(pcTables as char, pWhere as char,mapcontxt as IQueryMap).    
     
     method public ISaveRequest GetSaveRequest(pid as char).    
     method public ISaveRequest GetSaveRowRequest(pcKey as char,pReq as IRequestInfo):
     method public ISaveRequest GetSaveRowRequest(pRow as IRow,pReq as IRequestInfo):
   
     method public ISaveRequest GetDeleteRowRequest(pRow as IRow,pReq as IRequestInfo):
     method public ISaveRequest GetCreateRowRequest():    
     method public ISaveRequest GetCreateRowRequest(pRow as IRow).
         
     method public character GetWhere(pcKeyFields as char, pcValues as char extent):
   
     /* utility method   */
     method public character GetFieldsFromJoin(pcJoinfields as char,plChild as log):
    
     /** GetChild model  
       @param serializeName */
     method public IDataAdminModel GetChild(name as char). 
     
     method public void PrepareLastSavedTree(tree as IDataTree,phBuffer as handle):  
           
     method public IDataAdminCollection NewCollection().
     
     method public IDataAdminCollection GetCollection().    
     method public IDataAdminCollection GetCollection(filter as char).    
     method public IDataAdminCollection GetCollection(preq as IRequestInfo).
     method public IDataAdminCollection GetCollection(pParentRow as IRow,pReq as IRequestInfo).  
       
     method public IDataAdminCollection GetChildCollection(pParent as IRow,preq as IRequestInfo).    
     method public IDataAdminCollection GetChildCollection(pParent as IRow,serializename as char).    
     
     method public void FillData(pmsg as IFetchRequest).  
    
     method public IDataAdminElement FindEntity(h as handle,pReq as IRequestInfo).
       
     /** find in current data (no service request) */
     method public IDataAdminElement FindEntity(i as int,pReq as IRequestInfo).
     
     
     /** find in current data (no service request) */
     method public IDataAdminElement FindEntity(c as char,pReq as IRequestInfo).
     
     /** find in current data (no service request) */
     method public IDataAdminElement FindEntity(c as char extent,pReq as IRequestInfo).
     
     method public void SerializeRow(hBuffer as handle,hStream as handle).
/*     method public void DeserializeRow(hBuffer as handle,hStream as handle).*/
    
     method public void ValidateRelationChanges(hRel as handle,pReq as IRequestInfo).    
     method public void ValidateRowChanges(hBuffer as handle,pReq as IRequestInfo).
            
     method public handle extent HideColumns(cList as char).
     method public handle extent HideUrlColumns().
     method public void ViewHiddenColumns(phdls as handle extent).
end interface.