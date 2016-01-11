/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IMapEntry
    Purpose     : A map entry (key-value pair). 
                  The IMap:EntrySet returns a set-view of the map, 
                  whose elements are of this class. 
                   
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Apr 11 23:46:14 EDT 2010
    Notes       : The only way to obtain a reference to a map entry is 
                  from the iterator of the IEntrySet.
                  The IMapEntry objects are valid only for the duration 
                  of the iteration.                      
  ----------------------------------------------------------------------*/
using Progress.Lang.Object.

interface OpenEdge.Core.Collections.IMapEntry:  
    define property Key   as Object no-undo get.
    define property Value as Object no-undo get. set.
end interface.
