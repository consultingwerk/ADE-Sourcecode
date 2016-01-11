/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : interface for partition policy field 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2013
    Notes       : Not mapped directly to any data source  
                  This is exposing the field array in the partition policy in the database
  ----------------------------------------------------------------------*/
 
using OpenEdge.DataAdmin.IDataAdminElement from propath.
 
using OpenEdge.DataAdmin.IPartitionPolicy from propath.
using OpenEdge.DataAdmin.IField from propath.
 
interface OpenEdge.DataAdmin.IPartitionPolicyField inherits IDataAdminElement :      
    define public property Number           as int no-undo                   get.
    
    /** PartitionPolicyName character unique identifier - max length 32 */    
    define public property PartitionPolicy  as IPartitionPolicy no-undo   get. set.  
    
    /** FieldName character unique identifier - max length 32 */    
    define public property Field  as IField no-undo                get. set.  
    
end interface.