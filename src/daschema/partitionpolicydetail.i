/*************************************************************/
/* Copyright (c) 2013,2014 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Author(s)   : hdaniels
    Created     : Fri Jun 11 20:16:59 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttPartitionPolicyDetail no-undo serialize-name "partitionPolicyDetails" {1} before-table ttPartitionPolicyDetailCopy
     field Id                   as integer         serialize-hidden
     field Name                 as character       serialize-name "name" 
     field IsDataEnabled        as logical         serialize-hidden   init true /* not in use , but shipped public IPartitionPolicyDetail in 11.4 */
     field IsReadOnly           as logical         serialize-name "isReadOnly"
     field IsAllocated          as logical         serialize-name "isAllocated" 
     field IsSplitTarget        as logical         serialize-name "isSplitTarget"  
     field IsComposite          as logical         serialize-name "isComposite"  
   
     field InternalValue        as raw             serialize-hidden
     field InternalSort         as int             serialize-hidden /* remove */
 
     field PartitionPolicyName  as character       serialize-name "partitionPolicyName"
     /* foreign field on server */
     field ObjectNumber         as integer         serialize-hidden
     field TableName            as char            serialize-hidden
     /* index name (to make local during creation) */
     field IndexName            as char            serialize-hidden
     
/*     field DataTypes            as char            serialize-hidden*/
/*     field NumColumns           as int            serialize-hidden */
   
     field Description          as character       serialize-name "description" 
     field DefaultDataAreaName  as character       serialize-name "defaultDataAreaName" /* Must be valid TII area */
     field DefaultDataAreaUrl   as character       serialize-name "defaultDataArea_url"  
     field DefaultIndexAreaName as character       serialize-name "defaultIndexAreaName" /* Must be valid TII area */
     field DefaultIndexAreaUrl  as character       serialize-name "defaultIndexArea_url"  
     field DefaultLobAreaName   as character       serialize-name "defaultLobAreaName" /* Must be valid TII area */
     field DefaultLobAreaUrl    as character       serialize-name "defaultLobArea_url"  
     field DefaultAllocation    as character       serialize-hidden
     
     field StringValues         as character       serialize-name "values" extent 15  
 
    {daschema/entity.i}
   
    index idxName       as  primary unique Name
    index idxPolicy         PartitionPolicyName  InternalSort
    index idxObj            ObjectNumber  
 .
    
