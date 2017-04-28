/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BuilderRegistry
    Purpose     : General registry for name/Progress.Lang.Class pairs used
                  by the various builders. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 12 11:39:54 EST 2015
    Notes       : * this is technically a typed Map, but will be kept separate
  ----------------------------------------------------------------------*/

using OpenEdge.Core.Assert.
using Progress.Lang.Object.
using OpenEdge.Core.Util.BuilderRegistry.

class OpenEdge.Core.Util.BuilderRegistry:
    /* Returns the number of mappings in this map.*/
    define public property Size as integer no-undo get. private set.
    
    /** (optional) The type of the registered Type (defaults to PLO) */
    define public property ValueType as Progress.Lang.Class no-undo get. private set.
    
    define static private temp-table Registry no-undo
        field ParentRegistry as integer
        field TypeKey as character 
        field Type as Object
        index idx1 as primary unique ParentRegistry TypeKey.
        
    /** Default constructor */
    constructor public BuilderRegistry():
        this-object(get-class(Progress.Lang.Object)).
    end constructor.

    /** Constructor 
    
        Creates clone of the input registry into the current one.
        
        @param BuilderRegistry THe source registry     */
    constructor public BuilderRegistry(input poRegistry as BuilderRegistry):
        Assert:NotNull(poRegistry, 'Source registry').
        assign this-object:ValueType = poRegistry:ValueType.
        
        PutAll(poRegistry).        
    end constructor.

    /** Constructor
    
        @param Progress.Lang.Class The type that the registered value must conform to
                                   (via IsA() ). */
    constructor public BuilderRegistry(input poValueType as Progress.Lang.Class):
        Assert:NotNull(poValueType, 'Value type').
        assign this-object:ValueType = poValueType.
    end constructor.
    
    destructor BuilderRegistry():
        this-object:Clear().
    end destructor.
    
    /* Adds the contents of one registry to another. THis is an overwite 
       operation (ie existing maps are overwritten; new ones added)
       
       Call Clear() to delete nefore additions.
       
       @param BuilderRegistry THe source of entries to add */
    method public void PutAll(input poRegistry as BuilderRegistry):
        define buffer lbSourceRegistry for Registry.
        
        Assert:NotNull(poRegistry, 'Source registry').
        Assert:IsType(poRegistry:ValueType, this-object:ValueType).
        
        /* We use the 'internals' TT for speed/simplicity */
        for each lbSourceRegistry where
                 lbSourceRegistry.ParentRegistry eq int64(poRegistry):
            this-object:Put(lbSourceRegistry.TypeKey,
                            cast(lbSourceRegistry.Type, Progress.Lang.Class)).
        end.
    end method.
    
    /** Registers type for a key 
    
        @param character The key of the type to register
        @param Class The type of the writer used to process that type
        @return logical True if the type was previously registered */
    method public logical Put(input pcTypeKey as character,
                              input poType as class Progress.Lang.Class):
        define variable lExists as logical no-undo.
        define buffer lbRegistry for Registry.
        
        Assert:NotNull(pcTypeKey, 'Type key').
        Assert:IsType(poType, this-object:ValueType).
                
        find lbRegistry where
             lbRegistry.ParentRegistry eq int64(this-object) and
             lbRegistry.TypeKey eq pcTypeKey
             no-error.
        assign lExists = available lbRegistry.
        if not lExists then
        do:
            create lbRegistry.
            assign lbRegistry.ParentRegistry = int64(this-object)
                   lbRegistry.TypeKey = pcTypeKey
                   this-object:Size = this-object:Size + 1.
        end.
        assign lbRegistry.Type = poType.
        
        return lExists.                                       
    end method.
    
    /** Deregisters a content type writer 
    
        @param character The name of the content type to register
        @return logical True if the content type was previously registered */
    method public logical Remove(input pcTypeKey as character):
        define variable lExists as logical no-undo.
        define buffer lbRegistry for Registry.
        
        Assert:NotNull(pcTypeKey, 'Type key').
        
        find lbRegistry where
             lbRegistry.ParentRegistry eq int64(this-object) and
             lbRegistry.TypeKey eq pcTypeKey
             no-error.
        assign lExists = available lbRegistry.
        if lExists then
        do:
            delete lbRegistry.
            assign this-object:Size = this-object:Size - 1.
        end.
        return lExists.                                       
    end method.    

    /** Indicates whether a content type is registered or not. 
        
        @param character The name of the content type to register
        @return logical True if the content type is registered */
    method public logical Has(input pcTypeKey as character):
        define buffer lbRegistry for Registry.
        
        Assert:NotNull(pcTypeKey, 'Type key').
        
        find lbRegistry where
             lbRegistry.ParentRegistry eq int64(this-object) and
             lbRegistry.TypeKey eq pcTypeKey
             no-error.
        
        return available lbRegistry.
    end method.
    
    /** Returns a registered type, if it exists. returns null otherwise.
        
        @param character The name of the content type to register
        @return Progress.Lang.Class A valid value if it exists. Null otherwise .*/
    method public class Progress.Lang.Class Get(input pcTypeKey as character):
        define buffer lbRegistry for Registry.
        
        Assert:NotNull(pcTypeKey, 'Type key').
        
        find lbRegistry where
             lbRegistry.ParentRegistry eq int64(this-object) and
             lbRegistry.TypeKey eq pcTypeKey
             no-error.

        if available lbRegistry then
            return cast(lbRegistry.Type, Progress.Lang.Class).
        
        return ?.
    end method.
    
    /** Clears all the entries from this registry */
    method public void Clear():
        define buffer lbRegistry for Registry.
        for each lbRegistry where
                 lbRegistry.ParentRegistry eq int64(this-object):
            delete lbRegistry.
        end.
        assign this-object:Size = 0.
    end method.
    
    /** Returns an array of the key names in this registry.
        
        @return character[] The key values. Indeterminate array if empty. */
    method public character extent GetKeys():
        define variable cKeys as character extent no-undo.
        define buffer lbRegistry for Registry.
        define query qryRegistry for lbRegistry.
        
        open query qryRegistry 
            preselect each lbRegistry where
                           lbRegistry.ParentRegistry eq int64(this-object).
        
        extent(cKeys) = query qryRegistry:num-results.
        
        get first qryRegistry.
        do while not query qryRegistry:query-off-end:
            assign cKeys[query qryRegistry:current-result-row] = lbRegistry.TypeKey.
            get next qryRegistry.
        end. 
        
        return cKeys.
        finally:
            close query qryRegistry.
        end finally.
    end method.
    
end class.