 /*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : TablePermissionContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :   2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IServiceContextFactory.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using OpenEdge.DataAdmin.Message.SaveRequest.
using OpenEdge.DataAdmin.TablePermission.
using OpenEdge.DataAdmin.TablePermissionSet.
using Progress.Lang.*.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope from propath.

class OpenEdge.DataAdmin.Binding.TablePermissionContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/tablepermission.i}
     
    define private dataset dsTablePermission serialize-name "root" for ttTablePermission.
    define buffer bTablePermission for ttTablePermission.
    define temp-table copytable reference-only like ttTablePermission .  
    
    define variable mLastSavedTable as handle no-undo.
     
    
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttTablePermission:handle.
    	end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return TableHandle:default-buffer-handle:Keys. 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bTablePermission for ttTablePermission.
            if Count = ? then
            do:
                Count = 0.
                for each bTablePermission:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
	constructor public TablePermissionContext ( pScope as IServiceContextFactory):
        super ("TablePermission",pscope).
    end constructor.
    
    method protected override void initChildren(pScope as IContextScope):
         initchildren(cast(pScope,IServiceContextFactory)).
    end method.  
    
    /* temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsTablePermission:handle. 
    end method.
        
    method protected void initChildren(pScope as IServiceContextFactory):
        AddChild(pscope:FieldPermissionContext).
    end method.  
    
	
	method public override void CopyTable(cntxt as IDataAdminModel).
        undo, throw new UnsupportedOperationError("Copy TablePermission").
    end method. 
     
    method public override void CreateRow(entity as IDataAdminElement):
        undo, throw new UnsupportedOperationError("Create TablePermission row").
    end method. 
	
    method public override character GetJoinFields(parentid as char):
        case parentid:
            when "schemas" then 
                return "Name,SchemaName".
        end.
    end.
      
    method public override void ExportLastSavedTree( pcfile as char ):
        define variable hDs as handle no-undo.
        define variable tree as IContextTree no-undo.
        tree = new ContextTree().
        if valid-handle(mLastSavedTable) then  
            tree:SetHandle("tables",mLastSavedTable).
        tree:SetJoin("tables","partitions","Name,TableName").    
        
        hDs = tree:GetReadHandle().
        hDs:write-json ("File",pcFile,yes).        
    end method.
      
	method public override logical CanFind(name as character):
        return can-find(ttTablePermission where ttTablePermission.name = name).            
    end.    
     
    method public override logical Find(name as character):
        find ttTablePermission where ttTablePermission.name = name no-error.
        return avail ttTablePermission.            
    end.    
      
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new TablePermissionSet(cntxt). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(pReq as IRequestInfo):
        return new TablePermission(this-object,pReq). 
    end method. 
end class.
