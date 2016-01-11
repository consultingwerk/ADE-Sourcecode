/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : interface for partition parent (defaults,  data enabling, allocate )  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Feb 2013
    Notes       : Not mapped directly to any data source  
                  Sub interfaces 
                   -  IPartitionPolicy
                   -  IPartitionOwner
                         - ITenant
                         - ITenantGroup  
                         - IPartitionPolicyDetail 
  ----------------------------------------------------------------------*/
 
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath. 
using OpenEdge.DataAdmin.IPartitionMap from propath.
 
interface OpenEdge.DataAdmin.IPartitionParent inherits IDataAdminElement :  
      
    /** Name character unique identifier - max length 32 */    
    define public property Name as char no-undo                get. set.
    
    /** Description   */    
    define public property Description as char no-undo         get. set.
    
    /** DefaultDataArea 
          The name of the default data area for new partitions */    
    define public property DefaultDataArea   as IArea no-undo   get. set.
    
    /** DefaultIndexArea 
          The name of the default index area for new partitions */    
    define public property DefaultIndexArea  as IArea no-undo   get. set.
    
    /** DefaultLobArea 
          The name of the default lob area for new partitions */    
    define public property DefaultLobArea    as IArea no-undo   get. set.
    
    /** A preference setting that decides whether to allocate partitions when the parent 
        is created, when tables are multi-tenant enabled or new multi-tenant tables, 
        indexes or lob fields are created or policy details are created. 
        The preference can have the following values:
        -   Immediate – allocate immediately using default areas. 
            Allocates all partitions according to the defaults when the parent is created.  
        -   Delayed – Delay the physical allocation of the partitions. S
                      Sets the partitions AllocateState to "Delayed" and allowing them 
                      to be allocated when the IPartitionParent:Allocate() operation is executed.   
        -   None – No automatic allocation. 
                   Sets the partitions AllocateState to "None", which means that the 
                   allocation only can be done directly on the actual Partition. 
                  (Some owning classes may allow Allocate("All") ) */    
    define public property DefaultAllocation as char no-undo    get. set.
   
   
end interface.