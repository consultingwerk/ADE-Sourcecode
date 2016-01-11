 /*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation       */
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
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Binding.Query.PartitionPolicyIndexQuery from propath.
using OpenEdge.DataAdmin.Binding.Query.TableIndexQuery from propath.
using OpenEdge.DataAdmin.Core.JSONWriter from propath.
using OpenEdge.DataAdmin.DataAdminCollection from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IDataAdminExporter from propath.
using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.IIndexSet from propath.
using OpenEdge.DataAdmin.IPartition from propath.
using OpenEdge.DataAdmin.ISchemaElement from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.IndexImpl from propath.
using OpenEdge.DataAdmin.Partition from propath.
using Progress.Lang.* from propath.

routine-level on error undo, throw.
 
class OpenEdge.DataAdmin.Support.TableIndexSet inherits DataAdminCollection implements IIndexSet: 
    
    constructor TableIndexSet(cntxt as TableIndexQuery):
        super(cntxt).   
    end constructor. 
    
    constructor protected TableIndexSet(cntxt as PartitionPolicyIndexQuery):
        super(cntxt).   
    end constructor. 
    
    method protected override IDataAdminContext CreateLocalContext():
        undo, throw new UnsupportedOperationError("Create local context in TableIndexSet"). 
    end.     
    
    method public override logical Contains(obj as Object):
        return Contains(cast(obj,IIndex)).   
        catch e as Progress.Lang.Error :
        	return false.	
        end catch. 
    end method.  
    
    method public logical Contains(idx as IIndex):
         if idx:ContextId <> ContextId then 
            return false.
        if not CanFind(idx:name) then 
            return false.  
        return idx:Equals(this-object:Find(idx:name)). 
    end method.   
    
    method public IIndex Find (pcIndex as char):
        return cast(Context:FindEntity(pcIndex),IIndex).
    end method. 
            
    method public logical CanFind(pcIndex as char):
        return Context:CanFind(pcIndex). 
    end method. 
    
    /* override to add indexfields 
     - in effect override/avoid IndexContext.AddTreeTo override that excludes children 
       (for get_schemas really) */
    method public override void WriteTree(tree as IContextTree):
        WriteTree(tree,"indexFields").     
    end method.
    
    method override protected void PrepareExport(  ):
    end method.    
    method override protected void PrepareExportTree(  ):
    end method.    
    method override protected void PrepareExportList(  ):
    end method. 
     
 
end class.
