/************************************************
  Copyright (c) 2016, 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Security Role interface  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IGrantedRoleSet.

interface OpenEdge.DataAdmin.IRole inherits IDataAdminElement: 
    /* The unique name for the role */
    define public property Name as character no-undo get. set.
    
    /* A free text description to describe the purpose and use of the role */   
    define public property Description as character no-undo get. set.

    /* Returns true if the Role is built-in (a system role) */ 
    define public property IsBuiltin as logical no-undo get.  
    
    /* Used to designate the Role is used for Dynamic Data Masking (DDM) */ 
    define public property IsDDM as logical no-undo get. set.
    
    /* The name of the user or role that created / owns this role definition. */
    define public property Creator as character no-undo get. set.    

    /* This is a free field to hold custom specific role details */   
    define public property CustomDetail as character no-undo get. set.
    
    /* Collection of Granted Roles for this Role Domain */
    define public property GrantedRoles as IGrantedRoleSet no-undo get.     

end interface.
