/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IMemoryPointer
    Purpose     : Interface to represent a MEMPTR's pointer data, allowing
                  by-reference access to a MEMPTR, and avoiding a copy of
                  the MEMPTR that accessing a Value property (eg in the IMemprtHolder
                  interface) would cause.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2021-09-15
    Notes       :   
  ----------------------------------------------------------------------*/
@since(rel='12.5.0':u).
interface OpenEdge.Core.IMemoryPointer:
    /* The number of bytes in the memptr */
    define public property Size as int64 no-undo
        get.
    
    /* A pointer to the underlying/wrapped memptr */
    define public property PointerValue as int64 no-undo
        get.
    
end interface.