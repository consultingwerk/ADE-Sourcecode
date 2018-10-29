/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IObjectArrayHolder
    Purpose     : An obejct wrapper for an array of P.L.Object instances
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-04-24
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Core.IObjectArrayHolder:
    /* The array of objects being held. May be indeterminate or empty */
    define public property Value as class Progress.Lang.Object extent no-undo
        get.
end interface.