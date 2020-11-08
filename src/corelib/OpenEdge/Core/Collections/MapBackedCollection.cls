/************************************************
Copyright (c) 2013, 2017, 2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : BackedTTAbstractCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 16 16:24:45 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.Iterator.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.System.UnsupportedOperationError.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.MapBackedCollection abstract serializable 
        implements ICollection:
    
    define protected property OwningMap  as IMap no-undo get. private set.
    define protected property OwningBuffer as handle no-undo get. private set.
    define protected property KeyField as handle no-undo get. private set.
    
    /* (optional) Query string, to filter the records in the temp-table. Should not have a WHERE prefix */
    define protected property QueryString as character no-undo
        get.
        private set.
    
    define public property Size as integer no-undo 
    get():
        return OwningMap:Size.
    end. 
    
    constructor public MapBackedCollection(poMap as IMap,phTT as handle, pcValuefield as char):
        this-object(poMap, phTT, '':u, pcValuefield).
    end constructor.
    
    /* Constructor
       
       @param IMap The owning map
       @param handle The underlying TT holding the data
       @param character (optional) Query string 
       @param character The field holding the data in the TT */
    constructor public MapBackedCollection(input pMap as IMap,
                                           input pTT as handle, 
                                           input pQueryString as character,
                                           input pValuefield as character):
        super ().
        assign OwningBuffer = pTT
               KeyField     = OwningBuffer:default-buffer-handle:buffer-field (pValuefield)
               OwningMap    = pMap
               .
        if pQueryString eq ? then
            assign QueryString = '':u.
        else
            // strip off any leading WHERE
            assign QueryString  = left-trim(trim(pQueryString), 'where':u).
    end constructor.
    
    method public logical Add(newObject as Object):
       return error new UnsupportedOperationError('Add', this-object:GetClass():TypeName).
    end method.

    method public logical AddAll( newCollection as ICollection ):
        return error new UnsupportedOperationError('AddAll', this-object:GetClass():TypeName).
    end method.
    
    method public logical AddArray(o as Object extent ):
        return error new UnsupportedOperationError('AddArray', this-object:GetClass():TypeName).    
    end method.

    method public void Clear():
        OwningMap:Clear().
    end method.
    
    method public logical IsEmpty():
        return OwningMap:IsEmpty().
    end method.
    
    /* abstract because this could be a key or value */
    method abstract public logical Contains( checkObject as Object).
    
    /* abstract because this could be a collection of keys or values */
    method abstract public logical ContainsAll(input poCollection as ICollection).
    
    /* abstract because this could be a collection of keys or values */
    method abstract public logical Remove( poOld as Object).
    
    /* abstract because this could be a collection of keys or values */
    method abstract public logical RemoveAll(poRemoveCol as ICollection).
    
    /* abstract because this could be a collection of keys or values */
    method abstract public logical RetainAll(input poRetainCollection as ICollection).
    
    /* Returns a new IIterator over the collection. */
    method public IIterator Iterator():
        return new Iterator(this-object,this-object:OwningBuffer,this-object:KeyField:name, '':u, QueryString).
    end method.
    
    /* ToArray should not be used with large collections
       If there is too much data the ABL will throw:  
       Attempt to update data exceeding 32000. (12371) */
    method public Object extent ToArray():
        define variable i as integer no-undo.
        define variable oObjArray as Object extent no-undo.
        define variable iterator as IIterator no-undo.
        
        if Size eq 0 then
            return oObjArray.
            
        extent(oObjarray) = Size.
        iterator = Iterator(). 
        do while iterator:hasNext():
           i = i + 1.
           oObjArray[i] = iterator:Next().  
        end.
        return oObjArray.
    end method.
    
    /* Returns a TT of the collection's data.
       This may be expensive, depending on the amount of data in the map.
       
       @param output table-handle A TT containing the data. */
    method public void ToTable(output table-handle tt):
        define variable qry as handle no-undo.
        define variable buf as handle no-undo.
        define variable srcBuf as handle no-undo.
        
        create temp-table tt.
        
        // the SSMap table is shared across all instances
        if type-of(OwningMap, StringStringMap) then
        do on error undo, throw:
            tt:add-fields-from(this-object:OwningBuffer, 'ParentMap':u).
            tt:add-new-index('idx1':u, true, true).
            tt:add-index-field('idx1':u, 'Key':u).
            tt:add-new-index('idx2':u).
            tt:add-index-field('idx2':u, 'ValHash':u).
            tt:temp-table-prepare(this-object:OwningBuffer:name).
            
            assign buf    = tt:default-buffer-handle
                   srcBuf = this-object:OwningBuffer:default-buffer-handle
                   .
            create query qry. 
            qry:add-buffer(srcBuf).
            qry:query-prepare(substitute('preselect each &1 where &2':u, 
                                          srcBuf:name, (if QueryString eq '':u then 'true':u else QueryString))).
            qry:forward-only = true.
            qry:query-open().
            
            qry:get-first().
            do while not qry:query-off-end
            // single tx for all, since we want the whole collection 
            transaction:
                buf:buffer-create().
                buf:buffer-copy(srcBuf).
                buf:buffer-release().
                
                qry:get-next().
            end.
            finally:
                if valid-handle(qry) then
                do:
                    if qry:is-open then
                        qry:query-close().
                    delete object qry.
                end.
            end finally.
        end.
        else
            // no prefix desired
            tt:copy-temp-table(OwningBuffer, ?, ?, ?, '':u).
        
        finally:
            // will be cleaned up by the AVM _after_ the caller gets the handle
            delete object tt.
        end.
    end method.
    
end class. 
