/************************************************
Copyright (c) 2016-2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StringArray
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jun 07 09:40:26 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharArrayHolder.

class OpenEdge.Core.StringArray     implements ILongcharArrayHolder:
    /** (mandatory) The LONGCHAR array held by this holder class */
    define public property Value as longchar extent no-undo get. private set.
    
    /* Constructor
       
       @param longchar[] The longchar array value */
    constructor public StringArray(input pcValue as longchar extent):
        assign this-object:Value = pcValue.
    end constructor.

end class.