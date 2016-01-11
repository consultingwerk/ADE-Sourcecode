 /*************************************************************/
 /* Copyright (c) 2013 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : indexes of a table
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.* from propath.

using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
 
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.IField from propath.
using OpenEdge.DataAdmin.FieldImpl from propath.
using OpenEdge.DataAdmin.IFieldSet from propath.
using OpenEdge.DataAdmin.DataAdminCollection from propath.
using OpenEdge.DataAdmin.ISchemaElement from propath.
using OpenEdge.DataAdmin.IPartition from propath.
using OpenEdge.DataAdmin.Partition from propath.
 
using OpenEdge.DataAdmin.Binding.Query.IndexFieldQuery from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.

using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath. 
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath. 
 
class OpenEdge.DataAdmin.Support.IndexFieldSet inherits DataAdminCollection implements IFieldSet: 
    
    define private variable IndexFieldQuery as IndexFieldQuery no-undo.
    
    constructor IndexFieldSet(cntxt as IndexFieldQuery):
        super(cast(cntxt,IDataAdminContext)).   
        IndexFieldQuery = cntxt.   
    end constructor. 
    
    method protected override IDataAdminContext CreateLocalContext():
        undo, throw new UnsupportedOperationError("Create local context in TableFieldSet"). 
    end.     
    
    method public override logical Contains(obj as Object):
        return Contains(cast(obj,IField)).   
        catch e as Progress.Lang.Error :
        	return false.	
        end catch. 
    end method.  
    
    method public logical Contains(fld as IField):
         if fld:ContextId <> ContextId then 
            return false.
        if not CanFind(fld:name) then 
            return false.  
          
        return fld:Equals(this-object:Find(fld:name)). 
    end method.  
    
    method public IField Find (pcField as char):
        return cast(IndexFieldQuery:FindEntity(pcField),IField).
    end method. 
            
    method public logical CanFind(pcField as char):
        return IndexFieldQuery:CanFind(pcField). 
    end method. 
     
    method override protected void PrepareExport(  ):
    end method.    
    method override protected void PrepareExportTree(  ):
    end method.    
    method override protected void PrepareExportList(  ):
    end method.    
    
end class.
