/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation.      */
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

using Progress.Lang.*.

using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Lang.IQueryMap from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.Message.ISaveRequest from propath.

interface OpenEdge.DataAdmin.Binding.IDataAdminModel inherits IDataAdminContext:  
     
     define public event SearchQuery signature void (id as char,input-output queryContext as IDataAdminContext). 
     define public event SearchRequest signature void (Req as IRequestInfo,pcParent as char,pcKeys as char extent,input-output queryContext as IDataAdminContext). 
     define public event BeforeDelete  signature void (rid as rowid). 
  
     /** returns the query with the values inserted according to GetJoinFields
         - must match order of GetQueryHandles 
        @param serializename of parent   
        @param keyvalue can hold values for any datatype */ 
     method public character GetChildQuery(parentid as char,pcKeyValue as char).
     /** returns the query with the values inserted according to GetJoinFields 
        @param serializename of parent  
        @param keyvalues can hold values for any datatype */ 
     method public character GetChildQuery(parentid as char,pcKeyValues as char extent).
    
     /** returns the server query with the values inserted according to GetJoinFields 
         defaults to return the GetChildQuery 
        override if different query is needed on  
         @param serializename of parent   
         @param keyvalue can hold values for any datatype */    
     method public character GetServerChildQuery(parentid as char,pcKeyValue as char).

     /** returns the server query with the values inserted according to GetJoinFields 
         defaults to return the GetChildQuery 
        override if different query is needed on  
         @param serializename of parent   
         @param keyvalues can hold values for any datatype */ 
     method public character GetServerChildQuery(parentid as char,pcKeyValues as char extent).
     
     /**  Get default buffer handles 
          to use in child query for parent  
        - must match order of GetChildQuery
        @param serializename of parent   
       */
     method public handle extent GetQueryHandles(parentid as char).  
     
     method public char TransformQuery(pcTables as char, pWhere as char,mapcontxt as IQueryMap).    
     
     method public ISaveRequest GetSaveRequest(pid as char).    
     method public ISaveRequest GetSaveRowRequest(pcKey as char,pReq as IRequestInfo):
     method public ISaveRequest GetDeleteRowRequest(pcKey as char,pReq as IRequestInfo):
     method public ISaveRequest GetCreateRowRequest():    
     
     method public IDataAdminElement FindEntity(h as handle,pReq as IRequestInfo).
       
     /** find in current data (no service request) */
     method public IDataAdminElement FindEntity(i as int,pReq as IRequestInfo).
     
     
     /** find in current data (no service request) */
     method public IDataAdminElement FindEntity(c as char,pReq as IRequestInfo).
     
     /** find in current data (no service request) */
     method public IDataAdminElement FindEntity(c as char extent,pReq as IRequestInfo).
     
     method public void ValidateRelationChanges(hRel as handle,pReq as IRequestInfo).    
     method public void ValidateRowChanges(hBuffer as handle,pReq as IRequestInfo).
            
     method public handle extent HideColumns(cList as char).
     method public handle extent HideUrlColumns().
     method public void ViewHiddenColumns(phdls as handle extent).
end interface.