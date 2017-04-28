
/*------------------------------------------------------------------------
    File        : cdc.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Dec 01 12:54:59 IST 2015
    Notes       :
  ----------------------------------------------------------------------*/

define  temp-table ttCdc no-undo  serialize-name "cdcs" {1} before-table ttCdcCopy
 
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
        
         field CdcTablePolicyName as character serialize-name "cdcTablePolicyName" format "x(32)" label "FieldPolicy"  init ? 
         field CdcPolicyId   as integer  init ? serialize-hidden   
         field CdcFieldPolicyUrl  as character serialize-name "cdcFieldPolicy_url" format "x(20)" label "cdcFieldPolicy url"  
          
         field TenantGroupName as character serialize-name "tenantGroupName" format "x(20)" label "TenantGroup" init ?
         field TenantGroupId   as integer   init ? serialize-hidden    
         field TenantGroupUrl  as character serialize-name "tenantGroup_url" format "x(20)" label "TenantGroup url"  
         //field DeallocateUrl      as character serialize-name "deallocate_url" format "x(20)" label "TenantGroup url"  
         //field AllocationState    as character serialize-name "allocationState" format "x(9)"
         //field BufferPool         as character serialize-name "bufferPool" format "x(9)"
         //      init "Primary" 
         //field CanAssignAlternateBufferPool as logical serialize-name "canAssignAlternateBufferPool" 
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
         index idxpart  as primary unique TenantName TenantGroupName CdcTablePolicyName TableName  FieldName IndexName  Collation 
/*         index idxparttenant as unique  TenantName TableName  FieldName IndexName  Collation*/
         index idxpartgroup   as unique  TenantGroupName TableName FieldName IndexName  Collation
         index idxpartpolicy  as unique  CdcTablePolicyName TableName FieldName IndexName  Collation
/*         index idxtenant  TenantName TableName*/
         index idxarea    AreaName TenantName TenantGroupName
         index idxtable   TableName
         index idxTenantId   TenantId
         index idxTenantGroupId   TenantGroupId
         index idxCdcPolicyId   CdcPolicyId
         .
          