/************************************************
  Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Security Role-AuthTag interface  
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IGrantedRoleSet.

interface OpenEdge.DataAdmin.IAuthTag inherits IDataAdminElement: 

    /* The name for the auth tag */
    define public property Name as character no-undo get. set.

    /* The name for the (DDM) role */
    define public property RoleName as character no-undo get. set.
    
    /* A free text description to describe the purpose and use of the relation */   
    define public property Description as character no-undo get. set.

end interface.
