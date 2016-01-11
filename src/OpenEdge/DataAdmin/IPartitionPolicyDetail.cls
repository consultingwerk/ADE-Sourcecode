/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : interface for partition detail  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2013
    Notes       : This defines the value(s) of the partition  
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IPartitionOwner.
using OpenEdge.DataAdmin.IPartitionPolicy.

interface OpenEdge.DataAdmin.IPartitionPolicyDetail inherits IPartitionOwner : 
     
    /** The parent policy the detail belongs to  (read-only) */
    define public property PartitionPolicy as IPartitionPolicy  no-undo  get. 
    
    /** Returns true if this is a composite partition (shared default)  */
    define public property IsComposite as logical  no-undo  get. 
    
    /** true if the partition is a split-target (waiting for split merge)  */
    define public property IsSplitTarget as logical  no-undo  get. set.
    
       
    /** Array of values as char. Dates according to session dmy and decimals according to session numeric-format  
        Note: This is not a direct map to the database, which stores dates and decimals in american formats 
        Export and import uses american formats */   
       
    define public property Values  as char no-undo extent  get. 
     
    /* Sets a value to the element at the specified position in the Values Array. */
    method void SetValue(pval as char).
    method void SetValue(pval as char, pidx as int).
    method void SetValue(pval as log).
    method void SetValue(pval as log, pidx as int).
    method void SetValue(pval as int).
    method void SetValue(pval as int, pidx as int).
    method void SetValue(pval as int64).
    method void SetValue(pval as int64, pidx as int).
    method void SetValue(pval as dec).
    method void SetValue(pval as dec, pidx as int).
    method void SetValue(pval as date).
    method void SetValue(pval as date, pidx as int).
    method void SetValue(pval as datetime).
    method void SetValue(pval as datetime, pidx as int).
    method void SetValue(pval as datetime-tz).
    method void SetValue(pval as datetime-tz, pidx as int).
    
end interface.