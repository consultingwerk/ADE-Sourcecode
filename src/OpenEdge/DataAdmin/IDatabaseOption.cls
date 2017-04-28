/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IDatabaseOption
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Apr 20 12:04:47 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminElement.

interface OpenEdge.DataAdmin.IDatabaseOption inherits IDataAdminElement:
    /* The Option code */
    define public property Code as character no-undo get. set.

    /* A description of the code */
    define public property Description as character no-undo get. set.
    
    /** Returns true if the DbOption is builtin  */ 
    define public property IsBuiltin as logical   no-undo get.
    
    /* The option type. If IsBuiltin, will map to a value in OpenEdge.DataAdmin.DbOptionTypeEnum */
    define public property OptionType as integer no-undo get. set.
    
    /* The value of the option */
    define public property OptionValue as character no-undo get. set.
end interface.