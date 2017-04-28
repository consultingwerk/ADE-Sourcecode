/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Granted Role interface  
    Syntax      : 
    Description : 
    Author(s)   : pjudge 
    Notes       : 2016-04-25
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRole.

interface OpenEdge.DataAdmin.IGrantedRole inherits IDataAdminElement: 
    /* A globally unique id to identify the granted role record */
    define public property Id as character no-undo get.
    
    /* The unique name for the role */
    define public property Role as IRole no-undo get. set.
    
    /* The user or the role that is granted the use of this role */
    define public property Grantee as character no-undo get. set.
    
    /* The user or role that granted the use of this role */
    define public property Grantor as character no-undo get. set.
    
    /* This is a free field to hold custom specific grant details */   
    define public property CustomDetail as character no-undo get. set.
    
    /* Set true if this user or role may grant the use of this role to others */
    define public property CanGrant as logical no-undo get. set.
    
end interface.
