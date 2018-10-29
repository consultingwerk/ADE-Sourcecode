/* *************************************************************************************************************************
Copyright (c) 2017-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : SchemaOption
    Purpose     : Stores schema options for an operation. Used to customise/
                  overide the structure of the schema returned by an operation 
    Author(s)   : pjudge
    Created     : 2017-08-21
    Notes       : * The ChildSchema collection is internally managed since
                    we don't want to init the collection (it's not typically  
                    going to be populated).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Web.DataObject.SchemaOption.

class OpenEdge.Web.DataObject.SchemaOption serializable:
    /** (mandatory) The name of this schema element */
    define public property SchemaName    as character no-undo get. private set.   //ABL name
    
    /** (optional) TRUE is this element is hidden when for the operation */    
    define public property Hidden as logical no-undo get. set.                  //ABL serialize-hidden
    
    /** (optional) An alternalte name for this element is hidden when for the operation */
    define public property SerializeName    as character no-undo get. set.         //ABL serialize-name
    
    /* (optional) A set of any child schema (fields-of-tables etc). May be unknown. */ 
    define private variable mChildSchema as IStringKeyedMap no-undo.
    
    /** Default constructor. Private since we require a SchemaName */
    constructor private SchemaOption():
        super().
    end constructor.
    
    /* Constructor.
    
       @param character The schema name */
    constructor public SchemaOption(input pName as character):
        this-object().
        
        Assert:NotNullOrEmpty(pName, 'Schema option name').
        
        assign this-object:SchemaName    = pName
               this-object:Hidden        = false        // ABL default
               this-object:SerializeName = ?            // ABL default
               .
    end.
    
    /** Adds or replaces a child schema option
        
        @param SchemaOption The child schema */
    method public void PutChildSchema(input pChildOption as SchemaOption):
        Assert:NotNull(pChildOption, 'Child schema').
        
        if not valid-object(mChildSchema) then
            assign mChildSchema = new StringKeyedMap().
        
        mChildSchema:Put(pChildOption:SchemaName, pChildOption).
    end method.
    
    /** Removes a child schema option
        
        @param SchemaOption The child schema */
    method public void RemoveChildSchema(input pChildOption as character):
        Assert:NotNullOrEmpty(pChildOption, 'Child schema name').
        
        if valid-object(mChildSchema) then
            mChildSchema:Remove(pChildOption).
    end method.
    
    /** Returns TRUE if there is at least one child schema option
        
        @param logical TRUE if there is at least one child schema option, FALSE otherwise */
    method public logical HasChildSchema():
        return (    valid-object(mChildSchema)
                and mChildSchema:Size ge 1    ).
    end method.
    
    /** Returns TRUE if there is a child schema option
        
        @param character The child schema name
        @param logical TRUE if the named schema exists, FALSE otherwise */
    method public logical HasChildSchema(input pChildOption as character):
        Assert:NotNullOrEmpty(pChildOption, 'Child schema name').
        
        if valid-object(mChildSchema) then
            return mChildSchema:ContainsKey(pChildOption).
        
        return false.
    end method.
    
    /** Returns a named child schema
        
        @param character The schema name 
        @param SchemaOption A valid schema object it exists; null/unknown otherwise */
    method public SchemaOption GetChildSchema(input pChildOption as character):
        Assert:NotNullOrEmpty(pChildOption, 'Child schema name').
        
        if valid-object(mChildSchema) then
            return cast(mChildSchema:Get(pChildOption), SchemaOption).
        
        return ?.
    end method.
    
    /** Returns an array of all the child schema names
        
        @return character[] An array of child schema names; if no child schema exists, an 
                            intdeterminate array returns. */
    method public character extent GetChildSchemas():
        define variable schemaNames as character extent no-undo.
        define variable keyIdx as integer no-undo.
        define variable keyIterator as IIterator no-undo.
        
        if     valid-object(mChildSchema) 
           and mChildSchema:Size gt 0 
           then
        do:
            assign extent(schemaNames) = mChildSchema:Size
                   keyIterator         = mChildSchema:KeySet:Iterator()
                   keyIdx              = 1
                   .
            do while keyIterator:HasNext():
                assign schemaNames[keyIdx] = keyIterator:Next():ToString()
                       keyIdx              = keyIdx + 1
                       . 
            end.
        end.
        
        return schemaNames.
    end method.

    method override public character ToString():
        return substitute('name: &1; serialize-name:&3; is-hidden:&3; num-children:&4',
                  this-object:SchemaName,
                  this-object:SerializeName,
                  this-object:Hidden,
                  this-object:mChildSchema:Size).
    end method.
    
end class.