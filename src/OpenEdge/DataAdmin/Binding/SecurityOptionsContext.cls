 
 /*------------------------------------------------------------------------
    File        : SecurityOptionsContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rkumar
    Created     : Thu Nov 24 17:58:48 IST 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.SecurityOptions.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.SecurityOptionsContext inherits DataAdminContext: 
    {daschema/securityoptions.i}
    
    define dataset dsSecOpt for ttSecurityOptions.
    
    
    define public override property TableHandle as handle no-undo 
        get():
           return temp-table ttSecurityOptions:handle.
        end.
        private set.
        
    define public override property KeyFields as character  no-undo  
        get():
            return TableHandle:default-buffer-handle:keys. 
        end.   
        
    define public override property Count as integer init ? no-undo  
        get():         
            return 1.
        end.
        protected set.      
        
    constructor public SecurityOptionsContext (pscope as IContextScope):
        super ("SecurityOptions",pScope).    
    end constructor.
    
        /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsSecOpt:handle. 
    end method.
    
    method public override character GetJoinFields(parentid as char):
        return "".
    end.
    
    method public override void CopyTable(cntxt as IDataAdminModel).
        undo, throw new UnsupportedOperationError("Copy SecurityOptions context. There is only one keyless instance").
    end method. 
     
    method public override void CreateRow(entity as IDataAdminElement):
        undo, throw new UnsupportedOperationError("Create SecurityOptions context row. There is only one row").
    end method. 
    
 /*   method public override logical CanFind(name as character):
        return can-find(ttSecurityOptions where ttSecurityOptions.name = name).
    end.   
     
    method public override logical Find(name as character):
        find ttSecurityOptions where ttSecurityOptions.name = name no-error.
        return avail ttSecurityOptions.
    end.    */
    
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        undo, throw new UnsupportedOperationError("CreateCollection in Dummy context. There is only one keyless instance").
    end method.
    
    method protected override IDataAdminElement CreateEntity(preq as IRequestInfo):
        return new SecurityOptions(this-object,preq).
    end method.  
        
end class.