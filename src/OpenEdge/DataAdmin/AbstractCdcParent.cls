 
 /*------------------------------------------------------------------------
    File        : AbstractCdcParent
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Thu Nov 19 16:09:14 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
  
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.ICdcMap.
using OpenEdge.DataAdmin.ICdcParent.
using OpenEdge.DataAdmin.IRequestInfo.

class  OpenEdge.DataAdmin.AbstractCdcParent abstract inherits Entity implements ICdcParent : 
    
    define protected property ValidDefaultLevelList as char 
       init ?
       get():
           return GetValidDefaultLevelList(). 
       end.
         
    define public abstract property Level as int no-undo 
    get.
    set. 
    
    define public abstract property CdcTablePolicyName as char no-undo 
    get.
    set.
    
    define public abstract property ChangeTable as char no-undo 
    get.
    set.
    
    define public abstract property ChangeTableOwner as char no-undo 
    get.
    set.

    define public abstract property DataArea as OpenEdge.DataAdmin.IArea no-undo 
    get.
    set. 

    define public abstract property IndexArea as OpenEdge.DataAdmin.IArea no-undo 
    get.
    set. 

    define public property Description as char no-undo         
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Description.
            else
                return Description. 
        end.
        set(pDescription as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Description = pDescription.
            end.
            else
                Description = pDescription.
        end.  
        
    method protected char GetValidDefaultLevelList(): 
        return "0,1,2".
    end method.
    
    constructor public AbstractCdcParent ( input pname as character ):
        super (pname).
        
    end constructor.

        
    constructor public AbstractCdcParent (  cntxt as IDataAdminModel, preq as  IRequestInfo ):
        super (cntxt, preq).
        
    end constructor.

        
    constructor public AbstractCdcParent (  cntxt as IDataAdminModel ):
        super (cntxt).
        
    end constructor.

end class.