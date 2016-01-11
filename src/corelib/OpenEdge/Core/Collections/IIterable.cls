/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IIterable
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 16 14:50:55 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.Collections.IIterator.
 
interface OpenEdge.Core.Collections.IIterable:
    /** Returns an iterator object.
     
        @param IIterator */
    method public IIterator Iterator().
end interface.