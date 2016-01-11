/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------------
    File        : Collection
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 22:41:40 EST 2007
    Notes       : 
------------------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.Collection.
using OpenEdge.Core.Collections.AbstractTTCollection.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.Collection serializable inherits AbstractTTCollection: 
   /*---------------------------------------------------------------------------
    Purpose: General collection class                                                                
    Notes:   
    --------------------------------------------------------------------------*/
     
    /* default temp-table  */ 
    define private temp-table ttCollection no-undo
      field objectref as Object
      index objidx objectref.
      
    constructor public Collection():
        super (temp-table ttCollection:handle,"objectref").
    end constructor.
    
    constructor public Collection (c as ICollection):
        super (c,temp-table ttCollection:handle, "objectref").
    end constructor.

    method public override logical Contains( checkObject as Object):
        define variable lContains as logical no-undo.
        define buffer lbCollection for ttCollection.
        
        if not valid-object(checkObject) then
            return false.
        
        /* try by-reference first */
        lContains = can-find(lbCollection where lbCollection.ObjectRef = checkObject). 
        for each lbCollection while lContains = false:
            lContains = lbCollection.ObjectRef:Equals(checkObject).
        end.
        
        return lContains.
    end method.

    method protected override void FindBufferUseObject ( o as Object ):
        find ttCollection where ttCollection.objectref eq o no-error.
        if available ttCollection then 
            return.
        
        for each ttCollection:
            if ttCollection.objectref:Equals(o) then
                return.
        end.
    end.
     
end class.
