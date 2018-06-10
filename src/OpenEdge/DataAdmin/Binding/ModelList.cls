/*------------------------------------------------------------------------
    File        : ModelList
    Purpose     : Wrapper for array of IDataAdminModel objects 
    Author(s)   : hdaniels
    Created     : Sun Feb 11 19:18:05 EST 2018
    Notes       : Moved out of DataAdminContext to be able to lazy initiate 
                  children when the list is empty. 
                 (not possible with a pure extent variable)
----------------------------------------------------------------------*/
using Progress.Lang.*.
using OpenEdge.DataAdmin.Binding.IDataAdminModel from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.

block-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.ModelList: 
    define private variable mList as IDataAdminModel extent no-undo. 
    
    define public property Count as integer no-undo 
        get():
            return if extent(mList) = ? then 0 else extent(mList).
        end.   
     
    method public logical Add(pModel as IDataAdminModel):
        define variable i        as integer                no-undo.
        define variable oldcntxt as IDataAdminModel extent no-undo.
        
        extent(oldcntxt) = extent(mList).
        oldcntxt = mList.
        extent(mList) = ?.
        extent(mList) = if extent(oldcntxt) = ? then 1 else extent(oldcntxt) + 1.
        do i = 1 to extent(oldcntxt):
            mList[i] = oldcntxt[i].
        end.
        mList[i] = pModel.        
    end.  
    
    method public IDataAdminModel Get(pi as integer):
        if extent(mList) = ? then 
            undo, throw new IllegalArgumentError("The ModelList has no members").
        
        if extent(mList) < pi or pi <= 0 then 
            undo, throw new IllegalArgumentError(subst("&1 is outside the range of the ModelList")).
         
        return mList[pi].
    end.
      
end class.