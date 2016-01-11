/*------------------------------------------------------------------------
    File        : ClassClassMap
    Purpose     : Mapping of types
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 09:51:35 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

{OpenEdge/Core/Collections/typedmapclass.i
    &Package        = OpenEdge.Core.Collections
    
    &MapType   = ClassClassMap
    &KeyType   = Progress.Lang.Class
    &ValueType = Progress.Lang.Class 
    }
