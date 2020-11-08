/*************************************************************/
/* Copyright (c) 2011-2013,2019 by Progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : Common interface for all collections in the OpenEdge.DataAdmin 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jun 10 01:39:52 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
 
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.Binding.* from propath.
using OpenEdge.DataAdmin.Lang.Collections.IIterator from propath.
using OpenEdge.DataAdmin.Lang.Collections.ICollection from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
 
interface OpenEdge.DataAdmin.IDataAdminCollection inherits IDataAdminSerializable, ICollection:  
    /* temporary while waiting for interface inheritance */
                     
    /** defines the context (or scope?) for the instance.
        Used in Equals() to ensure entities with the same keys  
        - blank means the object has no context (yet)   
            new and not attached (in which case equals is only true if exact same 
            object instance)  
         */
    define public property ContextId as char no-undo           get.
 
    /** defines the source (or scope?) for the instance.
        - blank means the object has no source  (yet)   
            new and not attached (in which case equals is only true if exact same 
            object instance)  
        - returns the same as ContextId if this collection is for the entire context    
         */
    define public property SourceId as char  no-undo           get.
 
    define public property HasChanges as logical no-undo get.

    define public property Service as IDataAdminService no-undo get.
     
    /** returns a filtered and/or sorted iterator  
        @param  filter query expression on properties of the entities in the collection 
                       field expressions <b>must</b> be separated by space (also =)
                       values <b>must</b> be quoted. also int, logical dec       */ 
    method public IIterator Iterator( filter as char).
      
    method public void Reset().
            
    method public void ExportTree(cFile as char).  
    method public void ExportTree(cFile as char,pageReq as IPageRequest).
    method public void ExportTree(cFile as char,pcCollections as char).  
     
    method public void Export(). 
    method public void Export(pcFile as char). 
 
    method public void ExportList(). 
    method public void ExportList(pcFile as char). 
    
    /** REST/JSON communication, use after import and call to service create or update */
    method public void ExportLastSaved(pcFile as char).  
    
    /** REST/JSON communication, use after importTree and call to service create or update */
    method public void ExportLastSavedTree(pcFile as char). 
    
    /* import table from file - json - d */ 
    method public void Import(pcFile as char). 
   
    /* import table with children from file - json */ 
    method public void ImportTree(pcFile as char).
    
     /* import new rows with children from file - json */ 
    method public void ImportNewTree(pcFile as char). 
  
    /* import new rows to table from file - json - d */ 
    method public void ImportNew(pcFile as char). 
    
    /* import keys to delete from file -  json only   */ 
    method public void ImportDelete(pcFile as char). 
    
     /* deserialize from stream abl standard import format 
        @return num rows imported */
    method public int Deserialize(phStream as handle).
    method public int Deserialize(phStream as handle,piMax as int).
 
end interface.
