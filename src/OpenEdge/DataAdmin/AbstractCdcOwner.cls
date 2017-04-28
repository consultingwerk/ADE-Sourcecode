 
 /*------------------------------------------------------------------------
    File        : AbstractCdcOwner
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Thu Nov 19 15:56:56 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using OpenEdge.DataAdmin.AbstractCdcParent.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.ICdcMap.
using OpenEdge.DataAdmin.ICdcOwner.
using OpenEdge.DataAdmin.IRequestInfo. 

class OpenEdge.DataAdmin.AbstractCdcOwner inherits AbstractCdcParent implements ICdcOwner abstract: 
    
    define public property Id as int init ? no-undo             
    get():
        if valid-handle(mBuffer) then
            return mBuffer::id.
        else
            return Id.    
    end.
    

    define public abstract property Instance as int no-undo  get. set.
        
    
    define public property CdcTablePolicies as ICdcMap no-undo  
    get():
        if not valid-object(CdcTablePolicies) then
        do:
            if not valid-object(context:Service) and not valid-object(context:TargetService) then
                undo, throw new IllegalOperationError("CdcTablePolicies are not available in a " + name + "  that is not newed, created or retrieved by a service.").  
            AssertCdcs().
            CdcTablePolicies = cast(GetChildCollection("CdcTablePolicies"),ICdcMap).
   
       end.     
       return CdcTablePolicies.
    end.
    private set.
    
    constructor public AbstractCdcOwner ( input pname as character ):
        super (pname).
        
    end constructor.

        
    constructor public AbstractCdcOwner (  cntxt as IDataAdminModel, preq as  IRequestInfo ):
        super (cntxt, preq).
        
    end constructor.

        
    constructor public AbstractCdcOwner (  cntxt as IDataAdminModel ):
        super (cntxt).
        
    end constructor.
    
   
    method protected abstract void AssertCdcs() .   
end class.