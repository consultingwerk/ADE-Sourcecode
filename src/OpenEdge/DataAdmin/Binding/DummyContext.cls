 
 /*------------------------------------------------------------------------
    File        : DummyContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Dec 17 05:15:41 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level  on error undo, throw. 
  
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.DummyContext inherits DataAdminContext: 
    
    define public override property TableHandle as handle no-undo 
        get.
        private set.
        
    define public override property KeyFields as character  no-undo  
        get():
            return TableHandle:default-buffer-handle:keys. 
        end.   
        
    define public override property Count as integer init ? no-undo  
        get(): 
            
            return Count.
        end.
        protected set.      
		
	constructor public DummyContext (tt as handle):
		super (input "Dummy").	
		TableHandle = tt.
	end constructor.
	        
    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return ?. 
    end method. 
    
	method public override character GetJoinFields(parentid as char):
        return "".
    end.
    
    method public override void CopyTable(cntxt as IDataAdminModel).
        undo, throw new UnsupportedOperationError("Copy Dummy context").
    end method. 
     
    method public override void CreateRow(entity as IDataAdminElement):
        undo, throw new UnsupportedOperationError("Create Dummy context row").
    end method. 
    
    method public override logical CanFind(name as character):
         undo, throw new UnsupportedOperationError("CanFind Dummy context").  
    end.    
     
    method public override logical Find(name as character):
        undo, throw new UnsupportedOperationError("Find Dummy context").
    end.    
    
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        undo, throw new UnsupportedOperationError("CreateCollection in Dummy context").
    end method.
    
    method protected override IDataAdminElement CreateEntity(preq as IRequestInfo):
        undo, throw new UnsupportedOperationError("CreateEntity in Dummy context").
    end method.
        
		
end class.