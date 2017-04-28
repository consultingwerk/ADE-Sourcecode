/*************************************************************/
/* Copyright (c) 2010-2013 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : partition.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Summer 2010
    Notes       :
  ----------------------------------------------------------------------*/
 
define  temp-table ttPartition no-undo  serialize-name "partitions" {1} before-table ttPartitionCopy
 
         field SchemaName as character         serialize-name "schemaName" format "x(3)" label "Schema" init "PUB"
         field ObjectType as character         serialize-name "objectType" format "x(5)" label "Type"

         field TableName  as character         serialize-name "tableName" format "x(20)" label "Table"   

         field SchemaElementUrl  as character  serialize-name "schemaElement_url" format "x(20)" label "Element url"

         field IndexName  as character         serialize-name "indexName"   format "x(20)" label "Index"  
         field FieldName  as character         serialize-name "fieldName"   format "x(20)" label "Field"  
         field Collation  as character         serialize-name "collation"   format "x(20)" label "Collation"  
         field AreaName   as character         serialize-name "areaName"    format "x(20)" label "Area"
          /* we can use different name since this will never be updated from client */
         field AreaUrl             as character serialize-name "area_url"  format "x(32)" label "Area url"
         field TenantName          as character serialize-name "tenantName" format "x(32)" label "Tenant"  init ? 
         field TenantId           as integer  init ? serialize-hidden   
         field TenantUrl          as character serialize-name "tenant_url" format "x(20)" label "Tenant url"
        
         field PartitionPolicyDetailName as character serialize-name "partitionPolicyDetailName" format "x(32)" label "PolicyDetail"  init ? 
         field PartitionPolicyDetailId   as integer  init ? serialize-hidden   
         field PartitionPolicyDetailUrl  as character serialize-name "partitionPolicyDetail_url" format "x(20)" label "partitionPolicyDetail url"  
         
         //field CdcTablePolicyName as character serialize-name "cdcTablePolicyName" format "x(32)" label "TablePolicy"  init ? 
         //field CdcPolicyId   as integer  init ? serialize-hidden   
         //field CdcFieldPolicyUrl  as character serialize-name "cdcFieldPolicy_Url" format "x(20)" label "CdcFieldPolicy Url"  
          
         field TenantGroupName as character serialize-name "tenantGroupName" format "x(20)" label "TenantGroup" init ?
         field TenantGroupId   as integer   init ? serialize-hidden    
         field TenantGroupUrl  as character serialize-name "tenantGroup_url" format "x(20)" label "TenantGroup url"  
         field DeallocateUrl      as character serialize-name "deallocate_url" format "x(20)" label "TenantGroup url"  
         field AllocationState    as character serialize-name "allocationState" format "x(9)"
         field BufferPool         as character serialize-name "bufferPool" format "x(9)"
               init "Primary" 
         field CanAssignAlternateBufferPool as logical serialize-name "canAssignAlternateBufferPool" 
               init true
         field ParentId  as integer serialize-hidden init ?
         field trowid as rowid serialize-hidden
         
/*         field URL        as character          serialize-name "url"*/
        
         {daschema/entity.i}
         /* deprecate - introduction of groups means that aprtions can be deletd and recreated
            with the same rowid . 
            it is kept unique for now as existing runtime fill "replace" could depend on this 
            it is set to unknown in after row...          
          */
         index idx as unique trowid   
         /* primary key is used in copy-table datarefresh
            @todo  - remove tentatGroupName ? -  */
         index idxpart  as primary unique TenantName TenantGroupName PartitionPolicyDetailName TableName  FieldName IndexName  Collation 
/*         index idxparttenant as unique  TenantName TableName  FieldName IndexName  Collation*/
         index idxpartgroup   as unique  TenantGroupName TableName FieldName IndexName  Collation
         index idxpartpolicy  as unique  PartitionPolicyDetailName TableName FieldName IndexName  Collation
/*         index idxtenant  TenantName TableName*/
         index idxarea    AreaName TenantName TenantGroupName
         index idxtable   TableName
         index idxTenantId   TenantId
         index idxTenantGroupId   TenantGroupId
         index idxPartitionPolicyDetailId   PartitionPolicyDetailId
         //index idxCdcPolicyId   CdcPolicyId
         .
          
        
       