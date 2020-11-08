/*************************************************************/
 /* Copyright (c) 2011,2019 by Progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : serializable interface 
                  Defines a common property and methods for both 
                  entities and collections
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Aug 17 09:05:17 EDT 2010
    Notes       : subcinterfaces are IDataAdminEntity and IDataAdminCollection
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.

interface OpenEdge.DataAdmin.IDataAdminSerializable:  
    /** External name of the entity (plural - first character lowercase)
        used in JSON and also as parameter in methods that defines a filter or list of collections */
    define public property SerializeName as char no-undo get.     
    
    define public property RequestInfo as IRequestInfo no-undo get.  
    define public property CodeExtension as char no-undo get.  set.
    
    /** Attaches the object to the context/model 
    @param context IDataAdminContext that holds the data     
     Call cntxt:Copy(oldcontext) if IsAttached is false and context is valid */
 
    method public void Attach(context as IDataAdminContext).
    method public logical CanAttach(context as IDataAdminContext).
 
    /** Writetree is a visitor/serialize method that adds this object and the specified collections to the 
        passed ContextTree. The context tree  
        @param tree the IContextTree to add the object to
        @collections collections comma spearated list of child collections to add to the tree */           
    method public void WriteTree(tree as IContextTree,pcCollections as char).      
    
    /** Writetree is a visitor/serialize method that adds this object and its collections to the passed ContextTree
        @param tree the IContextTree to add the object to */           
    method public void WriteTree(tree as IContextTree).
    
      /* optional call back from context tree. 
         return json  to export instead  of dataset
         return unknown to use standard dataset. write-json  */
    method public JSONObject GetJSONExport(tree as IContextTree).
    
    /* serialize to stream abl standard export format 
       return num rows exported */
    method public int Serialize(phStream as handle).
    
    method public void ExportAsProcedure(pcfile as char).
    method public void ExportAsProcedure(pcfile as char,pcCollectionlist as char).
  
  
    /*          
    method public void WriteList(tree as IContextTree).          
    method public void WriteObject(tree as IContextTree).          
    */   
    
end interface.