/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : List
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 10:45:45 EST 2008
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Collections.AbstractTTCollection.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.Iterator.
using OpenEdge.Core.Collections.IListIterator.
using OpenEdge.Core.Collections.ListIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.List serializable inherits AbstractTTCollection
        implements IList : 
    /*------------------------------------------------------------------------------
            Purpose:                                                                        
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    /* default temp-table  */ 
    define temp-table ttList no-undo
      field sequence as int 
      field objectref as Object 
      index objidx objectref
      index seq as unique primary sequence.
        .
        
    constructor public List(  ):
        super (temp-table ttList:handle,'objectref').        
    end constructor.
       
    constructor public List (list as IList):
        super (cast (list,ICollection),temp-table ttList:handle,'objectref').        
    end constructor.
    
    constructor protected List ( input poCol as ICollection, input phtt as handle, input pcField as character ):
        super (input poCol, input phtt, input pcField).
    end constructor.
        
    constructor protected List ( input phtt as handle, input pcField as character ):
        super (input phtt, input pcField).
    end constructor.

    constructor protected List ( input phtt as handle, input hField as handle ):
        super (input phtt, input hField).
    end constructor.
    
    method protected override void FindBufferUseObject (findObject as Object):
        define variable lFoundRecord as logical no-undo.
        lFoundRecord = false.
        
        for each ttList where objectref = findObject by ttList.sequence:
            lFoundRecord = true.
            return.
        end.
        
        for each ttList     
                 by ttList.sequence
                 while not lFoundRecord:
            lFoundRecord = ttList.objectref:Equals(findObject).
        end.
    end method.

    method public logical Add(seq as integer, obj as Object ):    
        define buffer btList for ttList.
        
        if super:Add(obj) then
        do:
            for each btList where btList.sequence >= seq by btList.sequence desc:
                btList.sequence = btList.sequence + 1. 
            end.
            
            ttList.Sequence = seq.
            return true.
        end.
        return false.
    end method.
   
    method public override logical Add(obj as Object ):    
        define variable iSeq as integer no-undo.
        if super:Add(obj) then
        do:
            /* once in a while we lose the availability of the ttList buffer. */
            findBufferUseObject(obj).
            
            ttList.Sequence = Size.
            return true.
        end.
        return false.
    end method.
    
    method public logical AddAll(seq as int,c as ICollection):
        define buffer btList for ttList.
        define variable iterator as IIterator no-undo.
        for each btList where btList.sequence >= seq by btList.sequence desc:
            btList.sequence = btList.sequence + c:Size + 1. 
        end.
        iterator = c:Iterator(). 
        do while iterator:HasNext():
            super:Add(iterator:Next()).
            ttList.Sequence = Seq.
            seq = seq + 1.
        end.                                     
        return true.         
    end method.
    
    method public logical AddArray(seq as int, obj as Object extent):       
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        define buffer btList for ttList.
        
        iMax = extent(obj).
        
        for each btList where btList.sequence >= seq by btList.sequence desc:
            btList.sequence = btList.sequence + iMax + 1. 
        end.
        
        do iLoop = 1 to iMax:
            super:Add(obj[iLoop]).
            ttList.Sequence = Seq.
            seq = seq + 1.
        end.
        
        return true.         
    end method.
     
    /* two lists are defined to be equal if they contain the same elements in the same order */
    method public override logical Equals(o as Object):
        define buffer btList for ttList.
        define variable oList as List no-undo.
        if super:Equals(o) then 
            return true.
        if type-of(o,List) then
        do:
            oList = cast(o,List).
            if oList:Size = Size then
            do:
                for each btList:
                    if btList.objectref <> oList:Get(btList.Sequence) then
                        return false. 
                end.    
                return true.
            end.    
        end.
        return false.    
    end method.    
                                                                     
    method public Object Get(i as integer):    
        find ttList where ttList.sequence = i no-error.
        if avail ttList then 
            return ttList.objectref.
        else
            return ?.    
    end method.
    
    method public integer IndexOf(obj as Object ):
        define variable iIndex as integer no-undo.
        
        for first ttList where objectref = obj by ttList.sequence:
            iIndex = ttList.sequence. 
        end.
        
        for each ttList 
                 by ttList.Sequence
                 while iIndex eq 0: 
            if ttList.objectref:Equals(obj) then
                iIndex = ttList.sequence. 
        end.
        
        return iIndex.    
    end method.
     
    /* Returns a new IIterator over the collection.  */
    method public override IIterator Iterator(  ):        
        return new Iterator(this-object,temp-table ttList:handle,"objectref","sequence").
    end method.
    
    /* Returns a new IListIterator over the collection.  */
    method public IListIterator ListIterator(  ):        
        return new ListIterator(this-object,temp-table ttList:handle,"objectref","sequence").
    end method.
    
    /* Returns a new IListIterator over the collection.*/
    method public IListIterator ListIterator(i as integer):
        return new ListIterator(this-object,temp-table ttList:handle,"objectref","sequence","sequence >= " + string(i)).
    end method.
    
    method public integer LastIndexOf(obj as Object ):
        define variable iIndex as integer no-undo.
        
        for last ttList where objectref = obj by ttList.sequence:
            iIndex = ttList.sequence. 
        end.
        
        for each ttList 
                 by ttList.Sequence descending
                 while iIndex eq 0: 
            if ttList.objectref:Equals(obj) then
                iIndex = ttList.sequence. 
        end.
        
        return iIndex.    
    end method.
    
    method override public logical Remove(oldObject as Object ):
        define variable iStart as integer no-undo.
        define buffer btList for ttList.
        findBufferUseObject(oldObject). 
        if avail ttList then
        do:
            iStart = ttList.sequence.
            if super:remove(oldobject) then
            do:
                for each btList where btList.Sequence > iStart:
                    btList.sequence = btList.Sequence - 1.     
                end.
                return true.
            end. 
        end.    
        return false.
    end method.
    
    method public Object Remove(i as integer):        
        define variable oldObject as Object.
        oldObject = get(i).
        Remove(oldObject).
        return oldObject.
    end method.
    
    method public Object Set( input i as integer, input poReplacement as Object ):
        define variable oldObject as Object.
        find ttList where ttList.sequence = i no-error.
        if avail ttList then 
        do: 
            assign 
                oldObject        = ttList.objectref  
                ttList.objectref = poReplacement.
            return oldObject. 
        end.
    end method.
    
    method public IList SubList(fromIndex as integer, toIndex as integer):
        define variable list as IList no-undo.
        define variable oObject as Object no-undo.
        list = new List().
        do fromIndex = fromIndex to toIndex - 1:
           oObject = get(fromIndex).
           if valid-object(oObject) then
              list:add(oObject).  
           else do: 
              delete object list. 
              return ?. 
           end.     
        end.
        return list.
    end method. 
end class.
