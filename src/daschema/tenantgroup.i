/*************************************************************/
/* Copyright (c) 2010,2011 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : tenantgroup.i
    Author(s)   : hdaniels
    Created     : 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttTenantGroup no-undo serialize-name "tenantGroups"  {1} 
                                         before-table ttTenantGroupCopy
     field Id              as integer   serialize-hidden
     field Name            as character serialize-name "name"
     field IsAllocated     as logical   serialize-name "isAllocated"
     field Url             as character serialize-name "url"
     field Description     as character serialize-name "description"
     field Type            as character serialize-hidden /*serialize-name "type" */
     /* needed for fill of children */
     field ObjectType      as int serialize-hidden
     field ObjectNumber    as int serialize-hidden
     
     field SchemaName      as character serialize-name "schemaName"
     field TableName       as character serialize-name "tableName"
     field TableUrl        as character serialize-name "table_url"
     field DefaultDataAreaName as character serialize-name "defaultDataAreaName"
     field DefaultIndexAreaName  as character serialize-name "defaultIndexAreaName"
     field DefaultLobAreaName    as character serialize-name "defaultLobAreaName"
     field DefaultAllocation     as character serialize-name "defaultAllocation"
     field PartitionsUrl   as character serialize-hidden /* name "partitions_url" */
     field DeallocateUrl        as character serialize-name "deallocate_url"
     
     {daschema/entity.i}  
     index idxId  Id
     index idxName as primary unique Name
     index idxTable TableName
     index idxType Type.
    
    
